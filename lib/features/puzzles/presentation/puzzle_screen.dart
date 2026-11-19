import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/family_ads.dart';
import '../../../core/game/game_catalog.dart';
import '../../../core/game/game_definition.dart';
import '../../../core/game/game_models.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/widgets/morris_board.dart';
import '../data/puzzle_catalog.dart';
import '../data/puzzle_repository.dart';
import '../domain/puzzle_model.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key, required this.puzzleId});

  final String puzzleId;

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final PuzzleRepository _repo = PuzzleRepository();
  late MorrisPuzzle _puzzle;
  late List<PlayerSide?> _board;
  int? _selectedPoint;
  bool _isSolved = false;
  bool _showHint = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPuzzle();
  }

  void _loadPuzzle() {
    final found = MorrisPuzzleCatalog.puzzles.firstWhere(
      (p) => p.id == widget.puzzleId,
      orElse: () => MorrisPuzzleCatalog.puzzles.first,
    );
    setState(() {
      _puzzle = found;
      _board = List<PlayerSide?>.from(found.initialBoard);
      _selectedPoint = null;
      _isSolved = false;
      _showHint = false;
      _statusMessage = '';
    });
  }

  MorrisGameDefinition _getDefinition(MorrisGameId id) {
    return GameCatalog.byId(id);
  }

  Future<void> _handlePointTap(int point) async {
    if (_isSolved) return;

    final feedback = AppServicesScope.of(context).feedback;

    if (_puzzle.phase == MatchPhase.movement) {
      if (_selectedPoint == null) {
        if (_board[point] == _puzzle.turn) {
          unawaited(feedback.pieceSelected());
          setState(() {
            _selectedPoint = point;
          });
        }
        return;
      }

      // Movement move
      final from = _selectedPoint!;
      if (point == from) {
        setState(() {
          _selectedPoint = null;
        });
        return;
      }

      final isCorrect =
          (_puzzle.fromPoint == null || _puzzle.fromPoint == from) &&
          point == _puzzle.targetPoint;

      if (isCorrect) {
        unawaited(feedback.pieceMoved());
        await _onSuccess(from: from, to: point);
      } else {
        _onFailure();
      }
    } else {
      // Placement move
      if (_board[point] != null) return;
      if (point == _puzzle.targetPoint) {
        unawaited(feedback.piecePlaced());
        await _onSuccess(to: point);
      } else {
        _onFailure();
      }
    }
  }

  Future<void> _onSuccess({int? from, required int to}) async {
    final l10n = AppLocalizations.of(context);
    final feedback = AppServicesScope.of(context).feedback;
    final social = AppServicesScope.of(context).social;

    unawaited(feedback.millFormed());
    unawaited(feedback.success());

    final lang = l10n.localeName.toLowerCase();
    setState(() {
      if (from != null) _board[from] = null;
      _board[to] = _puzzle.turn;
      if (_puzzle.captureTarget != null &&
          _puzzle.captureTarget! < _board.length) {
        _board[_puzzle.captureTarget!] = null;
      }
      _isSolved = true;
      final winWord = lang.startsWith('tr')
          ? 'Harika Çözüm'
          : lang.startsWith('de')
          ? 'Tolle Lösung'
          : lang.startsWith('es')
          ? '¡Gran solución!'
          : lang.startsWith('fr')
          ? 'Excellente solution'
          : lang.startsWith('pt')
          ? 'Ótima solução'
          : lang.startsWith('ar')
          ? 'حل رائع'
          : lang.startsWith('hi')
          ? 'शानदार हल'
          : 'Great Solve';
      _statusMessage = '$winWord! +${_puzzle.xpReward} XP';
    });

    await _repo.markPuzzleSolved(_puzzle.id);

    try {
      final currentProfile = await social.getLocalProfile();
      final updated = currentProfile.recordMatchResult(
        gameId: _puzzle.gameId,
        isWin: true,
        isDraw: false,
      );
      await social.saveLocalProfile(updated);
    } catch (_) {}
  }

  void _onFailure() {
    final feedback = AppServicesScope.of(context).feedback;
    unawaited(feedback.buttonPressed());
    final lang = AppLocalizations.of(context).localeName.toLowerCase();
    final retryMsg = lang.startsWith('tr')
        ? 'Hamle hedefe ulaşamadı. Tekrar dene!'
        : lang.startsWith('de')
        ? 'Zug hat das Ziel verfehlt. Nochmal!'
        : lang.startsWith('es')
        ? 'El movimiento no acertó. ¡Intenta de nuevo!'
        : lang.startsWith('fr')
        ? 'Coup manqué. Réessaie !'
        : lang.startsWith('pt')
        ? 'Jogada incorreta. Tente novamente!'
        : lang.startsWith('ar')
        ? 'لم تصب الحركة الهدف. حاول ثانية!'
        : lang.startsWith('hi')
        ? 'चाल लक्ष्य तक नहीं पहुँची। पुनः प्रयास करें!'
        : 'Move missed the target. Try again!';
    setState(() {
      _selectedPoint = null;
      _statusMessage = retryMsg;
    });
  }

  void _resetPuzzle() {
    final lang = AppLocalizations.of(context).localeName;
    setState(() {
      _board = List<PlayerSide?>.from(_puzzle.initialBoard);
      _selectedPoint = null;
      _isSolved = false;
      _showHint = false;
      _statusMessage = _puzzle.localizedDescription(lang);
    });
  }

  void _nextPuzzle() {
    final all = MorrisPuzzleCatalog.puzzles;
    final currentIndex = all.indexWhere((p) => p.id == _puzzle.id);
    if (currentIndex >= 0 && currentIndex + 1 < all.length) {
      final next = all[currentIndex + 1];
      context.pushReplacement(AppRoutes.puzzle(next.id));
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = l10n.localeName.toLowerCase();
    final definition = _getDefinition(_puzzle.gameId);
    final theme = Theme.of(context);
    final titleText = _puzzle.localizedTitle(l10n.localeName);
    final hintBtnText = lang.startsWith('tr')
        ? 'İpucu'
        : lang.startsWith('de')
        ? 'Hinweis'
        : lang.startsWith('es')
        ? 'Pista'
        : lang.startsWith('fr')
        ? 'Indice'
        : lang.startsWith('pt')
        ? 'Dica'
        : lang.startsWith('ar')
        ? 'تلميح'
        : lang.startsWith('hi')
        ? 'संकेत'
        : 'Hint';
    final resetBtnText = lang.startsWith('tr')
        ? 'Sıfırla'
        : lang.startsWith('de')
        ? 'Zurücksetzen'
        : lang.startsWith('es')
        ? 'Reiniciar'
        : lang.startsWith('fr')
        ? 'Réinitialiser'
        : lang.startsWith('pt')
        ? 'Redefinir'
        : lang.startsWith('ar')
        ? 'إعادة ضبط'
        : lang.startsWith('hi')
        ? 'रीसेट'
        : 'Reset';
    final nextBtnText = lang.startsWith('tr')
        ? 'Sonraki Bulmaca'
        : lang.startsWith('de')
        ? 'Nächstes Rätsel'
        : lang.startsWith('es')
        ? 'Siguiente'
        : lang.startsWith('fr')
        ? 'Suivant'
        : lang.startsWith('pt')
        ? 'Próximo Enigma'
        : lang.startsWith('ar')
        ? 'اللغز التالي'
        : lang.startsWith('hi')
        ? 'अगली पहेली'
        : 'Next Puzzle';

    return AppScreenShell(
      title: titleText,
      tone: AppScreenTone.brand,
      bottomNavigationBar: const FamilyBannerAd(reserveSpace: true),
      actions: [
        IconButton(
          tooltip: resetBtnText,
          icon: const Icon(Icons.refresh_rounded),
          onPressed: _resetPuzzle,
        ),
      ],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstraints.boardMaxWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color:
                      _isSolved
                          ? AppColors.darkOrange.withValues(alpha: 0.18)
                          : AppColors.surfaceDarkRaised,
                  borderRadius: BorderRadius.circular(AppRadii.large),
                  border: Border.all(
                    color:
                        _isSolved
                            ? AppColors.darkOrange
                            : AppColors.lineStrong.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isSolved
                          ? Icons.stars_rounded
                          : Icons.lightbulb_outline_rounded,
                      color:
                          _isSolved
                              ? AppColors.darkOrange
                              : AppColors.inkOnDark,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        _statusMessage.isEmpty
                            ? _puzzle.localizedDescription(l10n.localeName)
                            : _statusMessage,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color:
                              _isSolved
                                  ? AppColors.darkOrange
                                  : AppColors.inkOnDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AspectRatio(
                aspectRatio: 1.0,
                child: MorrisBoard(
                  definition: definition,
                  board: _board,
                  selectedPoint: _selectedPoint,
                  legalTargets:
                      _showHint ? {_puzzle.targetPoint} : const <int>{},
                  onPointTap: _handlePointTap,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isSolved) ...[
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showHint = true;
                        });
                      },
                      icon: const Icon(Icons.help_outline_rounded),
                      label: Text(hintBtnText),
                    ),
                  ] else ...[
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.darkOrange,
                      ),
                      onPressed: _nextPuzzle,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(nextBtnText),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
