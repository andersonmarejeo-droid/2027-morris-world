import 'package:flutter/material.dart';
import 'package:nine_tas/l10n/generated/app_localizations.dart';

import '../../../shared/ui/app_bottom_nav.dart';
import '../../../shared/ui/app_screen_shell.dart';

class FeaturePlaceholderScreen extends StatelessWidget {
  const FeaturePlaceholderScreen({
    super.key,
    required this.featureName,
    required this.activeTab,
    required this.icon,
  });

  final String Function(AppLocalizations l10n) featureName;
  final AppNavTab activeTab;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = featureName(l10n);
    return AppScreenShell(
      title: name,
      bottomNavigationBar: AppBottomNav(active: activeTab),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56),
              const SizedBox(height: 18),
              Text(name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text(
                l10n.featureComingSoon(name),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
