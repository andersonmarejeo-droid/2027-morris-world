export type GameId = 'three' | 'nine' | 'twelve';
export type Side = 'light' | 'dark';
export type Cell = Side | null;

export interface MorrisState {
  board: Cell[];
  turn: Side;
  lightToPlace: number;
  darkToPlace: number;
  pendingCaptureBy?: Side | null;
  winner?: Side | null;
  isDraw?: boolean;
  movesWithoutCapture?: number;
}

export const DRAW_AFTER_MOVES_WITHOUT_CAPTURE = 100;

export type MoveCommand =
  | { kind: 'place'; to: number }
  | { kind: 'move'; from: number; to: number }
  | { kind: 'capture'; to: number };

interface Definition {
  pointCount: number;
  piecesPerPlayer: number;
  adjacency: Record<number, readonly number[]>;
  mills: readonly (readonly [number, number, number])[];
  captureOnMill: boolean;
  winOnMill: boolean;
  allowFlying: boolean;
  flyingThreshold: number;
  minimumPiecesToContinue: number;
  fullBoardAfterPlacementIsDraw: boolean;
}

export class MorrisValidationError extends Error {
  constructor(public readonly code: string) {
    super(code);
    this.name = 'MorrisValidationError';
  }
}

const nineAdjacency: Record<number, readonly number[]> = {
  0: [1, 9], 1: [0, 2, 4], 2: [1, 14], 3: [4, 10],
  4: [1, 3, 5, 7], 5: [4, 13], 6: [7, 11], 7: [4, 6, 8],
  8: [7, 12], 9: [0, 10, 21], 10: [3, 9, 11, 18], 11: [6, 10, 15],
  12: [8, 13, 17], 13: [5, 12, 14, 20], 14: [2, 13, 23], 15: [11, 16],
  16: [15, 17, 19], 17: [12, 16], 18: [10, 19], 19: [16, 18, 20, 22],
  20: [13, 19], 21: [9, 22], 22: [19, 21, 23], 23: [14, 22],
};

const twelveAdjacency: Record<number, readonly number[]> = {
  0: [1, 9, 3], 1: [0, 2, 4], 2: [1, 14, 5], 3: [4, 10, 0, 6],
  4: [1, 3, 5, 7], 5: [4, 13, 2, 8], 6: [7, 11, 3], 7: [4, 6, 8],
  8: [7, 12, 5], 9: [0, 10, 21], 10: [3, 9, 11, 18], 11: [6, 10, 15],
  12: [8, 13, 17], 13: [5, 12, 14, 20], 14: [2, 13, 23], 15: [11, 16, 18],
  16: [15, 17, 19], 17: [12, 16, 20], 18: [10, 19, 21, 15], 19: [16, 18, 20, 22],
  20: [13, 19, 23, 17], 21: [9, 22, 18], 22: [19, 21, 23], 23: [14, 22, 20],
};

const threeAdjacency: Record<number, readonly number[]> = {
  0: [1, 3], 1: [0, 2, 4], 2: [1, 5],
  3: [0, 4, 6], 4: [1, 3, 5, 7], 5: [2, 4, 8],
  6: [3, 7], 7: [4, 6, 8], 8: [5, 7],
};

const nineMills = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8],
  [9, 10, 11], [12, 13, 14], [15, 16, 17], [18, 19, 20], [21, 22, 23],
  [0, 9, 21], [3, 10, 18], [6, 11, 15], [1, 4, 7],
  [16, 19, 22], [8, 12, 17], [5, 13, 20], [2, 14, 23],
] as const;

const definitions: Record<GameId, Definition> = {
  three: {
    pointCount: 9,
    piecesPerPlayer: 3,
    adjacency: threeAdjacency,
    mills: [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
    ],
    captureOnMill: false,
    winOnMill: true,
    allowFlying: false,
    flyingThreshold: 3,
    minimumPiecesToContinue: 3,
    fullBoardAfterPlacementIsDraw: false,
  },
  nine: {
    pointCount: 24,
    piecesPerPlayer: 9,
    adjacency: nineAdjacency,
    mills: nineMills,
    captureOnMill: true,
    winOnMill: false,
    allowFlying: true,
    flyingThreshold: 3,
    minimumPiecesToContinue: 3,
    fullBoardAfterPlacementIsDraw: false,
  },
  twelve: {
    pointCount: 24,
    piecesPerPlayer: 12,
    adjacency: twelveAdjacency,
    mills: [
      ...nineMills,
      [0, 3, 6], [2, 5, 8], [21, 18, 15], [23, 20, 17],
    ],
    captureOnMill: true,
    winOnMill: false,
    allowFlying: true,
    flyingThreshold: 3,
    minimumPiecesToContinue: 3,
    fullBoardAfterPlacementIsDraw: true,
  },
};

export function initialMorrisState(gameId: GameId): MorrisState {
  const def = definitions[gameId];
  return {
    board: Array<Cell>(def.pointCount).fill(null),
    turn: 'light',
    lightToPlace: def.piecesPerPlayer,
    darkToPlace: def.piecesPerPlayer,
    pendingCaptureBy: null,
    winner: null,
    isDraw: false,
    movesWithoutCapture: 0,
  };
}

export function applyMorrisCommand(
  gameId: GameId,
  input: MorrisState,
  command: MoveCommand,
): MorrisState {
  const def = definitions[gameId];
  const state = normalizeAndValidateState(def, input);
  ensureActive(state);

  if (state.pendingCaptureBy != null) {
    if (command.kind !== 'capture') fail('capture-required');
    return capture(def, state, command.to);
  }

  if (command.kind === 'capture') fail('no-capture-right');
  if (toPlace(state, state.turn) > 0) {
    if (command.kind !== 'place') fail('placement-required');
    return place(def, state, command.to);
  }
  if (command.kind !== 'move') fail('movement-required');
  return move(def, state, command.from, command.to);
}

export function commandFromUnknown(value: unknown): MoveCommand {
  if (typeof value !== 'object' || value === null) fail('invalid-command');
  const raw = value as Record<string, unknown>;
  const kind = raw.kind;
  if (kind === 'place' || kind === 'capture') {
    return { kind, to: integer(raw.to, 'invalid-target') };
  }
  if (kind === 'move') {
    return {
      kind,
      from: integer(raw.from, 'invalid-source'),
      to: integer(raw.to, 'invalid-target'),
    };
  }
  fail('invalid-command');
}

function place(def: Definition, state: MorrisState, to: number): MorrisState {
  ensureIndex(def, to);
  if (state.board[to] !== null) fail('point-occupied');
  const board = [...state.board];
  board[to] = state.turn;
  let next: MorrisState = {
    ...state,
    board,
    movesWithoutCapture: 0,
    lightToPlace: state.turn === 'light' ? state.lightToPlace - 1 : state.lightToPlace,
    darkToPlace: state.turn === 'dark' ? state.darkToPlace - 1 : state.darkToPlace,
  };
  if (formsMill(def, board, to, state.turn)) {
    if (def.winOnMill) return { ...next, winner: state.turn };
    if (def.captureOnMill) return { ...next, pendingCaptureBy: state.turn };
  }
  next = { ...next, turn: opponent(state.turn) };
  return resolveTerminal(def, next);
}

function move(def: Definition, state: MorrisState, from: number, to: number): MorrisState {
  ensureIndex(def, from);
  ensureIndex(def, to);
  if (state.board[from] !== state.turn) fail('not-your-piece');
  if (state.board[to] !== null) fail('target-occupied');
  const canFly = def.allowFlying && stonesOnBoard(state, state.turn) === def.flyingThreshold;
  if (!canFly && !(def.adjacency[from] ?? []).includes(to)) fail('not-adjacent');

  const board = [...state.board];
  board[from] = null;
  board[to] = state.turn;
  let next: MorrisState = {
    ...state,
    board,
    movesWithoutCapture: (state.movesWithoutCapture ?? 0) + 1,
  };
  if (formsMill(def, board, to, state.turn)) {
    if (def.winOnMill) return { ...next, winner: state.turn };
    if (def.captureOnMill) return { ...next, pendingCaptureBy: state.turn };
  }
  next = { ...next, turn: opponent(state.turn) };
  return resolveTerminal(def, next);
}

function capture(def: Definition, state: MorrisState, to: number): MorrisState {
  ensureIndex(def, to);
  const capturer = state.pendingCaptureBy;
  if (!def.captureOnMill || capturer == null || capturer !== state.turn) {
    fail('no-capture-right');
  }
  const targetSide = opponent(capturer);
  if (state.board[to] !== targetSide) fail('opponent-piece-required');

  const outsideMills: number[] = [];
  for (let i = 0; i < state.board.length; i++) {
    if (state.board[i] === targetSide && !formsMill(def, state.board, i, targetSide)) {
      outsideMills.push(i);
    }
  }
  if (outsideMills.length > 0 && formsMill(def, state.board, to, targetSide)) {
    fail('protected-mill-piece');
  }

  const board = [...state.board];
  board[to] = null;
  return resolveTerminal(def, {
    ...state,
    board,
    pendingCaptureBy: null,
    turn: targetSide,
    movesWithoutCapture: 0,
  });
}

function resolveTerminal(def: Definition, state: MorrisState): MorrisState {
  if (state.lightToPlace > 0 || state.darkToPlace > 0) return state;
  if (def.fullBoardAfterPlacementIsDraw && state.board.every((cell) => cell !== null)) {
    return { ...state, isDraw: true };
  }
  if (def.winOnMill) {
    if (!hasLegalMove(def, state, state.turn)) {
      return { ...state, winner: opponent(state.turn) };
    }
  } else {
    const active = state.turn;
    if (stonesOnBoard(state, active) < def.minimumPiecesToContinue || !hasLegalMove(def, state, active)) {
      return { ...state, winner: opponent(active) };
    }
  }
  if ((state.movesWithoutCapture ?? 0) >= DRAW_AFTER_MOVES_WITHOUT_CAPTURE) {
    return { ...state, isDraw: true };
  }
  return state;
}

function hasLegalMove(def: Definition, state: MorrisState, side: Side): boolean {
  if (toPlace(state, side) > 0) return state.board.some((cell) => cell === null);
  const stones = stonesOnBoard(state, side);
  if (stones < def.minimumPiecesToContinue) return false;
  if (def.allowFlying && stones === def.flyingThreshold) {
    return state.board.some((cell) => cell === null);
  }
  for (let from = 0; from < state.board.length; from++) {
    if (state.board[from] !== side) continue;
    if ((def.adjacency[from] ?? []).some((to) => state.board[to] === null)) return true;
  }
  return false;
}

function formsMill(def: Definition, board: readonly Cell[], point: number, side: Side): boolean {
  return def.mills.some((mill) => mill.includes(point) && mill.every((p) => board[p] === side));
}

function normalizeAndValidateState(def: Definition, input: MorrisState): MorrisState {
  if (!Array.isArray(input.board) || input.board.length !== def.pointCount) fail('board-mismatch');
  const board = input.board.map((cell) => {
    if (cell === null || cell === 'light' || cell === 'dark') return cell;
    fail('invalid-board-cell');
  });
  if (input.turn !== 'light' && input.turn !== 'dark') fail('invalid-turn');
  if (!Number.isInteger(input.lightToPlace) || !Number.isInteger(input.darkToPlace)) fail('invalid-reserve');
  if (input.lightToPlace < 0 || input.darkToPlace < 0) fail('invalid-reserve');
  if (input.pendingCaptureBy != null && input.pendingCaptureBy !== 'light' && input.pendingCaptureBy !== 'dark') {
    fail('invalid-capture-side');
  }
  if (input.winner != null && input.winner !== 'light' && input.winner !== 'dark') fail('invalid-winner');
  const movesWithoutCapture = input.movesWithoutCapture ?? 0;
  if (!Number.isInteger(movesWithoutCapture) || movesWithoutCapture < 0 || movesWithoutCapture > DRAW_AFTER_MOVES_WITHOUT_CAPTURE) {
    fail('invalid-quiet-move-count');
  }
  return {
    board,
    turn: input.turn,
    lightToPlace: input.lightToPlace,
    darkToPlace: input.darkToPlace,
    pendingCaptureBy: input.pendingCaptureBy ?? null,
    winner: input.winner ?? null,
    isDraw: input.isDraw === true,
    movesWithoutCapture,
  };
}

function ensureActive(state: MorrisState): void {
  if (state.winner != null || state.isDraw === true) fail('match-finished');
}

function ensureIndex(def: Definition, point: number): void {
  if (!Number.isInteger(point) || point < 0 || point >= def.pointCount) fail('invalid-point');
}

function stonesOnBoard(state: MorrisState, side: Side): number {
  return state.board.filter((cell) => cell === side).length;
}

function toPlace(state: MorrisState, side: Side): number {
  return side === 'light' ? state.lightToPlace : state.darkToPlace;
}

function opponent(side: Side): Side {
  return side === 'light' ? 'dark' : 'light';
}

function integer(value: unknown, code: string): number {
  if (!Number.isInteger(value)) fail(code);
  return value as number;
}

function fail(code: string): never {
  throw new MorrisValidationError(code);
}
