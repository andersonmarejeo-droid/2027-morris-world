const assert = require('node:assert/strict');
const test = require('node:test');

const {
  MorrisValidationError,
  applyMorrisCommand,
  initialMorrisState,
} = require('../../lib/morris.js');

test('three-stone match ends when a player forms a mill', () => {
  let state = initialMorrisState('three');
  state = applyMorrisCommand('three', state, { kind: 'place', to: 0 });
  state = applyMorrisCommand('three', state, { kind: 'place', to: 3 });
  state = applyMorrisCommand('three', state, { kind: 'place', to: 1 });
  state = applyMorrisCommand('three', state, { kind: 'place', to: 4 });
  state = applyMorrisCommand('three', state, { kind: 'place', to: 2 });

  assert.equal(state.winner, 'light');
  assert.equal(state.turn, 'light');
});

test('a move cannot be submitted after a finished match', () => {
  const finished = {
    ...initialMorrisState('three'),
    winner: 'light',
  };

  assert.throws(
    () => applyMorrisCommand('three', finished, { kind: 'place', to: 0 }),
    (error) => error instanceof MorrisValidationError && error.code === 'match-finished',
  );
});

test('100 movement moves without a capture end the match in a draw', () => {
  const state = {
    ...initialMorrisState('nine'),
    board: Array(24).fill(null),
    turn: 'light',
    lightToPlace: 0,
    darkToPlace: 0,
    movesWithoutCapture: 99,
  };
  state.board[0] = 'light';
  state.board[4] = 'light';
  state.board[21] = 'light';
  state.board[2] = 'dark';
  state.board[9] = 'dark';
  state.board[14] = 'dark';

  const next = applyMorrisCommand('nine', state, {
    kind: 'move',
    from: 0,
    to: 1,
  });

  assert.equal(next.isDraw, true);
  assert.equal(next.movesWithoutCapture, 100);
});

test('capturing a stone resets the no-capture move counter', () => {
  const state = {
    ...initialMorrisState('nine'),
    board: Array(24).fill(null),
    turn: 'light',
    lightToPlace: 0,
    darkToPlace: 0,
    pendingCaptureBy: 'light',
    movesWithoutCapture: 99,
  };
  state.board[0] = 'light';
  state.board[1] = 'light';
  state.board[4] = 'light';
  state.board[3] = 'dark';
  state.board[9] = 'dark';
  state.board[14] = 'dark';

  const next = applyMorrisCommand('nine', state, { kind: 'capture', to: 3 });

  assert.equal(next.movesWithoutCapture, 0);
});
