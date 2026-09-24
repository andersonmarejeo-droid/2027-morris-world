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
