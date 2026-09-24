// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Morris World';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get selectGameTitle => 'Oyununu seç';

  @override
  String get selectGameSubtitle =>
      'Üç klasik strateji oyunu, tek sade ve sosyal dünya.';

  @override
  String get game3Name => '3 Taş';

  @override
  String get game3Description => 'Hızlı, sade ve taktiksel.';

  @override
  String get game9Name => '9 Taş';

  @override
  String get game9Description => 'Ana klasik oyun.';

  @override
  String get game12Name => '12 Taş';

  @override
  String get game12Description => 'Daha yoğun tahta, daha derin strateji.';

  @override
  String selectModeTitle(String gameName) {
    return '$gameName nasıl oynansın?';
  }

  @override
  String get online => 'Çevrimiçi';

  @override
  String get onlineSubtitle => 'Dünyadan gerçek bir rakip bul';

  @override
  String get challenge => 'Meydan Oku';

  @override
  String get challengeSubtitle =>
      'Arkadaşını oyun içinden veya bağlantıyla davet et';

  @override
  String get offline => 'Çevrimdışı';

  @override
  String get offlineSubtitle => 'Yapay zekâya veya aynı cihazda iki kişi oyna';

  @override
  String get computerModeTitle => 'Bilgisayara Karşı Oyna';

  @override
  String get computerModeSubtitle =>
      'İnternet gerekmez • zorluk seviyesini seç';

  @override
  String get sameDeviceSubtitle => 'Aynı telefonda sırayla iki kişi oynayın';

  @override
  String get howToPlay => 'Nasıl oynanır';

  @override
  String get friends => 'Arkadaşlar';

  @override
  String get rankings => 'Sıralama';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get systemLanguage => 'Telefon dilini kullan';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languagePortugueseBrazil => 'Português (Brasil)';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get restart => 'Yeniden başlat';

  @override
  String get lightPlayer => 'Açık';

  @override
  String get darkPlayer => 'Koyu';

  @override
  String playerWon(String player) {
    return '$player kazandı';
  }

  @override
  String get draw => 'Berabere';

  @override
  String capturePrompt(String player) {
    return '$player: rakibin bir taşını al';
  }

  @override
  String placePrompt(String player) {
    return '$player: taşını yerleştir';
  }

  @override
  String movePrompt(String player) {
    return '$player: hamleni yap';
  }

  @override
  String get quickGoodMove => 'İyi hamle!';

  @override
  String get quickCongrats => 'Tebrikler!';

  @override
  String get quickGoodGame => 'Güzel oyun!';

  @override
  String get quickMore => 'Diğer';

  @override
  String get shareInvite => 'WhatsApp ile Meydan Oku';

  @override
  String get challengeButton => 'Meydan Oku';

  @override
  String challengePrepared(String name) {
    return '$name için meydan okuma hazırlandı.';
  }

  @override
  String get presenceOnline => 'Çevrimiçi';

  @override
  String get presenceInMatch => 'Maçta';

  @override
  String get presenceOffline => 'Çevrimdışı';

  @override
  String get offlineDifficultyTitle => 'Zorluk seviyesini seç';

  @override
  String get beginner => 'Başlangıç';

  @override
  String get easy => 'Kolay';

  @override
  String get medium => 'Orta';

  @override
  String get hard => 'Zor';

  @override
  String get master => 'Usta';

  @override
  String get sameDevice => 'Aynı cihazda iki oyuncu';

  @override
  String featureComingSoon(String feature) {
    return '$feature altyapısı sıradaki geliştirme adımında.';
  }

  @override
  String get errorMatchFinished => 'Bu maç tamamlandı.';

  @override
  String get errorCaptureRequired => 'Önce rakibin bir taşını almalısın.';

  @override
  String get errorPlacementFinished => 'Taş yerleştirme aşaması tamamlandı.';

  @override
  String get errorPointOccupied => 'Bu nokta dolu.';

  @override
  String get errorNotMovementPhase =>
      'Henüz taş hareket ettirme aşamasında değilsin.';

  @override
  String get errorNotYourPiece => 'Seçtiğin taş sana ait değil.';

  @override
  String get errorTargetOccupied => 'Hedef nokta dolu.';

  @override
  String get errorNotAdjacent => 'Taş bağlı komşu noktaya gitmeli.';

  @override
  String get errorNoCaptureRight => 'Şu anda taş alma hakkın yok.';

  @override
  String get errorOpponentPieceRequired => 'Rakibin bir taşını seçmelisin.';

  @override
  String get errorProtectedMillPiece =>
      'Önce üçlü dışında kalan bir rakip taşını seç.';

  @override
  String get errorInvalidPoint => 'Geçersiz tahta noktası.';

  @override
  String get errorBoardMismatch =>
      'Bu maç uyumsuz bir tahta tanımı kullanıyor.';

  @override
  String get continueMatch => 'Maça devam et';

  @override
  String continueMatchSubtitle(String gameName) {
    return '$gameName maçına kaldığın yerden dön';
  }

  @override
  String get resume => 'Oyuna dön';

  @override
  String get saveAndExit => 'Kaydet ve çık';

  @override
  String get abandonMatch => 'Maçı bitir';

  @override
  String get matchInProgressTitle => 'Maç devam ediyor';

  @override
  String get matchInProgressBody =>
      'Mevcut konumun otomatik olarak kaydediliyor. Ne yapmak istersin?';

  @override
  String get matchLoadError => 'Kaydedilmiş maç açılamadı.';

  @override
  String get errorTitle => 'Bir sorun oluştu';

  @override
  String get routeError => 'Bu ekran güvenli şekilde açılamadı.';

  @override
  String get backHome => 'Ana sayfaya dön';

  @override
  String get noFriendsYet => 'Henüz arkadaşın yok.';

  @override
  String get sound => 'Ses';

  @override
  String get haptic => 'Dokunsal geri bildirim';

  @override
  String get boardView => 'Tahta görünümü';

  @override
  String get viewFlat => '2D';

  @override
  String get viewRealistic => 'Gerçekçi';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'Misafir';

  @override
  String get localProfile => 'Yerel profil';

  @override
  String get genericLoadError => 'İçerik yüklenemedi.';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get restartMatchTitle => 'Maç yeniden başlatılsın mı?';

  @override
  String get restartMatchBody =>
      'Mevcut kaydedilmiş konum yeni bir maçla değiştirilecek.';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get aiFoundationNotice =>
      'Seviye yükseldikçe yapay zekâ daha fazla hamleyi hesaplar ve daha az taktik hata yapar.';

  @override
  String get saveFailedStayInMatch =>
      'Maç güvenli şekilde kaydedilemedi. Oyunda kal ve tekrar dene.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Açık: $light  •  Koyu: $dark';
  }

  @override
  String get aiThinking => 'Bilgisayar düşünüyor…';

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
    return 'Nokta $number, açık taş';
  }

  @override
  String boardPointDark(int number) {
    return 'Nokta $number, koyu taş';
  }

  @override
  String boardPointEmpty(int number) {
    return 'Nokta $number, boş';
  }

  @override
  String ratingValue(int rating) {
    return 'Puan $rating';
  }

  @override
  String get inviteLinkReady => 'Davet bağlantısı paylaşmaya hazır.';

  @override
  String get ratings => 'Puanlar';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get wins => 'Galibiyet';

  @override
  String get losses => 'Mağlubiyet';

  @override
  String get bestStreak => 'En iyi seri';

  @override
  String get winRate => 'Kazanma oranı';

  @override
  String countryProfile(String code) {
    return 'Ülke: $code';
  }

  @override
  String get world => 'Dünya';

  @override
  String get country => 'Ülke';

  @override
  String recordValue(int wins, int losses) {
    return '$wins G • $losses M';
  }

  @override
  String get onlineArena => 'Çevrimiçi Arena';

  @override
  String get onlineArenaSubtitle =>
      'Hızlı maç, arkadaş meydan okuması ve sıralamalar tek yerde.';

  @override
  String get quickMatch => 'Hızlı Maç';

  @override
  String get onlineBackendRequired =>
      'Çevrimiçi istemci altyapısı hazır. Firebase Auth, Realtime Database ve Cloud Functions dağıtılana kadar dereceli eşleştirme güvenli biçimde kapalı kalır.';

  @override
  String get challengeFriends => 'Arkadaşlarına Meydan Oku';

  @override
  String get viewRankings => 'Sıralamayı Gör';

  @override
  String tutorialProgress(int current, int total) {
    return 'Adım $current / $total';
  }

  @override
  String get tutorialPlaceTitle => 'Taşlarını yerleştir';

  @override
  String get tutorialPlaceBody =>
      'Yerleştirme aşamasında boş bir noktaya dokun. Kendi planını kurarken rakibinin yolunu da kapat.';

  @override
  String get tutorialMillTitle => 'Üçlü kur';

  @override
  String get tutorialMillBody =>
      'Geçerli bir çizgide üç taşını birleştirince üçlü oluşur. Vurgulanan çizgi örneği gösterir.';

  @override
  String get tutorialCaptureTitle => 'Rakip taşı al';

  @override
  String get tutorialCaptureBody =>
      'Üçlü kurduktan sonra vurgulanan rakip taşlardan birini seç. Üçlü dışında taş varsa önce onlar alınır.';

  @override
  String get tutorialMoveTitle => 'Ã‡izgiler boyunca hareket et';

  @override
  String get tutorialMoveBody =>
      'Tüm taşlar yerleşince bir taşını komşu boş noktaya taşı. İstersen uzun basıp sürükleyebilirsin.';

  @override
  String get tutorialBlockTitle => 'Rakibi bloke et';

  @override
  String get tutorialBlockBody =>
      'Kesişimleri kontrol et ve rakibin yollarını kapat. Standart 9 ve 12 Taşta hamlesi kalmayan oyuncu kaybeder.';

  @override
  String get tutorialFlyTitle => 'Üç taşta uç';

  @override
  String get tutorialFlyBody =>
      'Uçma kuralı açıkken üç taşa düştüğünde bir taşını herhangi bir boş noktaya taşıyabilirsin.';

  @override
  String get tutorialDoubleMillTitle => 'Tekrarlayan tehdit kur';

  @override
  String get tutorialDoubleMillBody =>
      'İleri düzey oyunda bağlı üçlüler arasında geçiş yaparak rakibi sürekli savunmaya zorla ve hareket alanını koru.';

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
      'Nabız ve gerekli olmayan hareketleri kapatır.';

  @override
  String get showMoveHints => 'Hamle ipuçlarını göster';

  @override
  String get showMoveHintsSubtitle =>
      'Geçerli hedefleri ve alınabilir taşları vurgular.';

  @override
  String get colorAssist => 'Renk desteği';

  @override
  String get colorAssistSubtitle =>
      'Durumların yalnız renkle anlatılmaması için şekil ve kenarlık ekler.';

  @override
  String get boardSurface => 'Tahta yüzeyi';

  @override
  String get surfaceWood => 'Ahşap';

  @override
  String get surfaceDarkStone => 'Koyu taş';

  @override
  String get surfaceMarble => 'Mermer';

  @override
  String get surfaceMinimal => 'Minimal';

  @override
  String get pieceTheme => 'Taş stili';

  @override
  String get pieceClassic => 'Klasik';

  @override
  String get pieceMarble => 'Mermer';

  @override
  String get pieceObsidian => 'Obsidyen';

  @override
  String get progression => 'İlerleme';

  @override
  String levelLabel(int level) {
    return 'Seviye $level';
  }

  @override
  String xpProgress(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String get addFriendTitle => 'Arkadaş Ekle';

  @override
  String get addFriendSubtitle => 'Oyuncu adını yazarak arkadaş listene ekle.';

  @override
  String get friendNameLabel => 'Oyuncu adı';

  @override
  String get friendNameHint => 'Oyuncu adını yaz';

  @override
  String get addFriendButton => 'Arkadaş Ekle';

  @override
  String get friendNameTooShort => 'En az 2 karakter gir.';

  @override
  String get friendAlreadyAdded => 'Bu oyuncu zaten arkadaş listende.';

  @override
  String friendAdded(String name) {
    return '$name arkadaşlarına eklendi.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Morris World\'de $game oynamaya meydan okuyorum! Oyunu aç veya indir: $link';
  }

  @override
  String get resultVictoryPraise =>
      'Tebrikler! Çok güzel oynadın. Rövanşa var mısın?';

  @override
  String get resultDefeatPraise =>
      'İyi mücadele! Rövanşta tekrar deneyelim mi?';

  @override
  String get resultDrawPraise => 'Güzel maçtı, berabere bitti. Bir tane daha?';

  @override
  String get resultLocalPraise => 'Güzel maç! Rövanş oynamak ister misiniz?';

  @override
  String get rematch => 'Rövanş Oyna';

  @override
  String get editProfile => 'Profili düzenle';

  @override
  String get playerName => 'Oyuncu adı';

  @override
  String get countryCode => 'Ülke kodu';

  @override
  String get saveProfile => 'Profili kaydet';

  @override
  String get profileSaved => 'Profil kaydedildi.';

  @override
  String get profileSaveFailed => 'Profil kaydedilemedi.';

  @override
  String get profileNameRequired => 'Oyuncu adı boş bırakılamaz.';

  @override
  String get profileCountryCodeHint => 'Ã–rn. TR';

  @override
  String get profileCountryCodeInvalid => 'Ülke kodu iki harf olmalıdır.';

  @override
  String get profileLocalSaveNote =>
      'Profil bilgilerin bu cihazda güvenle saklanır.';
}
