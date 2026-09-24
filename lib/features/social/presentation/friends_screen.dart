import 'package:flutter/material.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/game/game_definition.dart';
import '../../../shared/ui/app_async_view.dart';
import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/game_ui_labels.dart';
import '../domain/friend_player.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key, this.initialGameId});

  final MorrisGameId? initialGameId;

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  Future<List<FriendPlayer>>? _friends;
  MorrisGameId? _selectedGame;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedGame ??= widget.initialGameId ?? MorrisGameId.nine;
    _friends ??= AppServicesScope.of(context).social.getFriends();
  }

  void _retry() {
    setState(() {
      _friends = AppServicesScope.of(context).social.getFriends();
    });
  }

  Future<void> _challenge(FriendPlayer friend) async {
    final services = AppServicesScope.of(context);
    final l10n = AppLocalizations.of(context);
    await services.social.sendChallenge(friend.id, _selectedGame!);
    if (!mounted) return;
    showAppNotice(context, l10n.challengePrepared(friend.name));
  }

  static const _packageId = 'com.morrisworld.nine_tas';

  String _challengeLink() {
    final referrer =
        'utm_source=whatsapp&utm_medium=challenge&utm_campaign=${_selectedGame!.name}';
    return Uri.https('play.google.com', '/store/apps/details', <String, String>{
      'id': _packageId,
      'referrer': referrer,
    }).toString();
  }

  Future<void> _challengeViaWhatsApp() async {
    final l10n = AppLocalizations.of(context);
    final game = gameName(l10n, _selectedGame!);
    final link = _challengeLink();
    final message = l10n.whatsappChallengeInvite(game, link);
    final direct = Uri.parse(
      'whatsapp://send?text=${Uri.encodeComponent(message)}',
    );
    var opened = await launchUrl(direct, mode: LaunchMode.externalApplication);
    if (!opened) {
      final fallback = Uri.https('wa.me', '/', <String, String>{
        'text': message,
      });
      opened = await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
    if (!opened && mounted) {
      showAppNotice(context, l10n.genericLoadError);
    }
  }

  Future<void> _addFriend() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final name = await showAppBottomSheet<String>(
      context: context,
      builder:
          (sheetContext) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.addFriendTitle,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.addFriendSubtitle),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.friendNameLabel,
                  hintText: l10n.friendNameHint,
                  prefixIcon: const Icon(Icons.person_add_alt_1_rounded),
                ),
                onSubmitted:
                    (value) => closeAppOverlay(sheetContext, value.trim()),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed:
                    () => closeAppOverlay(sheetContext, controller.text.trim()),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: Text(l10n.addFriendButton),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => closeAppOverlay<String>(sheetContext),
                child: Text(l10n.cancel),
              ),
            ],
          ),
    );
    controller.dispose();
    if (!mounted || name == null) {
      return;
    }
    final trimmed = name.trim();
    if (trimmed.length < 2) {
      showAppNotice(context, l10n.friendNameTooShort);
      return;
    }
    final added = await AppServicesScope.of(context).social.addFriend(trimmed);
    if (!mounted) {
      return;
    }
    if (!added) {
      showAppNotice(context, l10n.friendAlreadyAdded);
      return;
    }
    _retry();
    showAppNotice(context, l10n.friendAdded(trimmed));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScreenShell(
      title: l10n.friends,
      scrollable: true,
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.friends),
      body: AppAsyncView<List<FriendPlayer>>(
        future: _friends!,
        errorBuilder:
            (context) => AppErrorView(
              message: l10n.genericLoadError,
              onRetry: _retry,
              retryLabel: l10n.retry,
            ),
        isEmpty: (items) => items.isEmpty,
        emptyBuilder:
            (context) => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
              child: AppEmptyView(
                icon: Icons.group_outlined,
                message: l10n.noFriendsYet,
                action: FilledButton.icon(
                  onPressed: _addFriend,
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(l10n.addFriendButton),
                ),
              ),
            ),
        dataBuilder:
            (context, items) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FriendsDashboard(
                  count: items.length,
                  title: l10n.friends,
                  gameName: gameName(l10n, _selectedGame!),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: _addFriend,
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(l10n.addFriendButton),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadii.medium),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: SegmentedButton<MorrisGameId>(
                    showSelectedIcon: false,
                    segments: [
                      for (final id in MorrisGameId.values)
                        ButtonSegment(
                          value: id,
                          label: Text(gameName(l10n, id)),
                        ),
                    ],
                    selected: {_selectedGame!},
                    onSelectionChanged:
                        (value) => setState(() => _selectedGame = value.first),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                for (final friend in items) ...[
                  _FriendCard(
                    friend: friend,
                    presence: _presence(l10n, friend.presence),
                    rating: l10n.ratingValue(friend.rating),
                    challengeLabel: l10n.challengeButton,
                    onChallenge:
                        friend.presence == Presence.inMatch
                            ? null
                            : () => _challenge(friend),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: _challengeViaWhatsApp,
                  icon: const Icon(Icons.chat_rounded),
                  label: Text(l10n.shareInvite),
                ),
              ],
            ),
      ),
    );
  }

  String _presence(AppLocalizations l10n, Presence presence) =>
      switch (presence) {
        Presence.online => l10n.presenceOnline,
        Presence.inMatch => l10n.presenceInMatch,
        Presence.offline => l10n.presenceOffline,
      };
}

class _FriendsDashboard extends StatelessWidget {
  const _FriendsDashboard({
    required this.count,
    required this.title,
    required this.gameName,
  });

  final int count;
  final String title;
  final String gameName;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.brandDeep, AppColors.brandTop],
      ),
      borderRadius: BorderRadius.circular(AppRadii.large),
    ),
    child: Row(
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
          ),
          child: Text(
            count.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                gameName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.groups_rounded, color: Colors.white, size: 28),
      ],
    ),
  );
}

class _FriendCard extends StatelessWidget {
  const _FriendCard({
    required this.friend,
    required this.presence,
    required this.rating,
    required this.challengeLabel,
    required this.onChallenge,
  });

  final FriendPlayer friend;
  final String presence;
  final String rating;
  final String challengeLabel;
  final VoidCallback? onChallenge;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FriendIdentity(friend: friend, presence: presence, rating: rating),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: onChallenge,
              icon: const Icon(Icons.sports_esports_rounded, size: 20),
              label: Text(challengeLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendIdentity extends StatelessWidget {
  const _FriendIdentity({
    required this.friend,
    required this.presence,
    required this.rating,
  });

  final FriendPlayer friend;
  final String presence;
  final String rating;

  @override
  Widget build(BuildContext context) {
    final initial =
        friend.name.trim().isEmpty
            ? '?'
            : friend.name.trim().characters.first.toUpperCase();
    final presenceColor = switch (friend.presence) {
      Presence.online => AppColors.success,
      Presence.inMatch => AppColors.zpOrange,
      Presence.offline => AppColors.inkMuted,
    };
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: AppColors.brandSoft,
              foregroundColor: AppColors.brandDeep,
              child: Text(
                initial,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Positioned(
              right: -1,
              bottom: -1,
              child: Semantics(
                label: presence,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: presenceColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).cardColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friend.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                <String>[presence, rating].join(' • '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
