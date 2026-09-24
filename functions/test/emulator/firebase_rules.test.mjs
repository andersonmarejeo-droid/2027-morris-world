import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { after, before, test } from 'node:test';
import { fileURLToPath } from 'node:url';

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';

const projectId = process.env.GCLOUD_PROJECT ?? 'demo-morris-world';
const rootDirectory = fileURLToPath(new URL('../../../', import.meta.url));

function endpoint(name, fallbackPort) {
  const [host, port] = (process.env[name] ?? `127.0.0.1:${fallbackPort}`).split(':');
  return { host, port: Number(port) };
}

const firestoreEmulator = endpoint('FIRESTORE_EMULATOR_HOST', 8080);
const databaseEmulator = endpoint('FIREBASE_DATABASE_EMULATOR_HOST', 9000);

const profile = (displayName) => ({
  displayName,
  avatarId: 'classic',
  photoUrl: '',
  countryCode: 'TR',
  updatedAt: new Date(),
});

let environment;
let alice;
let bob;
let charlie;
let mallory;
let aliceFirestore;
let bobFirestore;
let charlieFirestore;
let aliceDatabase;
let malloryDatabase;

before(async () => {
  environment = await initializeTestEnvironment({
    projectId,
    firestore: {
      host: firestoreEmulator.host,
      port: firestoreEmulator.port,
      rules: readFileSync(`${rootDirectory}firestore.rules`, 'utf8'),
    },
    database: {
      host: databaseEmulator.host,
      port: databaseEmulator.port,
      rules: readFileSync(`${rootDirectory}database.rules.json`, 'utf8'),
    },
  });

  await environment.withSecurityRulesDisabled(async (context) => {
    const ownerFirestore = context.firestore();
    const ownerDatabase = context.database();
    await ownerFirestore.doc('users/alice').set(profile('Alice'));
    await ownerFirestore.doc('users/bob').set(profile('Bob'));
    await ownerDatabase.ref('liveMatches/rules-match').set({
      players: { alice: true, bob: true },
      state: { turn: 'light' },
      revision: 0,
    });
  });

  alice = environment.authenticatedContext('alice');
  bob = environment.authenticatedContext('bob');
  charlie = environment.authenticatedContext('charlie');
  mallory = environment.authenticatedContext('mallory');
  aliceFirestore = alice.firestore();
  bobFirestore = bob.firestore();
  charlieFirestore = charlie.firestore();
  aliceDatabase = alice.database();
  malloryDatabase = mallory.database();
});

after(async () => {
  await environment.cleanup();
});

test('only the signed-in owner can create a profile document', async () => {
  await assertSucceeds(
    charlieFirestore.doc('users/charlie').set(profile('Charlie')),
  );
  await assertFails(
    aliceFirestore.doc('users/charlie').set(profile('Alice Override')),
  );
});

test('live match data is readable only by its participants', async () => {
  const snapshot = await assertSucceeds(
    aliceDatabase.ref('liveMatches/rules-match').once('value'),
  );
  assert.equal(snapshot.val().revision, 0);
  await assertFails(malloryDatabase.ref('liveMatches/rules-match').once('value'));
});

test('no client can write a live match directly', async () => {
  await assertFails(
    aliceDatabase.ref('liveMatches/rules-match/revision').set(1),
  );
});

test('challenge documents remain backend-write-only', async () => {
  await assertFails(
    aliceFirestore.doc('challenges/forged').set({
      senderId: 'alice',
      receiverId: 'bob',
      gameId: 'nine',
      status: 'pending',
    }),
  );
  await assertFails(aliceFirestore.doc('challenges/forged').get());
});

test('a player can only manage their own block list', async () => {
  await assertSucceeds(
    aliceFirestore.doc('users/alice/blocks/mallory').set({
      createdAt: new Date(),
    }),
  );
  await assertFails(
    bobFirestore.doc('users/alice/blocks/mallory').set({
      createdAt: new Date(),
    }),
  );
});
