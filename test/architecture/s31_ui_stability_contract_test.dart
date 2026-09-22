import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('game player bars keep a fixed compact height', () {
    final source =
        File(
          'lib/features/gameplay/presentation/widgets/match_player_bar.dart',
        ).readAsStringSync();

    expect(source, contains('height: 86'));
    expect(source, isNot(contains('minHeight: 96')));
    expect(source, contains('height: 22'));
    expect(source, contains('count.toString()'));
  });

  test('ranking tabs stay on one responsive line', () {
    final source =
        File(
          'lib/features/social/presentation/rankings_screen.dart',
        ).readAsStringSync();

    expect(source, contains('class _RankingTabs'));
    expect(source, contains('Expanded('));
    expect(source, contains('FittedBox('));
    expect(source, contains('softWrap: false'));
    expect(source, contains('maxLines: 1'));
  });

  test('home contains compact game cards and direct challenge entry', () {
    final source =
        File(
          'lib/features/home/presentation/home_screen.dart',
        ).readAsStringSync();

    expect(source, contains('class _ChallengeCard'));
    expect(source, contains('showAppBottomSheet<MorrisGameId>'));
    expect(source, contains('ChallengeShareService.shareOnWhatsApp'));
    expect(source, contains('width: emphasized ? 96 : 88'));
  });

  test('challenge share keeps selected game in a clickable store link', () {
    final source =
        File(
          'lib/features/social/application/challenge_share_service.dart',
        ).readAsStringSync();

    expect(source, contains(r'utm_campaign=${gameId.name}'));
    expect(source, contains('play.google.com'));
    expect(source, contains('whatsapp://send'));
    expect(source, contains('wa.me'));
  });

  test('profile editing remains persistent and phone-free', () {
    final profile =
        File(
          'lib/features/social/presentation/profile_screen.dart',
        ).readAsStringSync();
    final domain =
        File(
          'lib/features/social/domain/friend_player.dart',
        ).readAsStringSync();

    expect(profile, contains('saveLocalProfile'));
    expect(profile.toLowerCase(), isNot(contains('phone')));
    expect(domain.toLowerCase(), isNot(contains('phone')));
  });
}
