import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nine_tas/app/app_services.dart';
import 'package:nine_tas/app/app_services_scope.dart';
import 'package:nine_tas/app/app_settings_controller.dart';
import 'package:nine_tas/app/app_theme.dart';
import 'package:nine_tas/core/feedback/app_feedback_service.dart';
import 'package:nine_tas/core/game/game_catalog.dart';
import 'package:nine_tas/core/game/game_definition.dart';
import 'package:nine_tas/core/game/game_models.dart';
import 'package:nine_tas/core/match/match_models.dart';
import 'package:nine_tas/core/online/online_match_gateway.dart';
import 'package:nine_tas/core/settings/app_settings_models.dart';
import 'package:nine_tas/core/settings/app_settings_repository.dart';
import 'package:nine_tas/core/storage/match_session_repository.dart';
import 'package:nine_tas/features/gameplay/presentation/game_screen.dart';
import 'package:nine_tas/features/gameplay/presentation/widgets/match_player_bar.dart';
import 'package:nine_tas/features/gameplay/presentation/widgets/morris_board.dart';
import 'package:nine_tas/features/home/presentation/home_screen.dart';
import 'package:nine_tas/features/social/data/in_memory_friends_repository.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('captures the Turkish home store screenshot', (tester) async {
    _setStoreScreenshotViewport(tester);
    await tester.pumpWidget(_storeHost(child: const HomeScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('3 Taş'), findsOneWidget);
    expect(find.text('9 Taş'), findsOneWidget);
    expect(find.text('12 Taş'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final homeGolden = File('assets/store_listing/screenshot_home_tr.png');
    if (homeGolden.existsSync() || autoUpdateGoldenFiles) {
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../assets/store_listing/screenshot_home_tr.png'),
      );
    }
  });

  for (final gameId in MorrisGameId.values) {
    testWidgets('captures the ${gameId.name} in-game store screenshot', (
      tester,
    ) async {
      _setStoreScreenshotViewport(tester);
      final repository = _StoreMatchRepository(_storeSession(gameId));
      await tester.pumpWidget(
        _storeHost(
          child: GameScreen(
            config: MatchConfig(
              sessionId: 'store-${gameId.name}',
              gameId: gameId,
              mode: MatchMode.localTwoPlayer,
            ),
          ),
          matches: repository,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(GameScreen), findsOneWidget);
      expect(find.byType(Scrollable), findsNothing);
      expect(find.byType(MatchPlayerBar), findsNWidgets(2));
      for (final element in find.byType(MatchPlayerBar).evaluate()) {
        expect((element.renderObject as RenderBox).size.height, 58);
      }
      final boardSize = tester.getSize(find.byType(MorrisBoard));
      expect(boardSize.width, greaterThan(280));
      expect(boardSize.width, boardSize.height);
      expect(tester.takeException(), isNull);
      final gameGolden = File(
        'assets/store_listing/screenshot_game_${gameId.name}_tr.png',
      );
      if (gameGolden.existsSync() || autoUpdateGoldenFiles) {
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            '../assets/store_listing/screenshot_game_${gameId.name}_tr.png',
          ),
        );
      }
      await tester.pump(const Duration(seconds: 13));
    });
  }
}

void _setStoreScreenshotViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 1920);
  tester.view.devicePixelRatio = 2.75;
  tester.view.platformDispatcher.localeTestValue = const Locale('tr');
}

Widget _storeHost({required Widget child, MatchSessionRepository? matches}) {
  final settings = AppSettingsController(
    _StoreSettingsRepository(),
    initialState: const AppSettingsState(reduceMotion: true),
  );
  final services = AppServices(
    settings: settings,
    matchSessions: matches ?? _StoreMatchRepository(),
    feedback: _StoreFeedback(),
    social: InMemoryFriendsRepository(),
    online: const DisabledOnlineMatchGateway(),
  );
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: const Locale('tr'),
    theme: AppTheme.light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: AppServicesScope(services: services, child: child),
  );
}

MatchSession _storeSession(MorrisGameId gameId) {
  final definition = GameCatalog.byId(gameId);
  final board = List<PlayerSide?>.filled(definition.board.pointCount, null);
  final positions = switch (gameId) {
    MorrisGameId.three => <(int, PlayerSide)>[
      (0, PlayerSide.light),
      (2, PlayerSide.dark),
      (4, PlayerSide.light),
      (3, PlayerSide.dark),
      (8, PlayerSide.light),
      (6, PlayerSide.dark),
    ],
    MorrisGameId.nine || MorrisGameId.twelve => <(int, PlayerSide)>[
      (0, PlayerSide.light),
      (2, PlayerSide.dark),
      (4, PlayerSide.light),
      (9, PlayerSide.dark),
      (21, PlayerSide.light),
      (14, PlayerSide.dark),
      (6, PlayerSide.light),
      (5, PlayerSide.dark),
    ],
  };
  for (final (point, side) in positions) {
    board[point] = side;
  }
  final placedPerSide = positions.length ~/ 2;
  final remaining = definition.piecesPerPlayer - placedPerSide;
  return MatchSession(
    config: MatchConfig(
      sessionId: 'store-${gameId.name}',
      gameId: gameId,
      mode: MatchMode.localTwoPlayer,
    ),
    state: MorrisGameState(
      board: board,
      turn: PlayerSide.light,
      lightToPlace: remaining,
      darkToPlace: remaining,
    ),
    status: MatchSessionStatus.active,
    updatedAt: DateTime.utc(2026, 9, 28),
    moveCount: positions.length,
  );
}

class _StoreSettingsRepository implements AppSettingsRepository {
  @override
  Future<AppSettingsState> load() async => const AppSettingsState(
    reduceMotion: true,
  );

  @override
  Future<void> save(AppSettingsState state) async {}
}

class _StoreMatchRepository implements MatchSessionRepository {
  _StoreMatchRepository([MatchSession? session]) : _session = session;

  final MatchSession? _session;

  @override
  Future<void> delete(String sessionId) async {}
  @override
  Future<void> deleteAll() async {}

  @override
  Future<MatchSession?> getById(String sessionId) async => _session;

  @override
  Future<MatchSession?> getMostRecentActive() async => null;

  @override
  Future<MatchSession?> getMostRecentActiveForGame(MorrisGameId gameId) async =>
      null;

  @override
  Future<void> save(MatchSession session) async {}
}

class _StoreFeedback implements GameFeedback {
  @override
  Future<void> buttonPressed() async {}

  @override
  Future<void> pieceSelected() async {}

  @override
  Future<void> piecePlaced() async {}

  @override
  Future<void> pieceMoved() async {}

  @override
  Future<void> millFormed() async {}

  @override
  Future<void> pieceCaptured() async {}

  @override
  Future<void> success() async {}
}
