import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sprint 01 shared shell and navigation contract is present', () {
    final shell = File('lib/shared/ui/app_screen_shell.dart').readAsStringSync();
    final nav = File('lib/shared/ui/app_bottom_nav.dart').readAsStringSync();
    final home = File('lib/features/home/presentation/home_screen.dart').readAsStringSync();
    final router = File('lib/app/app_router.dart').readAsStringSync();

    expect(shell, contains('enum AppScreenTone'));
    expect(shell, contains('AppScreenTone.brand'));
    expect(nav, contains('enum AppNavTab'));
    expect(home, contains('AppBottomNav(active: AppNavTab.home)'));
    expect(router, contains('AppRoutes.rankings'));
    expect(router, contains('AppRoutes.profile'));
  });
}
