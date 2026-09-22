import { initializeApp } from 'firebase-admin/app';
import { FieldValue, getFirestore } from 'firebase-admin/firestore';
import { getDatabase, ServerValue } from 'firebase-admin/database';
import { HttpsError, onCall } from 'firebase-functions/v2/https';

import {
  applyMorrisCommand,
  commandFromUnknown,
  GameId,
  initialMorrisState,
  MorrisState,
  MorrisValidationError,
  Side,
} from './morris';

initializeApp();
const db = getFirestore();
const rtdb = getDatabase();

const allowedGameIds = new Set<GameId>(['three', 'nine', 'twelve']);
const allowedChallengeStates = new Set([
  'pending', 'accepted', 'inProgress', 'completed', 'declined', 'expired', 'cancelled',
]);
const allowedQuickMessages = new Set([
  'QUICK_01', 'QUICK_02', 'QUICK_03', 'QUICK_04', 'QUICK_05', 'QUICK_06',
]);

const callableOptions = {
  enforceAppCheck: true,
};

type ChallengeRecord = {
  senderId: string;
  receiverId: string;
  gameId: GameId;
  status: string;
  matchId?: string;
};

type LiveMatch = {
  gameId: GameId;
  challengeId?: string | null;
  status: 'inProgress' | 'completed';
  players: Record<string, boolean>;
  sides: { light: string; dark: string };
  state: MorrisState;
  revision: number;
  createdAt?: unknown;
  updatedAt?: unknown;
  completedAt?: unknown;
  lastMove?: {
    by: string;
    side: Side;
    command: unknown;
    revision: number;
    at: unknown;
  } | null;
};

function requireUid(uid: string | undefined): string {
  if (!uid) throw new HttpsError('unauthenticated', 'Authentication required.');
  return uid;
}

function asGameId(value: unknown): GameId {
  const gameId = String(value ?? '') as GameId;
  if (!allowedGameIds.has(gameId)) {
    throw new HttpsError('invalid-argument', 'Invalid game.');
  }
  return gameId;
}

function asNonEmptyId(value: unknown, label: string): string {
  const result = String(value ?? '').trim();
  if (!result) throw new HttpsError('invalid-argument', `Missing ${label}.`);
  return result;
}

function deterministicSides(challengeId: string, senderId: string, receiverId: string) {
  const checksum = [...challengeId].reduce((sum, char) => sum + char.charCodeAt(0), 0);
  return checksum % 2 === 0
    ? { light: senderId, dark: receiverId }
    : { light: receiverId, dark: senderId };
}

async function ensureChallengeMatch(
  challengeId: string,
  challenge: ChallengeRecord,
): Promise<{ matchId: string; sides: { light: string; dark: string } }> {
  const matchId = `challenge_${challengeId}`;
  const sides = deterministicSides(challengeId, challenge.senderId, challenge.receiverId);
  const matchRef = rtdb.ref(`liveMatches/${matchId}`);

  const result = await matchRef.transaction((current) => {
    if (current != null) {
      const existing = current as Partial<LiveMatch>;
      if (
        existing.gameId !== challenge.gameId ||
        existing.challengeId !== challengeId
      ) {
        throw new HttpsError('already-exists', 'Match id collision.');
      }
      return current;
    }

    const match: LiveMatch = {
      gameId: challenge.gameId,
      challengeId,
      status: 'inProgress',
      players: {
        [challenge.senderId]: true,
        [challenge.receiverId]: true,
      },
      sides,
      state: initialMorrisState(challenge.gameId),
      revision: 0,
      createdAt: ServerValue.TIMESTAMP,
      updatedAt: ServerValue.TIMESTAMP,
      lastMove: null,
    };
    return match;
  }, undefined, false);

  if (!result.committed && !result.snapshot.exists()) {
    throw new HttpsError('aborted', 'Could not create match.');
  }
  return { matchId, sides };
}

async function finalizeCompletedMatch(matchId: string, match: LiveMatch): Promise<void> {
  const winnerSide = match.state.winner ?? null;
  const winnerId = winnerSide == null ? null : match.sides[winnerSide];
  const playerIds = [match.sides.light, match.sides.dark];

  await db.collection('matchHistory').doc(matchId).set({
    gameId: match.gameId,
    challengeId: match.challengeId ?? null,
    playerIds,
    sides: match.sides,
    winnerId,
    isDraw: match.state.isDraw === true,
    finalRevision: match.revision,
    completedAt: FieldValue.serverTimestamp(),
  }, { merge: true });

  if (match.challengeId) {
    const challengeRef = db.collection('challenges').doc(match.challengeId);
    await challengeRef.set({
      status: 'completed',
      matchId,
      winnerId,
      isDraw: match.state.isDraw === true,
      updatedAt: FieldValue.serverTimestamp(),
      completedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
  }
}

export const createChallenge = onCall(callableOptions, async (request) => {
  const senderId = requireUid(request.auth?.uid);
  const receiverId = asNonEmptyId(request.data?.receiverId, 'receiverId');
  const gameId = asGameId(request.data?.gameId);
  if (receiverId === senderId) {
    throw new HttpsError('invalid-argument', 'Cannot challenge yourself.');
  }

  const ref = db.collection('challenges').doc();
  await ref.set({
    senderId,
    receiverId,
    gameId,
    status: 'pending',
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  });
  return { challengeId: ref.id };
});

export const respondToChallenge = onCall(callableOptions, async (request) => {
  const uid = requireUid(request.auth?.uid);
  const challengeId = asNonEmptyId(request.data?.challengeId, 'challengeId');
  const action = String(request.data?.action ?? '');
  if (!['accepted', 'declined'].includes(action)) {
    throw new HttpsError('invalid-argument', 'Invalid challenge action.');
  }

  const ref = db.collection('challenges').doc(challengeId);
  let challenge: ChallengeRecord | null = null;

  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) throw new HttpsError('not-found', 'Challenge not found.');
    const data = snap.data() as ChallengeRecord;
    if (data.receiverId !== uid) throw new HttpsError('permission-denied', 'Not receiver.');
    asGameId(data.gameId);

    if (action === 'declined') {
      if (data.status !== 'pending') {
        throw new HttpsError('failed-precondition', 'Challenge is not pending.');
      }
      tx.update(ref, {
        status: 'declined',
        updatedAt: FieldValue.serverTimestamp(),
      });
      challenge = { ...data, status: 'declined' };
      return;
    }

    if (data.status === 'inProgress' && data.matchId) {
      challenge = data;
      return;
    }
    if (!['pending', 'accepted'].includes(data.status)) {
      throw new HttpsError('failed-precondition', 'Challenge can no longer be accepted.');
    }
    if (data.status === 'pending') {
      tx.update(ref, {
        status: 'accepted',
        updatedAt: FieldValue.serverTimestamp(),
      });
    }
    challenge = { ...data, status: 'accepted' };
  });

  if (action === 'declined') return { ok: true };
  if (challenge == null) throw new HttpsError('internal', 'Challenge state unavailable.');

  const current = challenge as ChallengeRecord;
  if (current.status === 'inProgress' && current.matchId) {
    return { ok: true, matchId: current.matchId };
  }

  const started = await ensureChallengeMatch(challengeId, current);
  await ref.set({
    status: 'inProgress',
    matchId: started.matchId,
    lightPlayerId: started.sides.light,
    darkPlayerId: started.sides.dark,
    updatedAt: FieldValue.serverTimestamp(),
    startedAt: FieldValue.serverTimestamp(),
  }, { merge: true });
  return { ok: true, matchId: started.matchId };
});

export const createRematch = onCall(callableOptions, async (request) => {
  const uid = requireUid(request.auth?.uid);
  const challengeId = asNonEmptyId(request.data?.challengeId, 'challengeId');
  const oldRef = db.collection('challenges').doc(challengeId);
  const oldSnap = await oldRef.get();
  if (!oldSnap.exists) throw new HttpsError('not-found', 'Challenge not found.');
  const old = oldSnap.data() as ChallengeRecord;
  if (![old.senderId, old.receiverId].includes(uid)) {
    throw new HttpsError('permission-denied', 'Not a challenge participant.');
  }
  if (old.status !== 'completed') {
    throw new HttpsError('failed-precondition', 'Only completed challenges can be rematched.');
  }
  const receiverId = uid === old.senderId ? old.receiverId : old.senderId;
  const ref = db.collection('challenges').doc();
  await ref.set({
    senderId: uid,
    receiverId,
    gameId: asGameId(old.gameId),
    status: 'pending',
    rematchOf: challengeId,
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  });
  return { challengeId: ref.id };
});

export const submitMove = onCall(callableOptions, async (request) => {
  const uid = requireUid(request.auth?.uid);
  const matchId = asNonEmptyId(request.data?.matchId, 'matchId');
  const expectedRevision = Number(request.data?.expectedRevision);
  if (!Number.isInteger(expectedRevision) || expectedRevision < 0) {
    throw new HttpsError('invalid-argument', 'expectedRevision must be a non-negative integer.');
  }

  let command;
  try {
    command = commandFromUnknown(request.data?.command);
  } catch (error) {
    if (error instanceof MorrisValidationError) {
      throw new HttpsError('invalid-argument', error.code);
    }
    throw error;
  }

  const matchRef = rtdb.ref(`liveMatches/${matchId}`);
  let committedMatch: LiveMatch | null = null;

  try {
    const result = await matchRef.transaction((current) => {
      if (current == null) throw new HttpsError('not-found', 'Match not found.');
      const match = current as LiveMatch;
      const gameId = asGameId(match.gameId);
      if (match.status !== 'inProgress') {
        throw new HttpsError('failed-precondition', 'Match is not active.');
      }
      if (match.players?.[uid] !== true) {
        throw new HttpsError('permission-denied', 'Not a participant.');
      }
      if (!Number.isInteger(match.revision) || match.revision !== expectedRevision) {
        throw new HttpsError('aborted', 'Match revision changed. Refresh and retry.');
      }
      if (!match.sides || !match.state) {
        throw new HttpsError('data-loss', 'Match state is incomplete.');
      }

      const expectedUid = match.sides[match.state.turn];
      if (expectedUid !== uid) {
        throw new HttpsError('failed-precondition', 'It is not your turn.');
      }

      let nextState: MorrisState;
      try {
        nextState = applyMorrisCommand(gameId, match.state, command);
      } catch (error) {
        if (error instanceof MorrisValidationError) {
          throw new HttpsError('failed-precondition', error.code);
        }
        throw error;
      }

      const nextRevision = match.revision + 1;
      const completed = nextState.winner != null || nextState.isDraw === true;
      const next: LiveMatch = {
        ...match,
        gameId,
        state: nextState,
        revision: nextRevision,
        status: completed ? 'completed' : 'inProgress',
        updatedAt: ServerValue.TIMESTAMP,
        ...(completed ? { completedAt: ServerValue.TIMESTAMP } : {}),
        lastMove: {
          by: uid,
          side: match.state.turn,
          command,
          revision: nextRevision,
          at: ServerValue.TIMESTAMP,
        },
      };
      return next;
    }, undefined, false);

    if (!result.committed || !result.snapshot.exists()) {
      throw new HttpsError('aborted', 'Move was not committed.');
    }
    committedMatch = result.snapshot.val() as LiveMatch;
  } catch (error) {
    if (error instanceof HttpsError) throw error;
    throw new HttpsError('internal', 'Move transaction failed.');
  }

  if (committedMatch == null) {
    throw new HttpsError('internal', 'Committed match was not returned.');
  }
  const finalMatch = committedMatch as LiveMatch;
  if (finalMatch.status === 'completed') {
    await finalizeCompletedMatch(matchId, finalMatch);
  }

  return {
    ok: true,
    revision: finalMatch.revision,
    status: finalMatch.status,
    state: finalMatch.state,
  };
});

export const sendQuickMessage = onCall(callableOptions, async (request) => {
  const uid = requireUid(request.auth?.uid);
  const matchId = asNonEmptyId(request.data?.matchId, 'matchId');
  const messageId = String(request.data?.messageId ?? '');
  if (!allowedQuickMessages.has(messageId)) {
    throw new HttpsError('invalid-argument', 'Invalid quick message.');
  }

  const matchRef = rtdb.ref(`liveMatches/${matchId}`);
  const snapshot = await matchRef.get();
  if (!snapshot.exists()) throw new HttpsError('not-found', 'Match not found.');
  const match = snapshot.val() as LiveMatch;
  if (match.players?.[uid] !== true) {
    throw new HttpsError('permission-denied', 'Not a participant.');
  }

  const messageRef = matchRef.child('messages').push();
  await messageRef.set({
    senderId: uid,
    messageId,
    createdAt: ServerValue.TIMESTAMP,
  });
  return { ok: true, messageKey: messageRef.key };
});

export const validateChallengeState = onCall(callableOptions, async (request) => {
  requireUid(request.auth?.uid);
  const status = String(request.data?.status ?? '');
  return { valid: allowedChallengeStates.has(status) };
});
