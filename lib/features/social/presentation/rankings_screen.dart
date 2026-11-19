import 'package:flutter/material.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/game/game_definition.dart';
import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/game_ui_labels.dart';
import '../domain/friend_player.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  MorrisGameId _selectedGame = MorrisGameId.nine;
  List<LeaderboardEntry>? _entries;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final social = AppServicesScope.of(context).social;
      final list = await social.getGameLeaderboard(_selectedGame);
      if (!mounted) return;
      setState(() {
        _entries = list;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _onGameChanged(MorrisGameId id) {
    if (_selectedGame == id) return;
    setState(() => _selectedGame = id);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = l10n.localeName.toLowerCase();
    final headerSubtitle = lang.startsWith('tr')
        ? 'Küresel ve Yerel Lig Sıralaması'
        : lang.startsWith('de')
        ? 'Globale & lokale Liga-Ranglisten'
        : lang.startsWith('es')
        ? 'Clasificación de ligas globales y locales'
        : lang.startsWith('fr')
        ? 'Classements des ligues mondiales et locales'
        : lang.startsWith('pt')
        ? 'Classificação das ligas globais e locais'
        : lang.startsWith('ar')
        ? 'ترتيب الدوريات العالمية والمحلية'
        : lang.startsWith('hi')
        ? 'वैश्विक और स्थानीय लीग स्टैंडिंग'
        : 'Global & Local League Standings';

    return AppScreenShell(
      title: l10n.rankings,
      scrollable: false,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.rankings),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.ink, AppColors.brandDeep],
              ),
              borderRadius: BorderRadius.circular(AppRadii.large),
              border: Border.all(
                color: AppColors.darkOrange.withValues(alpha: 0.45),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.selection,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.ink,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.rankings,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        headerSubtitle,
                        style: const TextStyle(
                          color: AppColors.inkMutedOnDark,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _RankingTabs(
            selected: _selectedGame,
            onChanged: _onGameChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _entries == null || _entries!.isEmpty
                    ? Center(
                        child: Text(
                          l10n.rankingsUnavailable,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _entries!.length,
                        itemBuilder: (context, index) {
                          final entry = _entries![index];
                          final isMe = entry.player.name.contains('(Sen)');
                          return _LeaderboardRow(
                            entry: entry,
                            isMe: isMe,
                            locale: l10n.localeName,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.entry,
    required this.isMe,
    required this.locale,
  });

  final LeaderboardEntry entry;
  final bool isMe;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final rank = entry.rank;
    final player = entry.player;
    final ratingLabel = '${player.rating} ELO';
    final winLossLabel = '${entry.wins}G ${entry.losses}M';
    final titleLabel = player.title.label(locale);
    final rankLabel = '#$rank';
    final youBadge = locale.startsWith('tr') ? 'SEN' : 'YOU';
    final statsLabel = '• $winLossLabel';

    Color rankColor = AppColors.inkMuted;
    IconData? rankIcon;
    if (rank == 1) {
      rankColor = const Color(0xFFFFD700);
      rankIcon = Icons.military_tech_rounded;
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0);
      rankIcon = Icons.military_tech_rounded;
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32);
      rankIcon = Icons.military_tech_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.darkOrange.withValues(alpha: 0.14)
            : AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.medium),
        border: Border.all(
          color: isMe
              ? AppColors.darkOrange
              : AppColors.line.withValues(alpha: 0.7),
          width: isMe ? 1.6 : 1.0,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: rankIcon != null
                ? Icon(rankIcon, color: rankColor, size: 22)
                : Text(
                    rankLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: rankColor,
                      fontSize: 13,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.brandSoft,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              player.countryCode,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.brandDeep,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        player.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: isMe ? FontWeight.w900 : FontWeight.w700,
                          color: isMe ? AppColors.darkOrange : AppColors.ink,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkOrange,
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                        child: Text(
                          youBadge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      titleLabel,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.inkMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statsLabel,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isMe
                  ? AppColors.darkOrange.withValues(alpha: 0.18)
                  : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Text(
              ratingLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isMe ? AppColors.darkOrange : AppColors.brandDeep,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankingTabs extends StatelessWidget {
  const _RankingTabs({required this.selected, required this.onChanged});

  final MorrisGameId selected;
  final ValueChanged<MorrisGameId> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        for (final gameId in MorrisGameId.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: ChoiceChip(
                selected: selected == gameId,
                onSelected: (_) => onChanged(gameId),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    gameName(l10n, gameId),
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
