import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_routes.dart';
import '../../../app/app_tokens.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../data/puzzle_catalog.dart';
import '../data/puzzle_repository.dart';

class PuzzleListScreen extends StatefulWidget {
  const PuzzleListScreen({super.key});

  @override
  State<PuzzleListScreen> createState() => _PuzzleListScreenState();
}

class _PuzzleListScreenState extends State<PuzzleListScreen> {
  final PuzzleRepository _repo = PuzzleRepository();
  Set<String> _solvedIds = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final solved = await _repo.getSolvedPuzzleIds();
    if (!mounted) return;
    setState(() {
      _solvedIds = solved;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = l10n.localeName.toLowerCase();
    final puzzles = MorrisPuzzleCatalog.puzzles;
    final solvedCount = puzzles.where((p) => _solvedIds.contains(p.id)).length;
    final screenTitle = lang.startsWith('tr')
        ? 'Taktik Arenası'
        : lang.startsWith('de')
        ? 'Taktik-Arena'
        : lang.startsWith('es')
        ? 'Arena Táctica'
        : lang.startsWith('fr')
        ? 'Arène Tactique'
        : lang.startsWith('pt')
        ? 'Arena Tática'
        : lang.startsWith('ar')
        ? 'ساحة التكتيك'
        : lang.startsWith('hi')
        ? 'रणनीति क्षेत्र'
        : 'Tactics Arena';
    final subTitle = lang.startsWith('tr')
        ? 'Ustalık adımları: $solvedCount / ${puzzles.length} tamamlandı'
        : lang.startsWith('de')
        ? 'Meisterschritte: $solvedCount / ${puzzles.length} abgeschlossen'
        : lang.startsWith('es')
        ? 'Pasos de maestría: $solvedCount / ${puzzles.length} completados'
        : lang.startsWith('fr')
        ? 'Étapes de maîtrise : $solvedCount / ${puzzles.length} terminées'
        : lang.startsWith('pt')
        ? 'Passos de maestria: $solvedCount / ${puzzles.length} concluídos'
        : lang.startsWith('ar')
        ? 'خطوات الإتقان: $solvedCount / ${puzzles.length} مكتملة'
        : lang.startsWith('hi')
        ? 'महारत के कदम: $solvedCount / ${puzzles.length} पूरे हुए'
        : 'Mastery steps: $solvedCount / ${puzzles.length} completed';

    return AppScreenShell(
      title: screenTitle,
      tone: AppScreenTone.brand,
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.darkOrange.withValues(alpha: 0.25),
                  AppColors.brandDeep.withValues(alpha: 0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadii.large),
              border: Border.all(color: AppColors.darkOrange.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.psychology_rounded,
                  size: 42,
                  color: AppColors.darkOrange,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        screenTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.inkOnDark,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.darkOrange,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else
            for (var i = 0; i < puzzles.length; i++) ...[
              _PuzzleCard(
                index: i + 1,
                puzzle: puzzles[i],
                isSolved: _solvedIds.contains(puzzles[i].id),
                onTap: () async {
                  await context.push(AppRoutes.puzzle(puzzles[i].id));
                  unawaited(_loadProgress());
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
        ],
      ),
    );
  }
}

class _PuzzleCard extends StatelessWidget {
  const _PuzzleCard({
    required this.index,
    required this.puzzle,
    required this.isSolved,
    required this.onTap,
  });

  final int index;
  final dynamic puzzle;
  final bool isSolved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemTitle = puzzle.localizedTitle(l10n.localeName);
    final itemDesc = puzzle.localizedDescription(l10n.localeName);
    final xpText = '+${puzzle.xpReward} XP';
    final indexLabel = index.toString();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.medium),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceDarkRaised,
            borderRadius: BorderRadius.circular(AppRadii.medium),
            border: Border.all(
              color: isSolved
                  ? AppColors.darkOrange.withValues(alpha: 0.6)
                  : AppColors.lineStrong.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isSolved
                    ? AppColors.darkOrange
                    : AppColors.brandDeep.withValues(alpha: 0.6),
                child: isSolved
                    ? const Icon(Icons.check, color: AppColors.inkOnDark)
                    : Text(
                        indexLabel,
                        style: const TextStyle(
                          color: AppColors.inkOnDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.inkOnDark,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      itemDesc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.inkMutedOnDark,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: Text(
                  xpText,
                  style: const TextStyle(
                    color: AppColors.darkOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMutedOnDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
