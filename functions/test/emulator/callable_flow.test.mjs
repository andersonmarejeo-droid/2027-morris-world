import assert from 'node:assert/strict';
import { after, before, test } from 'node:test';

import { deleteApp, initializeApp } from 'firebase/app';
import {
  connectAuthEmulator,
  getAuth,
  signInAnonymously,
} from 'firebase/auth';

const projectId = process.env.GCLOUD_PROJECT ?? 'demo-morris-world';
const region = process.env.FUNCTIONS_REGION ?? 'us-central1';

function endpoint(name, fallbackPort) {
  const [host, port] = (process.env[name] ?? `127.0.0.1:${fallbackPort}`).split(':');
  return { host, port: Number(port) };
}

const authEmulator = endpoint('FIREBASE_AUTH_EMULATOR_HOST', 9099);
const functionsEmulator = endpoint('FUNCTIONS_EMULATOR_HOST', 5001);

function emulatorClient(label) {
  const app = initializeApp(
    {
      apiKey: 'local-emulator-key',
      appId: `1:1234567890:web:${label}`,
      projectId,
    },
    `emulator-${label}-${Date.now()}`,
  );
  const auth = getAuth(app);

  connectAuthEmulator(auth, `http://${authEmulator.host}:${authEmulator.port}`, {
    disableWarnings: true,
  });

  return { app, auth, uid: null };
}

async function callFunction(client, name, data) {
  const token = await client.auth.currentUser.getIdToken();
  const response = await fetch(
    `http://${functionsEmulator.host}:${functionsEmulator.port}/${projectId}/${region}/${name}`,
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ data }),
      signal: AbortSignal.timeout(30_000),
    },
  );
  const payload = await response.json();
  if (!response.ok || payload.error) {
    throw new Error(
      `Callable ${name} failed: ${payload.error?.status ?? response.status} ${payload.error?.message ?? ''}`,
    );
  }
  // Direct callable HTTP uses the protocol's legacy `result` envelope, while
  // client SDKs normalize it to `data`. Support both so this remains a wire
  // contract test rather than an SDK implementation detail.
  return payload.data ?? payload.result;
}

let alice;
let bob;

before(async () => {
  alice = emulatorClient('alice');
  bob = emulatorClient('bob');
  alice.uid = (await signInAnonymously(alice.auth)).user.uid;
  bob.uid = (await signInAnonymously(bob.auth)).user.uid;
});

after(async () => {
  await Promise.all([deleteApp(alice.app), deleteApp(bob.app)]);
});

test('authenticated players can create, accept, and advance a challenge match', { timeout: 60_000 }, async () => {
  const created = await callFunction(alice, 'createChallenge', {
    receiverId: bob.uid,
    gameId: 'three',
  });
  const challengeId = created.challengeId;
  assert.equal(typeof challengeId, 'string');

  const accepted = await callFunction(bob, 'respondToChallenge', {
    challengeId,
    action: 'accepted',
  });
  const matchId = accepted.matchId;
  assert.equal(matchId, `challenge_${challengeId}`);
  const initialMatch = accepted;
  assert.equal(initialMatch.revision, 0);
  assert.equal(initialMatch.status, 'inProgress');

  const currentPlayer = initialMatch.sides[initialMatch.state.turn] === alice.uid
    ? alice
    : bob;
  const moved = await callFunction(currentPlayer, 'submitMove', {
    matchId,
    expectedRevision: 0,
    command: { kind: 'place', to: 0 },
  });
  assert.equal(moved.revision, 1);
  assert.equal(moved.status, 'inProgress');
  assert.equal(moved.state.board[0], initialMatch.state.turn);
});
