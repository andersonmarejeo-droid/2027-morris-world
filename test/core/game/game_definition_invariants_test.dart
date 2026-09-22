import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/game/game_catalog.dart';
import 'package:nine_tas/core/game/game_definition.dart';

void main() {
  for (final definition in GameCatalog.all) {
    group('${definition.id.name} definition invariants', () {
      test('adjacency stays in range and is symmetric', () {
        for (var point = 0; point < definition.board.pointCount; point++) {
          final neighbours = definition.board.adjacency[point] ?? const <int>[];
          expect(neighbours.toSet().length, neighbours.length);
          for (final neighbour in neighbours) {
            expect(neighbour, inInclusiveRange(0, definition.board.pointCount - 1));
            expect(
              definition.board.adjacency[neighbour] ?? const <int>[],
              contains(point),
              reason: '$point -> $neighbour must also contain $neighbour -> $point',
            );
          }
        }
      });

      test('every mill contains three unique valid points', () {
        for (final mill in definition.board.mills) {
          expect(mill.length, 3);
          expect(mill.toSet().length, 3);
          for (final point in mill) {
            expect(point, inInclusiveRange(0, definition.board.pointCount - 1));
          }
        }
      });

      test('board geometry and rule identity are stable', () {
        expect(definition.board.normalizedPoints.length, definition.board.pointCount);
        expect(definition.piecesPerPlayer, greaterThanOrEqualTo(3));
      });
    });
  }

  test('catalog identities remain stable for persistence and deep links', () {
    expect(MorrisGameId.values.map((id) => id.name).toList(), ['three', 'nine', 'twelve']);
  });
}
