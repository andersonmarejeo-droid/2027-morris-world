import '../../../core/game/game_definition.dart';
import '../../../core/game/game_models.dart';
import '../domain/puzzle_model.dart';

abstract final class MorrisPuzzleCatalog {
  static List<MorrisPuzzle> get puzzles => [
        // 1. Üç Taş: Basit değirmen tamamlama
        MorrisPuzzle(
          id: 'p_01',
          title: 'İlk Adım',
          description: 'Boş noktayı doldurarak ilk 3 taş değirmenini tamamla.',
          gameId: MorrisGameId.three,
          phase: MatchPhase.placement,
          initialBoard: [
            PlayerSide.light, PlayerSide.light, null,
            PlayerSide.dark, PlayerSide.dark, null,
            null, null, null,
          ],
          turn: PlayerSide.light,
          targetPoint: 2,
          xpReward: 50,
        ),
        // 2. Üç Taş: Kritik savunma / Blokaj
        MorrisPuzzle(
          id: 'p_02',
          title: 'Merkez Kilidi',
          description: 'Rakibin değirmen yapmasını engellemek için kritik noktayı tut.',
          gameId: MorrisGameId.three,
          phase: MatchPhase.placement,
          initialBoard: [
            PlayerSide.light, null, null,
            PlayerSide.dark, null, PlayerSide.dark,
            null, null, PlayerSide.light,
          ],
          turn: PlayerSide.light,
          targetPoint: 4,
          xpReward: 50,
        ),
        // 3. Üç Taş: Hareketle bitiriş
        MorrisPuzzle(
          id: 'p_03',
          title: 'Taktik Süzülüş',
          description: 'Merkezdeki taşını aşağı kaydırarak dikey hattı kur.',
          gameId: MorrisGameId.three,
          phase: MatchPhase.movement,
          initialBoard: [
            null, PlayerSide.light, null,
            PlayerSide.dark, PlayerSide.light, PlayerSide.dark,
            null, null, null,
          ],
          turn: PlayerSide.light,
          fromPoint: 4,
          targetPoint: 7,
          xpReward: 60,
        ),
        // 4. Dokuz Taş: Dış hat değirmeni ve taş alma
        MorrisPuzzle(
          id: 'p_04',
          title: 'Kuzey Hattı',
          description: 'Dış çerçevenin üst hattında değirmen kur ve rakip taşı al.',
          gameId: MorrisGameId.nine,
          phase: MatchPhase.placement,
          initialBoard: _generate9Board(
            lights: [0, 2],
            darks: [4, 7],
          ),
          turn: PlayerSide.light,
          targetPoint: 1,
          captureTarget: 4,
          xpReward: 70,
        ),
        // 5. Dokuz Taş: İç kale değirmeni
        MorrisPuzzle(
          id: 'p_05',
          title: 'İç Kale Kuşatması',
          description: 'En iç karede 8 numaralı noktaya taş koyarak değirmen oluştur.',
          gameId: MorrisGameId.nine,
          phase: MatchPhase.placement,
          initialBoard: _generate9Board(
            lights: [6, 7],
            darks: [1, 2],
          ),
          turn: PlayerSide.light,
          targetPoint: 8,
          captureTarget: 1,
          xpReward: 70,
        ),
        // 6. Dokuz Taş: Kritik Blokaj
        MorrisPuzzle(
          id: 'p_06',
          title: 'Savunma Duvarı',
          description: 'Rakibin alt hatta değirmen yapmasını önlemek için 23 noktasına yerleş.',
          gameId: MorrisGameId.nine,
          phase: MatchPhase.placement,
          initialBoard: _generate9Board(
            lights: [0, 3],
            darks: [21, 22],
          ),
          turn: PlayerSide.light,
          targetPoint: 23,
          xpReward: 75,
        ),
        // 7. Dokuz Taş: Hareketle Değirmen (9-10-11 hattı)
        MorrisPuzzle(
          id: 'p_07',
          title: 'Batı Koridoru',
          description: '10 noktasındaki taşı 9 noktasına çekerek sol hattı birleştir.',
          gameId: MorrisGameId.nine,
          phase: MatchPhase.movement,
          initialBoard: _generate9Board(
            lights: [0, 10, 21],
            darks: [1, 2, 4],
          ),
          turn: PlayerSide.light,
          fromPoint: 10,
          targetPoint: 9,
          captureTarget: 4,
          xpReward: 80,
        ),
        // 8. Dokuz Taş: Aç-Kapa Tuzağı
        MorrisPuzzle(
          id: 'p_08',
          title: 'Değirmen Tuzağı',
          description: '19 noktasındaki taşı 16 noktasına çekerek iç dikey değirmeni tetikle.',
          gameId: MorrisGameId.nine,
          phase: MatchPhase.movement,
          initialBoard: _generate9Board(
            lights: [15, 17, 19],
            darks: [6, 7, 8],
          ),
          turn: PlayerSide.light,
          fromPoint: 19,
          targetPoint: 16,
          captureTarget: 6,
          xpReward: 90,
        ),
      ];

  static List<PlayerSide?> _generate9Board({
    required List<int> lights,
    required List<int> darks,
  }) {
    final list = List<PlayerSide?>.filled(24, null);
    for (final p in lights) {
      if (p >= 0 && p < 24) list[p] = PlayerSide.light;
    }
    for (final p in darks) {
      if (p >= 0 && p < 24) list[p] = PlayerSide.dark;
    }
    return list;
  }
}
