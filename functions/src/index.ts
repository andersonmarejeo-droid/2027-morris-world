import { initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { FieldValue, getFirestore, Timestamp } from 'firebase-admin/firestore';
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

// The Functions emulator does not consistently forward the Auth emulator host
// to v2 workers on Windows. Set the documented local default before the Admin
// SDK is first used; production environments keep their managed Auth endpoint.
const isFunctionsEmulator = process.env.FUNCTIONS_EMULATOR === 'true';
if (isFunctionsEmulator && !process.env.FIREBASE_AUTH_EMULATOR_HOST) {
  process.env.FIREBASE_AUTH_EMULATOR_HOST = '127.0.0.1:9099';
}
if (isFunctionsEmulator && !process.env.FIREBASE_DATABASE_EMULATOR_HOST) {
  process.env.FIREBASE_DATABASE_EMULATOR_HOST = '127.0.0.1:9000';
}

const emulatorProjectId = process.env.GCLOUD_PROJECT ?? 'demo-morris-world';
const app = isFunctionsEmulator
  ? initializeApp({
      projectId: emulatorProjectId,
      // Keep every v2 worker on the same explicit local RTDB namespace. The
      // production app is initialized from its deployed Firebase config.
      databaseURL: `http://${process.env.FIREBASE_DATABASE_EMULATOR_HOST}?ns=${emulatorProjectId}`,
    })
  : initializeApp();
const db = getFirestore(app);
const rtdb = getDatabase(app);

const allowedGameIds = new Set<GameId>(['three', 'nine', 'twelve']);
const allowedChallengeStates = new Set([
  'pending', 'accepted', 'inProgress', 'completed', 'declined', 'expired', 'cancelled',
]);
const allowedQuickMessages = new Set([
  'QUICK_01', 'QUICK_02', 'QUICK_03', 'QUICK_04', 'QUICK_05', 'QUICK_06',
]);
const challengeLifetimeMs = 15 * 60 * 1000;

const rateLimitPolicies = {
  challenge: { limit: 6, windowMs: 60 * 1000 },
  rematch: { limit: 4, windowMs: 60 * 1000 },
  move: { limit: 90, windowMs: 60 * 1000 },
  quickMessage: { limit: 12, windowMs: 60 * 1000 },
  reconcile: { limit: 8, windowMs: 60 * 1000 },
} as const;
type RateLimitAction = keyof typeof rateLimitPolicies;

const callableOptions = {
  region: 'europe-west1',
  // There is no App Check emulator. Production calls always require attestation;
  // this explicit local-only exception lets the emulator test the server logic.
  enforceAppCheck: !isFunctionsEmulator,
};

type ChallengeRecord = {
  senderId: string;
  receiverId: string;
  gameId: GameId;
  status: string;
  matchId?: string;
  expiresAt?: unknown;
};

const rtdbEmptyCell = 'empty' as const;

// RTDB treats null children as deletions. Persist an explicit empty-cell value
// so a new Morris board keeps its full length across server workers.
type StoredMorrisState = Omit<MorrisState, 'board'> & {
  board: Array<Side | typeof rtdbEmptyCell>;
};

type LiveMatch = {
  gameId: GameId;
  challengeId?: string | null;
  status: 'inProgress' | 'completed';
  players: Record<string, boolean>;
  sides: { light: string; dark: string };
  state: StoredMorrisState;
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
  finalization?: {
    status: 'pending' | 'completed';
    attempts?: number;
  };
};

function storeMorrisState(state: MorrisState): StoredMorrisState {
  return {
    ...state,
    board: state.board.map((cell) => cell ?? rtdbEmptyCell),
    pendingCaptureBy: state.pendingCaptureBy ?? null,
    winner: state.winner ?? null,
    isDraw: state.isDraw === true,
    movesWithoutCapture: state.movesWithoutCapture ?? 0,
  };
}

function restoreMorrisState(gameId: GameId, source: unknown): MorrisState {
  if (source == null || typeof source !== 'object') {
    throw new HttpsError('data-loss', 'Match state is incomplete.');
  }
  const raw = source as Record<string, unknown>;
  const boardSource = raw.board;
  const expectedBoardLength = initialMorrisState(gameId).board.length;
  const board = Array.from({ length: expectedBoardLength }, (_, index): Side | null => {
    const cell = Array.isArray(boardSource)
      ? boardSource[index]
      : boardSource != null && typeof boardSource === 'object'
      ? (boardSource as Record<string, unknown>)[String(index)]
      : null;
    if (cell === 'light' || cell === 'dark') return cell;
    if (cell == null || cell === rtdbEmptyCell) return null;
    throw new HttpsError('data-loss', 'Match board contains an invalid cell.');
  });

  return {
    board,
    turn: raw.turn as Side,
    lightToPlace: raw.lightToPlace as number,
    darkToPlace: raw.darkToPlace as number,
    pendingCaptureBy: (raw.pendingCaptureBy ?? null) as Side | null,
    winner: (raw.winner ?? null) as Side | null,
    isDraw: raw.isDraw === true,
    movesWithoutCapture: (raw.movesWithoutCapture ?? 0) as number,
  };
}

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
  if (!result || result.length > 128 || /[\u0000-\u001f]/.test(result)) {
    throw new HttpsError('invalid-argument', `Invalid ${label}.`);
  }
  return result;
}

async function enforceRateLimit(uid: string, action: RateLimitAction): Promise<void> {
  const policy = rateLimitPolicies[action];
  const now = Date.now();
  const ref = db.collection('_rateLimits').doc(`${action}_${uid}`);

  await db.runTransaction(async (tx) => {
    const snapshot = await tx.get(ref);
    const data = snapshot.data() ?? {};
    const previousStart = Number(data.windowStartedAtMs);
    const sameWindow = Number.isFinite(previousStart) && now - previousStart < policy.windowMs;
    const windowStartedAtMs = sameWindow ? previousStart : now;
    const previousCount = sameWindow ? Number(data.count) : 0;
    const count = Number.isFinite(previousCount) && previousCount >= 0
      ? Math.floor(previousCount)
      : 0;

    if (count >= policy.limit) {
      throw new HttpsError('resource-exhausted', 'Please wait before trying again.');
    }

    tx.set(ref, {
      uid,
      action,
      count: count + 1,
      windowStartedAtMs,
      updatedAt: FieldValue.serverTimestamp(),
      // This is a Firestore TTL candidate. Enable TTL for this field in the
      // selected Firebase project before production activation.
      expiresAt: Timestamp.fromMillis(windowStartedAtMs + policy.windowMs * 2),
    }, { merge: true });
  });
}

async function requireKnownUser(uid: string): Promise<void> {
  try {
    await getAuth().getUser(uid);
  } catch {
    throw new HttpsError('not-found', 'Player account not found.');
  }
}

async function ensurePlayersMayInteract(senderId: string, receiverId: string): Promise<void> {
  const [senderBlocked, receiverBlocked] = await Promise.all([
    db.doc(`users/${senderId}/blocks/${receiverId}`).get(),
    db.doc(`users/${receiverId}/blocks/${senderId}`).get(),
  ]);
  if (senderBlocked.exists || receiverBlocked.exists) {
    throw new HttpsError('permission-denied', 'This player interaction is unavailable.');
  }
}

function timestampMillis(value: unknown): number | null {
  if (value instanceof Timestamp) return value.toMillis();
  if (
    value != null &&
    typeof value === 'object' &&
    'toMillis' in value &&
    typeof (value as { toMillis?: unknown }).toMillis === 'function'
  ) {
    const result = (value as { toMillis: () => unknown }).toMillis();
    return typeof result === 'number' && Number.isFinite(result) ? result : null;
  }
  return null;
}

function challengeHasExpired(challenge: ChallengeRecord, now = Date.now()): boolean {
  const expiresAt = timestampMillis(challenge.expiresAt);
  return expiresAt != null && expiresAt <= now;
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
      state: storeMorrisState(initialMorrisState(challenge.gameId)),
      revision: 0,
      createdAt: ServerValue.TIMESTAMP,
      updatedAt: ServerValue.TIMESTAMP,
      lastMove: null,
    };
    return match;
  });

  if (!result.committed && !result.snapshot.exists()) {
    throw new HttpsError('aborted', 'Could not create match.');
  }
  const persisted = await matchRef.get();
  if (!persisted.exists()) {
    throw new HttpsError('aborted', 'Could not persist match.');
  }
  return { matchId, sides };
}

async function finalizeCompletedMatch(matchId: string, match: LiveMatch): Promise<void> {
  const winnerSide = match.state.winner ?? null;
  const winnerId = winnerSide == null ? null : match.sides[winnerSide];
  const playerIds = [match.sides.light, match.sides.dark];

  // Firestore history and its linked challenge must move together. RTDB is the
  // live-state source, so a cross-database completion can never be atomic, but
  // this transaction eliminates a second partial-write window inside Firestore.
  await db.runTransaction(async (tx) => {
    tx.set(db.collection('matchHistory').doc(matchId), {
      gameId: match.gameId,
      challengeId: match.challengeId ?? null,
      playerIds,
      sides: match.sides,
      winnerId,
      isDraw: match.state.isDraw === true,
      finalRevision: match.revision,
      completedAt: FieldValue.serverTimestamp(),
    }, { merge: true });

    if (!match.challengeId) return;
    tx.set(db.collection('challenges').doc(match.challengeId), {
      status: 'completed',
      matchId,
      winnerId,
      isDraw: match.state.isDraw === true,
      updatedAt: FieldValue.serverTimestamp(),
      completedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
  });
}

async function markFinalization(
  matchRef: ReturnType<typeof rtdb.ref>,
  status: 'pending' | 'completed',
): Promise<void> {
  const finalizationRef = matchRef.child('finalization');
  await finalizationRef.transaction((current) => {
    const previous = current != null && typeof current === 'object'
      ? current as { attempts?: unknown }
      : {};
    const attempts = Number(previous.attempts);
    return {
      status,
      attempts: Number.isFinite(attempts) && attempts >= 0 ? Math.floor(attempts) + 1 : 1,
      updatedAt: ServerValue.TIMESTAMP,
    };
  });
}

async function finalizeCompletedMatchSafely(
  matchId: string,
  match: LiveMatch,
): Promise<'completed' | 'pending'> {
  const matchRef = rtdb.ref(`liveMatches/${matchId}`);
  try {
    await finalizeCompletedMatch(matchId, match);
    await markFinalization(matchRef, 'completed');
    return 'completed';
  } catch {
    // The player-facing result is already authoritative in RTDB. Persist a
    // non-secret recovery marker and expose an idempotent reconciliation path
    // instead of pretending the match failed or losing the completed result.
    try {
      await markFinalization(matchRef, 'pending');
    } catch {
      // Do not leak provider errors to callers. Operations must alert on any
      // completed match without Firestore history, as documented in the runbook.
    }
    return 'pending';
  }
}

export const createChallenge = onCall(callableOptions, async (request) => {
  const senderId = requireUid(request.auth?.uid);
  const receiverId = asNonEmptyId(request.data?.receiverId, 'receiverId');
  const gameId = asGameId(request.data?.gameId);
  if (receiverId === senderId) {
    throw new HttpsError('invalid-argument', 'Cannot challenge yourself.');
  }

  await Promise.all([
    enforceRateLimit(senderId, 'challenge'),
    requireKnownUser(receiverId),
    ensurePlayersMayInteract(senderId, receiverId),
  ]);

  const ref = db.collection('challenges').doc();
  await ref.set({
    senderId,
    receiverId,
    gameId,
    status: 'pending',
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
    // Firestore TTL must be enabled for this field per environment. The
    // callable also enforces expiry immediately, so TTL delay never revives a
    // challenge in gameplay.
    expiresAt: Timestamp.fromMillis(Date.now() + challengeLifetimeMs),
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
  var expired = false;

  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) throw new HttpsError('not-found', 'Challenge not found.');
    const data = snap.data() as ChallengeRecord;
    if (data.receiverId !== uid) throw new HttpsError('permission-denied', 'Not receiver.');
    asGameId(data.gameId);

    if (['pending', 'accepted'].includes(data.status) && challengeHasExpired(data)) {
      tx.update(ref, {
        status: 'expired',
        updatedAt: FieldValue.serverTimestamp(),
      });
      expired = true;
      return;
    }

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

  if (expired) {
    throw new HttpsError('failed-precondition', 'Challenge has expired.');
  }
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
  // The receiver is already a verified match participant. Returning this
  // compact initial snapshot avoids a second client round trip before the
  // normal RTDB subscription takes over.
  return {
    ok: true,
    matchId: started.matchId,
    status: 'inProgress',
    revision: 0,
    sides: started.sides,
    state: initialMorrisState(current.gameId),
  };
});

export const createRematch = onCall(callableOptions, async (request) => {
  const uid = requireUid(request.auth?.uid);
  const challengeId = asNonEmptyId(request.data?.challengeId, 'challengeId');
  await enforceRateLimit(uid, 'rematch');
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
  await ensurePlayersMayInteract(uid, receiverId);
  const ref = db.collection('challenges').doc();
  await ref.set({
    senderId: uid,
    receiverId,
    gameId: asGameId(old.gameId),
    status: 'pending',
    rematchOf: challengeId,
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
    expiresAt: Timestamp.fromMillis(Date.now() + challengeLifetimeMs),
  });
  return { challengeId: ref.id };
});

export const submitMove = onCall(callableOptions, async (request) => {
  const uid = requireUid(request.auth?.uid);
  await enforceRateLimit(uid, 'move');
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
  const beforeMove = await matchRef.get();
  if (!beforeMove.exists()) {
    throw new HttpsError('not-found', 'Match not found.');
  }
  const verifiedMatch = beforeMove.val() as LiveMatch;

  try {
    const result = await matchRef.transaction((current) => {
      // A cold RTDB worker can begin a transaction with an empty local cache
      // even after `get()` has confirmed the match exists. Use that verified
      // snapshot as the first candidate; RTDB retries against canonical data
      // before committing when another move has changed it.
      const match = (current ?? verifiedMatch) as LiveMatch;
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

      const currentState = restoreMorrisState(gameId, match.state);
      const expectedUid = match.sides[currentState.turn];
      if (expectedUid !== uid) {
        throw new HttpsError('failed-precondition', 'It is not your turn.');
      }

      let nextState: MorrisState;
      try {
        nextState = applyMorrisCommand(gameId, currentState, command);
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
        state: storeMorrisState(nextState),
        revision: nextRevision,
        status: completed ? 'completed' : 'inProgress',
        updatedAt: ServerValue.TIMESTAMP,
        ...(completed ? { completedAt: ServerValue.TIMESTAMP } : {}),
        lastMove: {
          by: uid,
          side: currentState.turn,
          command,
          revision: nextRevision,
          at: ServerValue.TIMESTAMP,
        },
      };
      return next;
    });

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
  let finalization = 'not-required';
  if (finalMatch.status === 'completed') {
    finalization = await finalizeCompletedMatchSafely(matchId, finalMatch);
  }

  return {
    ok: true,
    revision: finalMatch.revision,
    status: finalMatch.status,
    state: restoreMorrisState(asGameId(finalMatch.gameId), finalMatch.state),
    finalization,
  };
});

/// Idempotently repairs a completed RTDB match whose Firestore history write
/// was interrupted. Only a participant may request reconciliation; operations
/// should additionally monitor pending markers and investigate their cause.
export const reconcileCompletedMatch = onCall(callableOptions, async (request) => {
  const uid = requireUid(request.auth?.uid);
  await enforceRateLimit(uid, 'reconcile');
  const matchId = asNonEmptyId(request.data?.matchId, 'matchId');
  const snapshot = await rtdb.ref(`liveMatches/${matchId}`).get();
  if (!snapshot.exists()) throw new HttpsError('not-found', 'Match not found.');

  const match = snapshot.val() as LiveMatch;
  if (match.players?.[uid] !== true) {
    throw new HttpsError('permission-denied', 'Not a participant.');
  }
  if (match.status !== 'completed') {
    throw new HttpsError('failed-precondition', 'Match is not complete.');
  }

  const finalization = await finalizeCompletedMatchSafely(matchId, match);
  return { ok: finalization === 'completed', finalization };
});

export const sendQuickMessage = onCall(callableOptions, async (request) => {
  const uid = requireUid(request.auth?.uid);
  await enforceRateLimit(uid, 'quickMessage');
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
  if (match.status !== 'inProgress') {
    throw new HttpsError('failed-precondition', 'Match is not active.');
  }

  const messageRef = matchRef.child('messages').push();
  await messageRef.set({
    senderId: uid,
    messageId,
    createdAt: ServerValue.TIMESTAMP,
    expiresAtMs: Date.now() + 10 * 60 * 1000,
  });
  return { ok: true, messageKey: messageRef.key };
});

export const validateChallengeState = onCall(callableOptions, async (request) => {
  requireUid(request.auth?.uid);
  const status = String(request.data?.status ?? '');
  return { valid: allowedChallengeStates.has(status) };
});
