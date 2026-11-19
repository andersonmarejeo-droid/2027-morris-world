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
const databaseEndpoint = process.env.FIREBASE_DATABASE_EMULATOR_HOST ?? '127.0.0.1:9000';
const [databaseHost, databasePort] = databaseEndpoint.split(':');
const testRoomTimestamp = Date.now();

let environment;
let aliceDatabase;
let bobDatabase;
let malloryDatabase;

const emptyState = (gameId) => {
  const pieces = gameId === 'three' ? 3 : gameId === 'twelve' ? 12 : 9;
  const pointCount = gameId === 'three' ? 9 : 24;
  return {
    board: Array(pointCount).fill(0),
    turn: 'light',
    lightToPlace: pieces,
    darkToPlace: pieces,
    pendingCaptureBy: '',
    winner: '',
    isDraw: false,
    movesWithoutCapture: 0,
  };
};

const privateRoom = (status = 'waiting', guestUid = '', gameId = 'nine') => ({
  schemaVersion: 1,
  gameId,
  status,
  hostUid: 'alice',
  guestUid,
  revision: 0,
  turnUid: 'alice',
  lastMoveBy: '',
  lastFrom: -1,
  lastTo: -1,
  createdAt: testRoomTimestamp,
  updatedAt: testRoomTimestamp,
  state: emptyState(gameId),
});

before(async () => {
  environment = await initializeTestEnvironment({
    projectId,
    database: {
      host: databaseHost,
      port: Number(databasePort),
      rules: readFileSync(`${rootDirectory}database.rules.json`, 'utf8'),
    },
  });

  aliceDatabase = environment.authenticatedContext('alice').database();
  bobDatabase = environment.authenticatedContext('bob').database();
  malloryDatabase = environment.authenticatedContext('mallory').database();
});

after(async () => {
  await environment?.cleanup();
});

test('Spark private rooms support the 3, 9 and 12 stone board sizes', async () => {
  await assertSucceeds(
    aliceDatabase.ref('sparkRooms/threeRoom00000000001').set(
      privateRoom('waiting', '', 'three'),
    ),
  );
  await assertSucceeds(
    aliceDatabase.ref('sparkRooms/nineRoom000000000000').set(privateRoom()),
  );
  await assertSucceeds(
    aliceDatabase.ref('sparkRooms/twelveRoom0000000000').set(
      privateRoom('waiting', '', 'twelve'),
    ),
  );
});

test('private room creation accepts the server timestamps used by the app', async () => {
  const room = privateRoom();
  room.createdAt = { '.sv': 'timestamp' };
  room.updatedAt = { '.sv': 'timestamp' };
  await assertSucceeds(
    aliceDatabase.ref('sparkRooms/servertimestamp12345').set(room),
  );
});

test('known invite code permits joining once, then room reads are participant-only', async () => {
  const roomRef = aliceDatabase.ref('sparkRooms/abcdefghijklmnopqrst');
  await assertSucceeds(roomRef.set(privateRoom()));

  // The opaque Firebase-generated key is the invite credential; no directory
  // or public room listing exists.
  const waitingRoom = await assertSucceeds(
    bobDatabase.ref('sparkRooms/abcdefghijklmnopqrst').once('value'),
  );
  assert.equal(waitingRoom.val().status, 'waiting');

  await assertSucceeds(
    bobDatabase.ref('sparkRooms/abcdefghijklmnopqrst').set(
      privateRoom('active', 'bob'),
    ),
  );
  await assertFails(
    malloryDatabase.ref('sparkRooms/abcdefghijklmnopqrst').once('value'),
  );
  await assertFails(
    malloryDatabase.ref('sparkRooms/abcdefghijklmnopqrst').set(
      privateRoom('active', 'mallory'),
    ),
  );
});

test('RTDB transaction used by the app can claim an unoccupied invite room', async () => {
  const roomId = 'transactionroom12345';
  const hostRoom = aliceDatabase.ref(`sparkRooms/${roomId}`);
  await assertSucceeds(hostRoom.set(privateRoom()));

  const guestRoom = bobDatabase.ref(`sparkRooms/${roomId}`);
  let transactionInput;
  const result = await assertSucceeds(
    guestRoom.transaction((current) => {
      transactionInput = current;
      if (!current) {
        // Transactions can first run against the local cache before the server
        // value arrives. A real room causes a retry with the latest value.
        return null;
      }
      if (current.status !== 'waiting' || current.guestUid !== '') {
        return;
      }
      return {
        ...current,
        guestUid: 'bob',
        status: 'active',
        updatedAt: Date.now(),
      };
    }),
  );

  assert.equal(transactionInput?.status, 'waiting');
  assert.equal(result.committed, true);
  assert.equal(result.snapshot.val().guestUid, 'bob');
  assert.equal(result.snapshot.val().status, 'active');
});

test('only the current participant turn can advance the room revision', async () => {
  const roomRef = aliceDatabase.ref('sparkRooms/zyxwvutsrqponmlkjihg');
  await assertSucceeds(roomRef.set(privateRoom()));
  await assertSucceeds(
    bobDatabase.ref('sparkRooms/zyxwvutsrqponmlkjihg').set(
      privateRoom('active', 'bob'),
    ),
  );

  const hostMove = privateRoom('active', 'bob');
  hostMove.revision = 1;
  hostMove.turnUid = 'bob';
  hostMove.lastMoveBy = 'alice';
  hostMove.lastTo = 0;
  hostMove.updatedAt = 2;
  hostMove.state = {
    ...emptyState('nine'),
    board: [1, ...Array(23).fill(0)],
    turn: 'dark',
    lightToPlace: 8,
  };
  await assertSucceeds(roomRef.set(hostMove));

  await assertFails(
    roomRef.set({
      ...hostMove,
      revision: 2,
      turnUid: 'alice',
      lastMoveBy: 'bob',
    }),
  );

  const guestMove = {
    ...hostMove,
    revision: 2,
    turnUid: 'alice',
    lastMoveBy: 'bob',
    lastTo: 1,
    updatedAt: 3,
    state: {
      ...hostMove.state,
      board: [1, 2, ...Array(22).fill(0)],
      turn: 'light',
      darkToPlace: 8,
    },
  };
  await assertSucceeds(
    bobDatabase.ref('sparkRooms/zyxwvutsrqponmlkjihg').set(guestMove),
  );
});

test('a participant can resign once, which blocks further moves and completes the room', async () => {
  const roomRef = aliceDatabase.ref('sparkRooms/resignroom1234567890');
  await assertSucceeds(roomRef.set(privateRoom()));
  await assertSucceeds(
    bobDatabase.ref('sparkRooms/resignroom1234567890').set(
      privateRoom('active', 'bob'),
    ),
  );
  await assertSucceeds(
    bobDatabase.ref('sparkRooms/resignroom1234567890/resignedBy').set('bob'),
  );

  const attemptedMove = privateRoom('active', 'bob');
  attemptedMove.revision = 1;
  attemptedMove.turnUid = 'bob';
  attemptedMove.lastMoveBy = 'alice';
  attemptedMove.lastTo = 0;
  attemptedMove.updatedAt = testRoomTimestamp + 1;
  attemptedMove.state = {
    ...emptyState('nine'),
    board: [1, ...Array(23).fill(0)],
    turn: 'dark',
    lightToPlace: 8,
  };
  await assertFails(roomRef.set(attemptedMove));
  await assertSucceeds(
    bobDatabase.ref('sparkRooms/resignroom1234567890/status').set('completed'),
  );

  const completed = await assertSucceeds(roomRef.once('value'));
  assert.equal(completed.val().status, 'completed');
  assert.equal(completed.val().resignedBy, 'bob');
});

test('clients cannot impersonate the host or introduce malformed board data', async () => {
  const roomRef = aliceDatabase.ref('sparkRooms/malformedboard123456');
  await assertFails(
    bobDatabase.ref('sparkRooms/malformedboard123456').set(privateRoom()),
  );
  await assertSucceeds(roomRef.set(privateRoom()));
  await assertFails(roomRef.child('hostUid').set('bob'));
  await assertFails(
    roomRef.set({
      ...privateRoom(),
      state: { ...emptyState('nine'), board: [0, 0, 0] },
    }),
  );
});
