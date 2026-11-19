import '../../../core/game/game_definition.dart';
import '../../../core/game/game_models.dart';

class MorrisPuzzle {
  const MorrisPuzzle({
    required this.id,
    required this.title,
    required this.description,
    required this.gameId,
    required this.phase,
    required this.initialBoard,
    required this.turn,
    this.fromPoint,
    required this.targetPoint,
    this.captureTarget,
    this.xpReward = 60,
  });

  final String id;
  final String title;
  final String description;
  final MorrisGameId gameId;
  final MatchPhase phase;
  final List<PlayerSide?> initialBoard;
  final PlayerSide turn;
  final int? fromPoint;
  final int targetPoint;
  final int? captureTarget;
  final int xpReward;

  String localizedTitle(String locale) {
    final lang = locale.toLowerCase();
    return switch (id) {
      'p_01' => lang.startsWith('tr')
          ? 'İlk Adım'
          : lang.startsWith('de')
          ? 'Erster Schritt'
          : lang.startsWith('es')
          ? 'Primer Paso'
          : lang.startsWith('fr')
          ? 'Premier Pas'
          : lang.startsWith('pt')
          ? 'Primeiro Passo'
          : lang.startsWith('ar')
          ? 'الخطوة الأولى'
          : lang.startsWith('hi')
          ? 'पहला कदम'
          : 'First Step',
      'p_02' => lang.startsWith('tr')
          ? 'Merkez Kilidi'
          : lang.startsWith('de')
          ? 'Zentrumssperre'
          : lang.startsWith('es')
          ? 'Bloqueo Central'
          : lang.startsWith('fr')
          ? 'Verrou Central'
          : lang.startsWith('pt')
          ? 'Bloqueio Central'
          : lang.startsWith('ar')
          ? 'قفل المركز'
          : lang.startsWith('hi')
          ? 'केंद्र लॉक'
          : 'Center Lock',
      'p_03' => lang.startsWith('tr')
          ? 'Taktik Süzülüş'
          : lang.startsWith('de')
          ? 'Taktischer Zug'
          : lang.startsWith('es')
          ? 'Deslizamiento Táctico'
          : lang.startsWith('fr')
          ? 'Glissement Tactique'
          : lang.startsWith('pt')
          ? 'Deslize Tático'
          : lang.startsWith('ar')
          ? 'انزلاق تكتيكي'
          : lang.startsWith('hi')
          ? 'रणनीतिक चाल'
          : 'Tactical Slide',
      'p_04' => lang.startsWith('tr')
          ? 'Kuzey Hattı'
          : lang.startsWith('de')
          ? 'Nordlinie'
          : lang.startsWith('es')
          ? 'Línea Norte'
          : lang.startsWith('fr')
          ? 'Ligne Nord'
          : lang.startsWith('pt')
          ? 'Linha Norte'
          : lang.startsWith('ar')
          ? 'الخط الشمالي'
          : lang.startsWith('hi')
          ? 'उत्तरी रेखा'
          : 'Northern Line',
      'p_05' => lang.startsWith('tr')
          ? 'İç Kale Kuşatması'
          : lang.startsWith('de')
          ? 'Innere Festung'
          : lang.startsWith('es')
          ? 'Fortaleza Interior'
          : lang.startsWith('fr')
          ? 'Forteresse Intérieure'
          : lang.startsWith('pt')
          ? 'Fortaleza Interior'
          : lang.startsWith('ar')
          ? 'الحصن الداخلي'
          : lang.startsWith('hi')
          ? 'आंतरिक किला'
          : 'Inner Fortress',
      'p_06' => lang.startsWith('tr')
          ? 'Savunma Duvarı'
          : lang.startsWith('de')
          ? 'Verteidigungswall'
          : lang.startsWith('es')
          ? 'Muro Defensivo'
          : lang.startsWith('fr')
          ? 'Mur Défensif'
          : lang.startsWith('pt')
          ? 'Muralha Defensiva'
          : lang.startsWith('ar')
          ? 'جدار الدفاع'
          : lang.startsWith('hi')
          ? 'रक्षा दीवार'
          : 'Defense Wall',
      _ => title,
    };
  }

  String localizedDescription(String locale) {
    final lang = locale.toLowerCase();
    return switch (id) {
      'p_01' => lang.startsWith('tr')
          ? 'Boş noktayı doldurarak ilk 3 taş değirmenini tamamla.'
          : lang.startsWith('de')
          ? 'Besetze den freien Punkt, um deine Mühle zu vollenden.'
          : lang.startsWith('es')
          ? 'Ocupa el punto vacío para completar tu primer molino.'
          : lang.startsWith('fr')
          ? 'Remplis le point libre pour compléter ton premier moulin.'
          : lang.startsWith('pt')
          ? 'Preencha o ponto vazio para completar seu primeiro moinho.'
          : lang.startsWith('ar')
          ? 'املأ النقطة الفارغة لإكمال أول طاحونة لك.'
          : lang.startsWith('hi')
          ? 'अपनी पहली 3 पत्थरों की मिल पूरी करने के लिए खाली स्थान भरें।'
          : 'Fill the empty spot to complete your first 3-stone mill.',
      'p_02' => lang.startsWith('tr')
          ? 'Rakibin değirmen yapmasını engellemek için kritik noktayı tut.'
          : lang.startsWith('de')
          ? 'Blockiere den Punkt, um die gegnerische Mühle zu verhindern.'
          : lang.startsWith('es')
          ? 'Bloquea el punto crítico para evitar el molino rival.'
          : lang.startsWith('fr')
          ? 'Bloque le point critique pour empêcher le moulin adverse.'
          : lang.startsWith('pt')
          ? 'Bloqueie o ponto crítico para impedir o moinho rival.'
          : lang.startsWith('ar')
          ? 'امنع الخصم من تكوين طاحونة بإغلاق النقطة الحرجة.'
          : lang.startsWith('hi')
          ? 'प्रतिद्वंद्वी को मिल बनाने से रोकने के लिए महत्वपूर्ण स्थान को रोकें।'
          : 'Block the critical spot to prevent the opponent from forming a mill.',
      'p_03' => lang.startsWith('tr')
          ? 'Merkezdeki taşını aşağı kaydırarak dikey hattı kur.'
          : lang.startsWith('de')
          ? 'Schiebe den mittleren Stein nach unten zur vertikalen Mühle.'
          : lang.startsWith('es')
          ? 'Desliza tu piedra central hacia abajo para formar el molino vertical.'
          : lang.startsWith('fr')
          ? 'Fais glisser la pièce centrale vers le bas pour former le moulin vertical.'
          : lang.startsWith('pt')
          ? 'Deslize a pedra central para baixo para formar o moinho vertical.'
          : lang.startsWith('ar')
          ? 'حرك حجرك الأوسط لأسفل لتكوين خط الطاحونة الرأسي.'
          : lang.startsWith('hi')
          ? 'ऊर्ध्वाधर मिल बनाने के लिए अपने मध्य पत्थर को नीचे खिसकाएं।'
          : 'Slide your center stone down to form the vertical mill.',
      'p_04' => lang.startsWith('tr')
          ? 'Dış çerçevenin üst hattında değirmen kur ve rakip taşı al.'
          : lang.startsWith('de')
          ? 'Bilde eine Mühle auf der oberen Außenlinie und nimm einen Stein.'
          : lang.startsWith('es')
          ? 'Forma un molino en la línea superior exterior y captura una piedra.'
          : lang.startsWith('fr')
          ? 'Forme un moulin sur la ligne extérieure supérieure et capture une pièce.'
          : lang.startsWith('pt')
          ? 'Forme um moinho na linha externa superior e capture uma pedra.'
          : lang.startsWith('ar')
          ? 'شكل طاحونة على الخط الخارجي العلوي والتقط حجر الخصم.'
          : lang.startsWith('hi')
          ? 'बाहरी ऊपरी रेखा पर मिल बनाएं और प्रतिद्वंद्वी का पत्थर हटाएं।'
          : 'Form a mill on the outer top line and capture an opponent stone.',
      'p_05' => lang.startsWith('tr')
          ? 'En iç karede 8 numaralı noktaya taş koyarak değirmen oluştur.'
          : lang.startsWith('de')
          ? 'Platziere einen Stein im inneren Quadrat zur Mühlenbildung.'
          : lang.startsWith('es')
          ? 'Coloca una piedra en el cuadro interior para formar el molino.'
          : lang.startsWith('fr')
          ? 'Place une pièce dans le carré intérieur pour former le moulin.'
          : lang.startsWith('pt')
          ? 'Coloque uma pedra no quadrado interno para formar o moinho.'
          : lang.startsWith('ar')
          ? 'ضع حجراً في المربع الداخلي لتشكيل الطاحونة.'
          : lang.startsWith('hi')
          ? 'मिल पूरी करने के लिए आंतरिक वर्ग में पत्थर रखें।'
          : 'Place a stone on the inner square to complete the mill.',
      'p_06' => lang.startsWith('tr')
          ? 'Rakibin alt hatta değirmen yapmasını önlemek için 23 noktasına yerleş.'
          : lang.startsWith('de')
          ? 'Blockiere die untere Linie, um die Mühle zu verhindern.'
          : lang.startsWith('es')
          ? 'Bloquea la línea inferior para evitar el molino rival.'
          : lang.startsWith('fr')
          ? 'Bloque la ligne inférieure pour contrer le moulin adverse.'
          : lang.startsWith('pt')
          ? 'Bloqueie a linha inferior para evitar o moinho do oponente.'
          : lang.startsWith('ar')
          ? 'أغلق الخط السفلي لمنع تشكيل طاحونة الخصم.'
          : lang.startsWith('hi')
          ? 'प्रतिद्वंद्वी की मिल रोकने के लिए निचली रेखा को ब्लॉक करें।'
          : 'Block the bottom line to prevent opponent mill formation.',
      _ => description,
    };
  }
}
