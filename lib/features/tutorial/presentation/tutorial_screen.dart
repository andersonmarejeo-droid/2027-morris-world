import 'package:flutter/material.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_tokens.dart';
import '../../../core/game/game_catalog.dart';
import '../../../core/game/game_definition.dart';
import '../../../core/game/game_models.dart';
import '../../../core/settings/app_settings_models.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/game_ui_labels.dart';
import '../../gameplay/presentation/widgets/morris_board.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key, required this.gameId});
  final MorrisGameId gameId;

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  var step = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final definition = GameCatalog.byId(widget.gameId);
    final steps = _steps(l10n);
    final current = steps[step];
    final board = _sampleBoard(definition, step);

    return AppScreenShell(
      title: l10n.howToPlay,
      scrollable: true,
      maxWidth: AppConstraints.compactMaxWidth,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            gameName(l10n, widget.gameId),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.tutorialProgress(step + 1, steps.length),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          MorrisBoard(
            definition: definition,
            board: board,
            onPointTap: (_) {},
            interactive: false,
            selectedPoint: current.selected,
            legalTargets: current.targets,
            capturablePoints: current.captures,
            activeMillPoints: current.mills,
            surface: current.surface,
            showHints: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.brandSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (step + 1).toString(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.brandDeep,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(current.title, style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(current.body),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: step == 0 ? null : () => setState(() => step--),
                  child: Text(l10n.previous),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton(
                  onPressed: step == steps.length - 1
                      ? () => context.pop()
                      : () => setState(() => step++),
                  child: Text(step == steps.length - 1 ? l10n.finish : l10n.next),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<_TutorialStep> _steps(AppLocalizations l10n) => [
        _TutorialStep(
          title: l10n.tutorialPlaceTitle,
          body: l10n.tutorialPlaceBody,
          targets: const {0, 1, 2},
        ),
        _TutorialStep(
          title: l10n.tutorialMillTitle,
          body: l10n.tutorialMillBody,
          selected: 1,
          targets: const {2},
          mills: const {0, 1, 2},
        ),
        _TutorialStep(
          title: l10n.tutorialCaptureTitle,
          body: l10n.tutorialCaptureBody,
          captures: const {3},
        ),
        _TutorialStep(
          title: l10n.tutorialMoveTitle,
          body: l10n.tutorialMoveBody,
          selected: 0,
          targets: const {9},
        ),
        _TutorialStep(
          title: l10n.tutorialBlockTitle,
          body: l10n.tutorialBlockBody,
          selected: 9,
          targets: const {10},
        ),
        _TutorialStep(
          title: l10n.tutorialFlyTitle,
          body: l10n.tutorialFlyBody,
          selected: 0,
          targets: const {14, 23},
        ),
        _TutorialStep(
          title: l10n.tutorialDoubleMillTitle,
          body: l10n.tutorialDoubleMillBody,
          selected: 4,
          targets: const {1, 7},
          mills: const {1, 4, 7},
          surface: BoardSurface.marble,
        ),
      ];

  List<PlayerSide?> _sampleBoard(MorrisGameDefinition definition, int step) {
    final board = List<PlayerSide?>.filled(definition.board.pointCount, null);
    if (definition.board.pointCount < 9) return board;
    void set(int index, PlayerSide side) {
      if (index < board.length) board[index] = side;
    }
    switch (step) {
      case 1:
        set(0, PlayerSide.light);
        set(1, PlayerSide.light);
        break;
      case 2:
        set(0, PlayerSide.light);
        set(1, PlayerSide.light);
        set(2, PlayerSide.light);
        set(3, PlayerSide.dark);
        break;
      case 3:
        set(0, PlayerSide.light);
        set(3, PlayerSide.light);
        set(4, PlayerSide.dark);
        break;
      case 4:
        set(9, PlayerSide.light);
        set(10, PlayerSide.dark);
        set(11, PlayerSide.dark);
        break;
      case 5:
        set(0, PlayerSide.light);
        set(4, PlayerSide.light);
        set(20, PlayerSide.light);
        set(13, PlayerSide.dark);
        break;
      case 6:
        set(1, PlayerSide.light);
        set(4, PlayerSide.light);
        set(9, PlayerSide.light);
        set(7, PlayerSide.light);
        set(10, PlayerSide.dark);
        break;
      default:
        break;
    }
    return board;
  }
}

class _TutorialStep {
  const _TutorialStep({
    required this.title,
    required this.body,
    this.selected,
    this.targets = const <int>{},
    this.captures = const <int>{},
    this.mills = const <int>{},
    this.surface = BoardSurface.wood,
  });

  final String title;
  final String body;
  final int? selected;
  final Set<int> targets;
  final Set<int> captures;
  final Set<int> mills;
  final BoardSurface surface;
}
