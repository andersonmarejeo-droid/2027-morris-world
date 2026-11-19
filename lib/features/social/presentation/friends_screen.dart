import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_routes.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../core/game/game_definition.dart';
import '../../../shared/ui/app_async_view.dart';
import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../../gameplay/presentation/game_ui_labels.dart';
import '../application/challenge_share_service.dart';
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

  String _challengeLink() {
    return ChallengeShareService.closedTestingLink;
  }

  Future<void> _challengeViaWhatsApp() async {
    final l10n = AppLocalizations.of(context);
    final gameId = _selectedGame!;
    final online = AppServicesScope.of(context).online;

    // Gerçek bir özel oda oluşturup davet kodunu WhatsApp mesajına ekliyoruz.
    final room = await ChallengeShareService.tryCreatePrivateRoom(online, gameId);
    final opening = l10n.whatsappChallengeInvite(
      gameName(l10n, gameId),
      _challengeLink(),
    );

    final String message;
    if (room != null) {
      message = '$opening\n\n🔑 ${l10n.roomCode}: ${room.id}\n👉 ${l10n.joinPrivateRoom}';
    } else {
      message = opening;
    }

    final opened = await ChallengeShareService.shareOnWhatsApp(message);
    if (!opened) {
      if (mounted) showAppNotice(context, l10n.genericLoadError);
      return;
    }

    // Oda oluşturulduysa meydan okuyan oyuncuyu doğrudan bekleme odasına alıyoruz.
    if (room != null && mounted) {
      context.go(AppRoutes.onlineRoom(room.id));
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
      scrollable: false,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.friends),
      actions: [
        IconButton(
          tooltip: l10n.addFriendButton,
          onPressed: _addFriend,
          icon: const Icon(Icons.person_add_alt_1_rounded),
        ),
      ],
      body: AppAsyncView<List<FriendPlayer>>(
        future: _friends!,
        errorBuilder:
            (context) => Center(
              child: AppErrorView(
                message: l10n.genericLoadError,
                onRetry: _retry,
                retryLabel: l10n.retry,
              ),
            ),
        dataBuilder:
            (context, items) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FriendsDashboard(
                  count: items.length,
                  title: l10n.friends,
                  subtitle: l10n.challengeSubtitle,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadii.medium),
                    border: Border.all(
                      color: AppColors.darkOrange.withValues(alpha: 0.35),
                      width: 1.1,
                    ),
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
                const SizedBox(height: 6),
                Expanded(
                  child:
                      items.isEmpty
                          ? _EmptySocialHub(
                            onAddFriend: _addFriend,
                            onChallengeWhatsApp: _challengeViaWhatsApp,
                            l10n: l10n,
                            selectedGameName: gameName(l10n, _selectedGame!),
                          )
                          : ListView.separated(
                            itemCount: items.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 6),
                            itemBuilder:
                                (context, index) =>
                                    _FriendCard(friend: items[index]),
                          ),
                ),
              ],
            ),
      ),
    );
  }
}

class _EmptySocialHub extends StatelessWidget {
  const _EmptySocialHub({
    required this.onAddFriend,
    required this.onChallengeWhatsApp,
    required this.l10n,
    required this.selectedGameName,
  });

  final VoidCallback onAddFriend;
  final VoidCallback onChallengeWhatsApp;
  final AppLocalizations l10n;
  final String selectedGameName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: const Color(0xFFF0FAF3),
          borderRadius: BorderRadius.circular(AppRadii.large),
          elevation: 1,
          shadowColor: const Color(0xFF25D366).withValues(alpha: 0.16),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.large),
            onTap: onChallengeWhatsApp,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.large),
                border: Border.all(
                  color: AppColors.darkOrange.withValues(alpha: 0.40),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF25D366),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.challengeFriends,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.inviteLinkReady,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: AppColors.inkMuted,
                            fontSize: 11,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFF25D366),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: const Color(0xFFF0F6FF),
          borderRadius: BorderRadius.circular(AppRadii.large),
          elevation: 1,
          shadowColor: const Color(0xFF1E88E5).withValues(alpha: 0.16),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.large),
            onTap: onAddFriend,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.large),
                border: Border.all(
                  color: AppColors.darkOrange.withValues(alpha: 0.55),
                  width: 1.3,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.darkOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.addFriendButton,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.addFriendSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: AppColors.inkMuted,
                            fontSize: 11,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.darkOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _SocialPill(
                icon: Icons.emoji_events_rounded,
                label: l10n.rankings,
                accent: AppColors.selection,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _SocialPill(
                icon: Icons.public_rounded,
                label: l10n.online,
                accent: AppColors.brandDeep,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _SocialPill(
                icon: Icons.sports_esports_rounded,
                label: l10n.challenge,
                accent: AppColors.zpOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadii.large),
              border: Border.all(
                color: AppColors.darkOrange.withValues(alpha: 0.35),
                width: 1.1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.brandSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: AppColors.brandDeep,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.noFriendsYet,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.addFriendSubtitle,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.inkMuted,
                    fontSize: 11,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialPill extends StatelessWidget {
  const _SocialPill({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadii.medium),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 20),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendsDashboard extends StatelessWidget {
  const _FriendsDashboard({
    required this.count,
    required this.title,
    required this.subtitle,
  });

  final int count;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.brandDeep, AppColors.brandTop],
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
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
          ),
          child: Text(
            count.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.84),
                  fontSize: 11,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.groups_rounded, color: Colors.white, size: 24),
      ],
    ),
  );
}

class _FriendCard extends StatelessWidget {
  const _FriendCard({required this.friend});

  final FriendPlayer friend;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: _FriendIdentity(friend: friend),
      ),
    );
  }
}

class _FriendIdentity extends StatelessWidget {
  const _FriendIdentity({required this.friend});

  final FriendPlayer friend;

  @override
  Widget build(BuildContext context) {
    final initial =
        friend.name.trim().isEmpty
            ? '?'
            : friend.name.trim().characters.first.toUpperCase();
    return Row(
      children: [
        CircleAvatar(
          radius: 23,
          backgroundColor: AppColors.brandSoft,
          foregroundColor: AppColors.brandDeep,
          child: Text(initial, style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            friend.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
