// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => '3-9-12 Taş';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get selectGameTitle => 'Oyununu seÃ§';

  @override
  String get selectGameSubtitle =>
      'ÃœÃ§ klasik strateji oyunu, tek sade ve sosyal dÃ¼nya.';

  @override
  String get game3Name => '3 TaÅŸ';

  @override
  String get game3Description => 'HÄ±zlÄ±, sade ve taktiksel.';

  @override
  String get game9Name => '9 TaÅŸ';

  @override
  String get game9Description => 'Ana klasik oyun.';

  @override
  String get game12Name => '12 TaÅŸ';

  @override
  String get game12Description => 'Daha yoÄŸun tahta, daha derin strateji.';

  @override
  String selectModeTitle(String gameName) {
    return '$gameName nasÄ±l oynansÄ±n?';
  }

  @override
  String get online => 'Ã‡evrimiÃ§i';

  @override
  String get onlineSubtitle => 'DÃ¼nyadan gerÃ§ek bir rakip bul';

  @override
  String get challenge => 'Meydan Oku';

  @override
  String get challengeSubtitle =>
      'ArkadaÅŸÄ±nÄ± oyun iÃ§inden veya baÄŸlantÄ±yla davet et';

  @override
  String get offline => 'Ã‡evrimdÄ±ÅŸÄ±';

  @override
  String get offlineSubtitle =>
      'Yapay zekÃ¢ya veya aynÄ± cihazda iki kiÅŸi oyna';

  @override
  String get computerModeTitle => 'Bilgisayara KarÅŸÄ± Oyna';

  @override
  String get computerModeSubtitle =>
      'Ä°nternet gerekmez â€¢ zorluk seviyesini seÃ§';

  @override
  String get sameDeviceSubtitle =>
      'AynÄ± telefonda sÄ±rayla iki kiÅŸi oynayÄ±n';

  @override
  String get howToPlay => 'NasÄ±l oynanÄ±r';

  @override
  String get friends => 'ArkadaÅŸlar';

  @override
  String get rankings => 'SÄ±ralama';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get systemLanguage => 'Telefon dilini kullan';

  @override
  String get languageTurkish => 'TÃ¼rkÃ§e';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageSpanish => 'EspaÃ±ol';

  @override
  String get languageFrench => 'FranÃ§ais';

  @override
  String get languagePortugueseBrazil => 'PortuguÃªs (Brasil)';

  @override
  String get languageArabic => 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©';

  @override
  String get languageHindi => 'à¤¹à¤¿à¤¨à¥à¤¦à¥€';

  @override
  String get restart => 'Yeniden baÅŸlat';

  @override
  String get lightPlayer => 'AÃ§Ä±k';

  @override
  String get darkPlayer => 'Koyu';

  @override
  String playerWon(String player) {
    return '$player kazandÄ±';
  }

  @override
  String get draw => 'Berabere';

  @override
  String capturePrompt(String player) {
    return '$player: rakibin bir taÅŸÄ±nÄ± al';
  }

  @override
  String placePrompt(String player) {
    return '$player: taÅŸÄ±nÄ± yerleÅŸtir';
  }

  @override
  String movePrompt(String player) {
    return '$player: hamleni yap';
  }

  @override
  String get quickGoodMove => 'Ä°yi hamle!';

  @override
  String get quickCongrats => 'Tebrikler!';

  @override
  String get quickGoodGame => 'GÃ¼zel oyun!';

  @override
  String get quickMore => 'DiÄŸer';

  @override
  String get shareInvite => 'WhatsApp ile Meydan Oku';

  @override
  String get challengeButton => 'Meydan Oku';

  @override
  String challengePrepared(String name) {
    return '$name iÃ§in meydan okuma hazÄ±rlandÄ±.';
  }

  @override
  String get presenceOnline => 'Ã‡evrimiÃ§i';

  @override
  String get presenceInMatch => 'MaÃ§ta';

  @override
  String get presenceOffline => 'Ã‡evrimdÄ±ÅŸÄ±';

  @override
  String get offlineDifficultyTitle => 'Zorluk seviyesini seÃ§';

  @override
  String get beginner => 'BaÅŸlangÄ±Ã§';

  @override
  String get easy => 'Kolay';

  @override
  String get medium => 'Orta';

  @override
  String get hard => 'Zor';

  @override
  String get master => 'Usta';

  @override
  String get sameDevice => 'AynÄ± cihazda iki oyuncu';

  @override
  String featureComingSoon(String feature) {
    return '$feature altyapÄ±sÄ± sÄ±radaki geliÅŸtirme adÄ±mÄ±nda.';
  }

  @override
  String get errorMatchFinished => 'Bu maÃ§ tamamlandÄ±.';

  @override
  String get errorCaptureRequired => 'Ã–nce rakibin bir taÅŸÄ±nÄ± almalÄ±sÄ±n.';

  @override
  String get errorPlacementFinished =>
      'TaÅŸ yerleÅŸtirme aÅŸamasÄ± tamamlandÄ±.';

  @override
  String get errorPointOccupied => 'Bu nokta dolu.';

  @override
  String get errorNotMovementPhase =>
      'HenÃ¼z taÅŸ hareket ettirme aÅŸamasÄ±nda deÄŸilsin.';

  @override
  String get errorNotYourPiece => 'SeÃ§tiÄŸin taÅŸ sana ait deÄŸil.';

  @override
  String get errorTargetOccupied => 'Hedef nokta dolu.';

  @override
  String get errorNotAdjacent => 'TaÅŸ baÄŸlÄ± komÅŸu noktaya gitmeli.';

  @override
  String get errorNoCaptureRight => 'Åu anda taÅŸ alma hakkÄ±n yok.';

  @override
  String get errorOpponentPieceRequired => 'Rakibin bir taÅŸÄ±nÄ± seÃ§melisin.';

  @override
  String get errorProtectedMillPiece =>
      'Ã–nce Ã¼Ã§lÃ¼ dÄ±ÅŸÄ±nda kalan bir rakip taÅŸÄ±nÄ± seÃ§.';

  @override
  String get errorInvalidPoint => 'GeÃ§ersiz tahta noktasÄ±.';

  @override
  String get errorBoardMismatch =>
      'Bu maÃ§ uyumsuz bir tahta tanÄ±mÄ± kullanÄ±yor.';

  @override
  String get continueMatch => 'MaÃ§a devam et';

  @override
  String continueMatchSubtitle(String gameName) {
    return '$gameName maÃ§Ä±na kaldÄ±ÄŸÄ±n yerden dÃ¶n';
  }

  @override
  String get resume => 'Oyuna dÃ¶n';

  @override
  String get saveAndExit => 'Kaydet ve Ã§Ä±k';

  @override
  String get abandonMatch => 'MaÃ§Ä± bitir';

  @override
  String get matchInProgressTitle => 'MaÃ§ devam ediyor';

  @override
  String get matchInProgressBody =>
      'Mevcut konumun otomatik olarak kaydediliyor. Ne yapmak istersin?';

  @override
  String get matchLoadError => 'KaydedilmiÅŸ maÃ§ aÃ§Ä±lamadÄ±.';

  @override
  String get errorTitle => 'Bir sorun oluÅŸtu';

  @override
  String get routeError => 'Bu ekran gÃ¼venli ÅŸekilde aÃ§Ä±lamadÄ±.';

  @override
  String get backHome => 'Ana sayfaya dÃ¶n';

  @override
  String get noFriendsYet => 'HenÃ¼z arkadaÅŸÄ±n yok.';

  @override
  String get sound => 'Ses';

  @override
  String get haptic => 'Dokunsal geri bildirim';

  @override
  String get boardView => 'Tahta gÃ¶rÃ¼nÃ¼mÃ¼';

  @override
  String get viewFlat => '2D';

  @override
  String get viewRealistic => 'GerÃ§ekÃ§i';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'Misafir';

  @override
  String get localProfile => 'Yerel profil';

  @override
  String get genericLoadError => 'Ä°Ã§erik yÃ¼klenemedi.';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get restartMatchTitle => 'MaÃ§ yeniden baÅŸlatÄ±lsÄ±n mÄ±?';

  @override
  String get restartMatchBody =>
      'Mevcut kaydedilmiÅŸ konum yeni bir maÃ§la deÄŸiÅŸtirilecek.';

  @override
  String get cancel => 'VazgeÃ§';

  @override
  String get aiFoundationNotice =>
      'Seviye yÃ¼kseldikÃ§e yapay zekÃ¢ daha fazla hamleyi hesaplar ve daha az taktik hata yapar.';

  @override
  String get saveFailedStayInMatch =>
      'MaÃ§ gÃ¼venli ÅŸekilde kaydedilemedi. Oyunda kal ve tekrar dene.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'AÃ§Ä±k: $light  â€¢  Koyu: $dark';
  }

  @override
  String get aiThinking => 'Bilgisayar dÃ¼ÅŸÃ¼nÃ¼yorâ€¦';

  @override
  String get computerPlayer => 'Bilgisayar';

  @override
  String get you => 'Sen';

  @override
  String moveCountLabel(int count) {
    return 'Hamle $count';
  }

  @override
  String boardPointLight(int number) {
    return 'Nokta $number, aÃ§Ä±k taÅŸ';
  }

  @override
  String boardPointDark(int number) {
    return 'Nokta $number, koyu taÅŸ';
  }

  @override
  String boardPointEmpty(int number) {
    return 'Nokta $number, boÅŸ';
  }

  @override
  String ratingValue(int rating) {
    return 'Puan $rating';
  }

  @override
  String get inviteLinkReady => 'Davet baÄŸlantÄ±sÄ± paylaÅŸmaya hazÄ±r.';

  @override
  String get ratings => 'Puanlar';

  @override
  String get statistics => 'Ä°statistikler';

  @override
  String get wins => 'Galibiyet';

  @override
  String get losses => 'MaÄŸlubiyet';

  @override
  String get bestStreak => 'En iyi seri';

  @override
  String get winRate => 'Kazanma oranÄ±';

  @override
  String countryProfile(String code) {
    return 'Ãœlke: $code';
  }

  @override
  String get world => 'DÃ¼nya';

  @override
  String get country => 'Ãœlke';

  @override
  String recordValue(int wins, int losses) {
    return '$wins G â€¢ $losses M';
  }

  @override
  String get onlineArena => 'Ã‡evrimiÃ§i Arena';

  @override
  String get onlineArenaSubtitle =>
      'HÄ±zlÄ± maÃ§, arkadaÅŸ meydan okumasÄ± ve sÄ±ralamalar tek yerde.';

  @override
  String get quickMatch => 'HÄ±zlÄ± MaÃ§';

  @override
  String get onlineBackendRequired =>
      'Ã‡evrimiÃ§i istemci altyapÄ±sÄ± hazÄ±r. Firebase Auth, Realtime Database ve Cloud Functions daÄŸÄ±tÄ±lana kadar dereceli eÅŸleÅŸtirme gÃ¼venli biÃ§imde kapalÄ± kalÄ±r.';

  @override
  String get challengeFriends => 'ArkadaÅŸlarÄ±na Meydan Oku';

  @override
  String get viewRankings => 'SÄ±ralamayÄ± GÃ¶r';

  @override
  String tutorialProgress(int current, int total) {
    return 'AdÄ±m $current / $total';
  }

  @override
  String get tutorialPlaceTitle => 'TaÅŸlarÄ±nÄ± yerleÅŸtir';

  @override
  String get tutorialPlaceBody =>
      'YerleÅŸtirme aÅŸamasÄ±nda boÅŸ bir noktaya dokun. Kendi planÄ±nÄ± kurarken rakibinin yolunu da kapat.';

  @override
  String get tutorialMillTitle => 'ÃœÃ§lÃ¼ kur';

  @override
  String get tutorialMillBody =>
      'GeÃ§erli bir Ã§izgide Ã¼Ã§ taÅŸÄ±nÄ± birleÅŸtirince Ã¼Ã§lÃ¼ oluÅŸur. Vurgulanan Ã§izgi Ã¶rneÄŸi gÃ¶sterir.';

  @override
  String get tutorialCaptureTitle => 'Rakip taÅŸÄ± al';

  @override
  String get tutorialCaptureBody =>
      'ÃœÃ§lÃ¼ kurduktan sonra vurgulanan rakip taÅŸlardan birini seÃ§. ÃœÃ§lÃ¼ dÄ±ÅŸÄ±nda taÅŸ varsa Ã¶nce onlar alÄ±nÄ±r.';

  @override
  String get tutorialMoveTitle => 'Ã‡izgiler boyunca hareket et';

  @override
  String get tutorialMoveBody =>
      'TÃ¼m taÅŸlar yerleÅŸince bir taÅŸÄ±nÄ± komÅŸu boÅŸ noktaya taÅŸÄ±. Ä°stersen uzun basÄ±p sÃ¼rÃ¼kleyebilirsin.';

  @override
  String get tutorialBlockTitle => 'Rakibi bloke et';

  @override
  String get tutorialBlockBody =>
      'KesiÅŸimleri kontrol et ve rakibin yollarÄ±nÄ± kapat. Standart 9 ve 12 TaÅŸta hamlesi kalmayan oyuncu kaybeder.';

  @override
  String get tutorialFlyTitle => 'ÃœÃ§ taÅŸta uÃ§';

  @override
  String get tutorialFlyBody =>
      'UÃ§ma kuralÄ± aÃ§Ä±kken Ã¼Ã§ taÅŸa dÃ¼ÅŸtÃ¼ÄŸÃ¼nde bir taÅŸÄ±nÄ± herhangi bir boÅŸ noktaya taÅŸÄ±yabilirsin.';

  @override
  String get tutorialDoubleMillTitle => 'Tekrarlayan tehdit kur';

  @override
  String get tutorialDoubleMillBody =>
      'Ä°leri dÃ¼zey oyunda baÄŸlÄ± Ã¼Ã§lÃ¼ler arasÄ±nda geÃ§iÅŸ yaparak rakibi sÃ¼rekli savunmaya zorla ve hareket alanÄ±nÄ± koru.';

  @override
  String get previous => 'Ã–nceki';

  @override
  String get finish => 'Bitir';

  @override
  String get next => 'Sonraki';

  @override
  String get gameExperience => 'Oyun deneyimi';

  @override
  String get reduceMotion => 'Hareketi azalt';

  @override
  String get reduceMotionSubtitle =>
      'NabÄ±z ve gerekli olmayan hareketleri kapatÄ±r.';

  @override
  String get showMoveHints => 'Hamle ipuÃ§larÄ±nÄ± gÃ¶ster';

  @override
  String get showMoveHintsSubtitle =>
      'GeÃ§erli hedefleri ve alÄ±nabilir taÅŸlarÄ± vurgular.';

  @override
  String get colorAssist => 'Renk desteÄŸi';

  @override
  String get colorAssistSubtitle =>
      'DurumlarÄ±n yalnÄ±z renkle anlatÄ±lmamasÄ± iÃ§in ÅŸekil ve kenarlÄ±k ekler.';

  @override
  String get boardSurface => 'Tahta yÃ¼zeyi';

  @override
  String get surfaceWood => 'AhÅŸap';

  @override
  String get surfaceDarkStone => 'Koyu taÅŸ';

  @override
  String get surfaceMarble => 'Mermer';

  @override
  String get surfaceMinimal => 'Minimal';

  @override
  String get pieceTheme => 'TaÅŸ stili';

  @override
  String get pieceClassic => 'Klasik';

  @override
  String get pieceMarble => 'Mermer';

  @override
  String get pieceObsidian => 'Obsidyen';

  @override
  String get progression => 'Ä°lerleme';

  @override
  String levelLabel(int level) {
    return 'Seviye $level';
  }

  @override
  String xpProgress(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String get addFriendTitle => 'ArkadaÅŸ Ekle';

  @override
  String get addFriendSubtitle =>
      'Oyuncu adÄ±nÄ± yazarak arkadaÅŸ listene ekle.';

  @override
  String get friendNameLabel => 'Oyuncu adÄ±';

  @override
  String get friendNameHint => 'Oyuncu adÄ±nÄ± yaz';

  @override
  String get addFriendButton => 'ArkadaÅŸ Ekle';

  @override
  String get friendNameTooShort => 'En az 2 karakter gir.';

  @override
  String get friendAlreadyAdded => 'Bu oyuncu zaten arkadaÅŸ listende.';

  @override
  String friendAdded(String name) {
    return '$name arkadaÅŸlarÄ±na eklendi.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Morris World\'de $game oynamaya meydan okuyorum! Oyunu aÃ§ veya indir: $link';
  }

  @override
  String get resultVictoryPraise =>
      'Tebrikler! Ã‡ok gÃ¼zel oynadÄ±n. RÃ¶vanÅŸa var mÄ±sÄ±n?';

  @override
  String get resultDefeatPraise =>
      'Ä°yi mÃ¼cadele! RÃ¶vanÅŸta tekrar deneyelim mi?';

  @override
  String get resultDrawPraise =>
      'GÃ¼zel maÃ§tÄ±, berabere bitti. Bir tane daha?';

  @override
  String get resultLocalPraise =>
      'GÃ¼zel maÃ§! RÃ¶vanÅŸ oynamak ister misiniz?';

  @override
  String get rematch => 'RÃ¶vanÅŸ Oyna';

  @override
  String get editProfile => 'Profili dÃ¼zenle';

  @override
  String get playerName => 'Oyuncu adÄ±';

  @override
  String get countryCode => 'Ãœlke kodu';

  @override
  String get saveProfile => 'Profili kaydet';

  @override
  String get profileSaved => 'Profil kaydedildi.';

  @override
  String get profileSaveFailed => 'Profil kaydedilemedi.';

  @override
  String get profileNameRequired => 'Oyuncu adÄ± boÅŸ bÄ±rakÄ±lamaz.';

  @override
  String get profileCountryCodeHint => 'Ã–rn. TR';

  @override
  String get profileCountryCodeInvalid => 'Ãœlke kodu iki harf olmalÄ±dÄ±r.';

  @override
  String get profileLocalSaveNote =>
      'Profil bilgilerin bu cihazda gÃ¼venle saklanÄ±r.';
}
