import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../core/diagnostics/runtime_trace.dart';
import '../core/feedback/motion_tokens.dart';
import '../core/game/game_definition.dart';
import '../core/match/match_models.dart';
import '../features/gameplay/presentation/game_screen.dart';
import '../features/home/presentation/game_mode_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/online/presentation/online_lobby_screen.dart';
import '../features/online/presentation/online_room_screen.dart';
import '../features/puzzles/presentation/puzzle_list_screen.dart';
import '../features/puzzles/presentation/puzzle_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/social/presentation/friends_screen.dart';
import '../features/social/presentation/profile_screen.dart';
import '../features/social/presentation/rankings_screen.dart';
import '../features/tutorial/presentation/tutorial_screen.dart';
import '../shared/ui/app_screen_shell.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static GoRouter create() => GoRouter(
    initialLocation: AppRoutes.home,
    errorPageBuilder:
        (context, state) => _page(
          state,
          _RouteErrorScreen(
            message: kDebugMode ? state.error?.toString() : null,
          ),
        ),
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => _page(state, const HomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.friends,
        pageBuilder: (context, state) {
          final game = _tryEnumByName(
            MorrisGameId.values,
            state.uri.queryParameters['game'],
          );
          return _page(state, FriendsScreen(initialGameId: game));
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) => _page(state, const SettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.rankings,
        pageBuilder: (context, state) => _page(state, const RankingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) => _page(state, const ProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.puzzles,
        pageBuilder: (context, state) => _page(state, const PuzzleListScreen()),
      ),
      GoRoute(
        path: '/puzzles/:puzzleId',
        pageBuilder: (context, state) {
          final id = state.pathParameters['puzzleId'] ?? 'p_01';
          return _page(state, PuzzleScreen(puzzleId: id));
        },
      ),
      GoRoute(
        path: '/game/:gameId',
        pageBuilder: (context, state) {
          final game = _tryEnumByName(
            MorrisGameId.values,
            state.pathParameters['gameId'],
          );
          return _page(
            state,
            game == null
                ? const _RouteErrorScreen()
                : GameModeScreen(gameId: game),
          );
        },
      ),
      GoRoute(
        path: '/learn/:gameId',
        pageBuilder: (context, state) {
          final game = _tryEnumByName(
            MorrisGameId.values,
            state.pathParameters['gameId'],
          );
          return _page(
            state,
            game == null
                ? const _RouteErrorScreen()
                : TutorialScreen(gameId: game),
          );
        },
      ),
      GoRoute(
        path: '/online/:gameId',
        pageBuilder: (context, state) {
          final game = _tryEnumByName(
            MorrisGameId.values,
            state.pathParameters['gameId'],
          );
          return _page(
            state,
            game == null
                ? const _RouteErrorScreen()
                : OnlineLobbyScreen(gameId: game),
          );
        },
      ),
      GoRoute(
        path: '/online-room/:roomCode',
        pageBuilder: (context, state) {
          final roomCode = state.pathParameters['roomCode'];
          return _page(
            state,
            roomCode == null || roomCode.isEmpty
                ? const _RouteErrorScreen()
                : OnlineRoomScreen(roomCode: roomCode),
          );
        },
      ),
      GoRoute(
        path: '/play/:gameId/:mode',
        pageBuilder: (context, state) {
          RuntimeTrace.setPhase('router.play.page_builder');
          RuntimeTrace.mark(
            'router.play.enter',
            data: <String, Object?>{'uri': state.uri.toString()},
          );
          final sessionId = state.uri.queryParameters['session'];
          final game = _tryEnumByName(
            MorrisGameId.values,
            state.pathParameters['gameId'],
          );
          final mode = _tryEnumByName(
            MatchMode.values,
            state.pathParameters['mode'],
          );
          final difficultyName = state.uri.queryParameters['difficulty'];
          final difficulty =
              difficultyName == null
                  ? null
                  : _tryEnumByName(AiDifficulty.values, difficultyName);
          if (sessionId == null ||
              sessionId.isEmpty ||
              game == null ||
              mode == null ||
              (difficultyName != null && difficulty == null)) {
            return _page(state, const _RouteErrorScreen());
          }
          // A URL is not proof that a caller owns an online match. Until a
          // dedicated, Firebase-backed match screen validates a server-issued
          // match id and participant identity, never let deep links turn the
          // local two-player controller into a counterfeit online session.
          if (mode == MatchMode.onlineRanked || mode == MatchMode.challenge) {
            return _page(state, const _RouteErrorScreen());
          }
          final config = MatchConfig(
            sessionId: sessionId,
            gameId: game,
            mode: mode,
            difficulty: difficulty,
          );
          final createNew = state.uri.queryParameters['fresh'] == '1';
          RuntimeTrace.mark(
            'router.play.config_ready',
            data: <String, Object?>{
              'game': game.name,
              'mode': mode.name,
              'difficulty': difficulty?.name,
              'fresh': createNew,
            },
          );
          return _page(state, GameScreen(config: config, createNew: createNew));
        },
      ),
    ],
  );

  static CustomTransitionPage<void> _page(GoRouterState state, Widget child) {
    final isGameplayRoute = state.uri.path.startsWith('/play/');
    return CustomTransitionPage<void>(
      key: state.pageKey,
      restorationId: state.pageKey.value,
      // Gameplay opens without a dual-screen transition. This guarantees the
      // first Android frame can be presented immediately on slower devices.
      transitionDuration: isGameplayRoute ? Duration.zero : MotionTokens.normal,
      reverseTransitionDuration:
          isGameplayRoute ? Duration.zero : MotionTokens.normal,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (isGameplayRoute) return child;
        final curved = CurvedAnimation(
          parent: animation,
          curve: MotionTokens.curve,
        );
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(isRtl ? -0.025 : 0.025, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  static T? _tryEnumByName<T extends Enum>(List<T> values, String? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScreenShell(
      title: l10n.errorTitle,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 52),
            const SizedBox(height: 14),
            Text(l10n.routeError, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message!, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => context.go(AppRoutes.home),
              child: Text(l10n.backHome),
            ),
          ],
        ),
      ),
    );
  }
}
