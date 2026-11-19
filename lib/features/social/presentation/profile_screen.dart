import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_services_scope.dart';
import '../../../app/app_tokens.dart';
import '../../../shared/ui/app_async_view.dart';
import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_overlays.dart';
import '../../../shared/ui/app_screen_shell.dart';
import '../domain/friend_player.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<PlayerProfile>? _profile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profile ??= AppServicesScope.of(context).social.getLocalProfile();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScreenShell(
      title: l10n.profile,
      scrollable: false,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.profile),
      body: AppAsyncView<PlayerProfile>(
        future: _profile!,
        errorBuilder: (context) => Center(
          child: AppErrorView(message: l10n.genericLoadError),
        ),
        dataBuilder:
            (context, profile) =>
                _ProfileBody(initialProfile: profile, l10n: l10n),
      ),
    );
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody({required this.initialProfile, required this.l10n});

  final PlayerProfile initialProfile;
  final AppLocalizations l10n;

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  late PlayerProfile _profile;
  late final TextEditingController _nameController;
  late final TextEditingController _countryController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _profile = widget.initialProfile;
    _nameController = TextEditingController(text: _profile.name);
    _countryController = TextEditingController(text: _profile.countryCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final l10n = widget.l10n;
    final name = _nameController.text.trim();
    final countryCode = _countryController.text.trim().toUpperCase();

    if (name.isEmpty) {
      showAppNotice(context, l10n.profileNameRequired);
      return;
    }
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(countryCode)) {
      showAppNotice(context, l10n.profileCountryCodeInvalid);
      return;
    }

    setState(() {
      _saving = true;
    });

    final next = _profile.copyWith(name: name, countryCode: countryCode);

    try {
      await AppServicesScope.of(context).social.saveLocalProfile(next);
      if (!mounted) {
        return;
      }
      setState(() {
        _profile = next;
        _saving = false;
      });
      showAppNotice(context, l10n.profileSaved);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
      });
      showAppNotice(context, l10n.profileSaveFailed);
    }
  }

  void _openEditorSheet(BuildContext context) {
    final l10n = widget.l10n;
    showAppBottomSheet<void>(
      context: context,
      builder:
          (sheetContext) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _ProfileEditor(
              l10n: l10n,
              nameController: _nameController,
              countryController: _countryController,
              saving: _saving,
              onSave: () {
                closeAppOverlay(sheetContext);
                unawaited(_saveProfile());
              },
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ProfileHero(
          profile: _profile,
          l10n: l10n,
          onEdit: () => _openEditorSheet(context),
        ),
        _ProgressCard(profile: _profile, l10n: l10n),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.ratings,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: l10n.game3Name,
                    value: _profile.rating3.toString(),
                    icon: Icons.looks_3_rounded,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _StatTile(
                    label: l10n.game9Name,
                    value: _profile.rating9.toString(),
                    icon: Icons.looks_rounded,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _StatTile(
                    label: l10n.game12Name,
                    value: _profile.rating12.toString(),
                    icon: Icons.looks_two_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.statistics,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: l10n.wins,
                    value: _profile.wins.toString(),
                    icon: Icons.workspace_premium_rounded,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _StatTile(
                    label: l10n.losses,
                    value: _profile.losses.toString(),
                    icon: Icons.flag_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _StatTile(
                    label: l10n.bestStreak,
                    value: _profile.bestStreak.toString(),
                    icon: Icons.local_fire_department_rounded,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _StatTile(
                    label: l10n.winRate,
                    value: _percentLabel((_profile.winRate * 100).round()),
                    icon: Icons.show_chart_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileEditor extends StatelessWidget {
  const _ProfileEditor({
    required this.l10n,
    required this.nameController,
    required this.countryController,
    required this.saving,
    required this.onSave,
  });

  final AppLocalizations l10n;
  final TextEditingController nameController;
  final TextEditingController countryController;
  final bool saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.editProfile,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.profileLocalSaveNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: nameController,
              maxLength: 24,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.playerName,
                prefixIcon: const Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: countryController,
              maxLength: 2,
              textCapitalization: TextCapitalization.characters,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l10n.countryCode,
                hintText: l10n.profileCountryCodeHint,
                prefixIcon: const Icon(Icons.public_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton.icon(
              onPressed: saving ? null : onSave,
              icon:
                  saving
                      ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.save_rounded),
              label: Text(l10n.saveProfile),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.profile,
    required this.l10n,
    this.onEdit,
  });
  final PlayerProfile profile;
  final AppLocalizations l10n;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final initial =
        profile.name.trim().isEmpty
            ? '?'
            : profile.name.trim().characters.first.toUpperCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.48),
                width: 2,
              ),
            ),
            child: Text(
              initial,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.countryProfile(profile.countryCode),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.84),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Text(
                        l10n.levelLabel(profile.level),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkOrange.withValues(alpha: 0.32),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        border: Border.all(
                          color: AppColors.darkOrange.withValues(alpha: 0.75),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.military_tech_rounded,
                            size: 13,
                            color: Colors.amberAccent,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            profile.title.label(l10n.localeName),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              tooltip: l10n.editProfile,
              onPressed: onEdit,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.16),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.edit_rounded, size: 20),
            ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.profile, required this.l10n});

  final PlayerProfile profile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.large),
      side: BorderSide(
        color: AppColors.darkOrange.withValues(alpha: 0.35),
        width: 1.1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.selection,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, color: AppColors.ink, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.levelLabel(profile.level),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                l10n.xpProgress(profile.xp, profile.xpForNextLevel),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: profile.levelProgress,
              minHeight: 8,
              color: AppColors.brandDeep,
              backgroundColor: AppColors.surfaceMuted,
            ),
          ),
        ],
      ),
    ),
  );
}

String _percentLabel(int value) => '$value%';

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(AppRadii.medium),
      border: Border.all(
        color: AppColors.darkOrange.withValues(alpha: 0.35),
        width: 1.1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.brandDeep, size: 16),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: AppColors.inkMuted,
          ),
        ),
      ],
    ),
  );
}
