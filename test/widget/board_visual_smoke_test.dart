import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/app/app_theme.dart';
import 'package:nine_tas/core/game/game_catalog.dart';
import 'package:nine_tas/core/game/game_models.dart';
import 'package:nine_tas/core/settings/app_settings_models.dart';
import 'package:nine_tas/features/gameplay/presentation/widgets/morris_board.dart';

void main() {
  testWidgets('every board material and piece treatment paints safely', (
    tester,
  ) async {
    final board = List<PlayerSide?>.generate(
      GameCatalog.nine.board.pointCount,
      (index) => switch (index) {
        0 || 7 || 15 => PlayerSide.light,
        2 || 9 || 16 => PlayerSide.dark,
        _ => null,
      },
      growable: false,
    );

    for (final surface in BoardSurface.values) {
      for (final pieces in PieceTheme.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode:
                surface == BoardSurface.darkStone
                    ? ThemeMode.dark
                    : ThemeMode.light,
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 320,
                  height: 320,
                  child: MorrisBoard(
                    definition: GameCatalog.nine,
                    board: board,
                    onPointTap: (_) {},
                    interactive: false,
                    showHints: false,
                    surface: surface,
                    viewStyle: BoardViewStyle.realistic,
                    pieceTheme: pieces,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(MorrisBoard), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });
}
