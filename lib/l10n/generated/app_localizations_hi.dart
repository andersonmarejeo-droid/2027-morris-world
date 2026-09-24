// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Morris World';

  @override
  String get home => 'मुखपृष्ठ';

  @override
  String get selectGameTitle => 'अपना खेल चुनें';

  @override
  String get selectGameSubtitle =>
      'तीन पारंपरिक रणनीति खेल, एक सरल सामाजिक दुनिया में।';

  @override
  String get game3Name => '3 गोटी';

  @override
  String get game3Description => 'तेज़, सरल और रणनीतिक।';

  @override
  String get game9Name => '9 गोटी';

  @override
  String get game9Description => 'मुख्य पारंपरिक खेल।';

  @override
  String get game12Name => '12 गोटी';

  @override
  String get game12Description => 'घना बोर्ड और गहरी रणनीति।';

  @override
  String selectModeTitle(String gameName) {
    return '$gameName कैसे खेलना चाहते हैं?';
  }

  @override
  String get online => 'ऑनलाइन';

  @override
  String get onlineSubtitle => 'दुनिया भर से असली प्रतिद्वंद्वी खोजें';

  @override
  String get challenge => 'चुनौती दें';

  @override
  String get challengeSubtitle => 'दोस्त को गेम में या लिंक से बुलाएँ';

  @override
  String get offline => 'ऑफ़लाइन';

  @override
  String get offlineSubtitle => 'AI के खिलाफ या एक डिवाइस पर दो खिलाड़ी';

  @override
  String get computerModeTitle => 'कंप्यूटर के खिलाफ खेलें';

  @override
  String get computerModeSubtitle => 'इंटरनेट की जरूरत नहीं • कठिनाई चुनें';

  @override
  String get sameDeviceSubtitle => 'इस डिवाइस पर दो खिलाड़ी बारी-बारी से खेलें';

  @override
  String get howToPlay => 'कैसे खेलें';

  @override
  String get friends => 'दोस्त';

  @override
  String get rankings => 'रैंकिंग';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get systemLanguage => 'डिवाइस की भाषा उपयोग करें';

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
  String get restart => 'फिर शुरू करें';

  @override
  String get lightPlayer => 'हल्का';

  @override
  String get darkPlayer => 'गहरा';

  @override
  String playerWon(String player) {
    return '$player जीता';
  }

  @override
  String get draw => 'ड्रॉ';

  @override
  String capturePrompt(String player) {
    return '$player: विरोधी की एक गोटी हटाएँ';
  }

  @override
  String placePrompt(String player) {
    return '$player: गोटी रखें';
  }

  @override
  String movePrompt(String player) {
    return '$player: अपनी चाल चलें';
  }

  @override
  String get quickGoodMove => 'अच्छी चाल!';

  @override
  String get quickCongrats => 'बधाई!';

  @override
  String get quickGoodGame => 'अच्छा खेल!';

  @override
  String get quickMore => 'और';

  @override
  String get shareInvite => 'WhatsApp पर चुनौती दें';

  @override
  String get challengeButton => 'चुनौती दें';

  @override
  String challengePrepared(String name) {
    return '$name के लिए चुनौती तैयार है।';
  }

  @override
  String get presenceOnline => 'ऑनलाइन';

  @override
  String get presenceInMatch => 'मैच में';

  @override
  String get presenceOffline => 'ऑफ़लाइन';

  @override
  String get offlineDifficultyTitle => 'कठिनाई चुनें';

  @override
  String get beginner => 'शुरुआती';

  @override
  String get easy => 'आसान';

  @override
  String get medium => 'मध्यम';

  @override
  String get hard => 'कठिन';

  @override
  String get master => 'मास्टर';

  @override
  String get sameDevice => 'इस डिवाइस पर दो खिलाड़ी';

  @override
  String featureComingSoon(String feature) {
    return '$feature अगला विकास चरण है।';
  }

  @override
  String get errorMatchFinished => 'यह मैच समाप्त हो चुका है।';

  @override
  String get errorCaptureRequired => 'पहले विरोधी की एक गोटी हटाएँ।';

  @override
  String get errorPlacementFinished => 'गोटी रखने का चरण समाप्त है।';

  @override
  String get errorPointOccupied => 'यह स्थान भरा है।';

  @override
  String get errorNotMovementPhase => 'अभी गोटियाँ नहीं चल सकतीं।';

  @override
  String get errorNotYourPiece => 'यह गोटी आपकी नहीं है।';

  @override
  String get errorTargetOccupied => 'लक्ष्य स्थान भरा है।';

  @override
  String get errorNotAdjacent => 'जुड़ी रेखा पर पास के स्थान तक चलें।';

  @override
  String get errorNoCaptureRight => 'अभी गोटी नहीं हटा सकते।';

  @override
  String get errorOpponentPieceRequired => 'विरोधी की गोटी चुनें।';

  @override
  String get errorProtectedMillPiece =>
      'पहले तीन की पंक्ति के बाहर की गोटी चुनें।';

  @override
  String get errorInvalidPoint => 'बोर्ड का स्थान अमान्य है।';

  @override
  String get errorBoardMismatch => 'यह मैच असंगत बोर्ड का उपयोग कर रहा है।';

  @override
  String get continueMatch => 'मैच जारी रखें';

  @override
  String continueMatchSubtitle(String gameName) {
    return 'अपना $gameName मैच वहीं से जारी रखें';
  }

  @override
  String get resume => 'मैच पर लौटें';

  @override
  String get saveAndExit => 'सेव करके बाहर जाएँ';

  @override
  String get abandonMatch => 'मैच छोड़ें';

  @override
  String get matchInProgressTitle => 'मैच जारी है';

  @override
  String get matchInProgressBody =>
      'आपकी वर्तमान स्थिति अपने आप सेव हो रही है। आप क्या करना चाहते हैं?';

  @override
  String get matchLoadError => 'सेव किया गया मैच नहीं खोला जा सका।';

  @override
  String get errorTitle => 'कुछ गलत हुआ';

  @override
  String get routeError => 'यह स्क्रीन सुरक्षित रूप से नहीं खोली जा सकी।';

  @override
  String get backHome => 'होम पर वापस जाएँ';

  @override
  String get noFriendsYet => 'अभी कोई मित्र नहीं है।';

  @override
  String get sound => 'ध्वनि';

  @override
  String get haptic => 'हैप्टिक फीडबैक';

  @override
  String get boardView => 'बोर्ड दृश्य';

  @override
  String get viewFlat => '2D';

  @override
  String get viewRealistic => 'यथार्थवादी';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'अतिथि';

  @override
  String get localProfile => 'स्थानीय प्रोफ़ाइल';

  @override
  String get genericLoadError => 'सामग्री लोड नहीं हो सकी।';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get restartMatchTitle => 'मैच फिर से शुरू करें?';

  @override
  String get restartMatchBody =>
      'वर्तमान सेव की गई स्थिति को नए मैच से बदल दिया जाएगा।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get aiFoundationNotice =>
      'ऊँचे स्तर पर एआई अधिक चालों की गणना करता है और कम रणनीतिक गलतियाँ करता है।';

  @override
  String get saveFailedStayInMatch =>
      'मैच सुरक्षित रूप से सहेजा नहीं जा सका। मैच में रहें और फिर से प्रयास करें।';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'हल्के: $light  •  गहरे: $dark';
  }

  @override
  String get aiThinking => 'कंप्यूटर सोच रहा है…';

  @override
  String get computerPlayer => 'कंप्यूटर';

  @override
  String get you => 'आप';

  @override
  String moveCountLabel(int count) {
    return 'चाल $count';
  }

  @override
  String boardPointLight(int number) {
    return 'बिंदु $number, हल्का मोहरा';
  }

  @override
  String boardPointDark(int number) {
    return 'बिंदु $number, गहरा मोहरा';
  }

  @override
  String boardPointEmpty(int number) {
    return 'बिंदु $number, खाली';
  }

  @override
  String ratingValue(int rating) {
    return 'रेटिंग $rating';
  }

  @override
  String get inviteLinkReady => 'आमंत्रण लिंक साझा करने के लिए तैयार है।';

  @override
  String get ratings => 'रेटिंग';

  @override
  String get statistics => 'आँकड़े';

  @override
  String get wins => 'जीत';

  @override
  String get losses => 'हार';

  @override
  String get bestStreak => 'सर्वश्रेष्ठ सिलसिला';

  @override
  String get winRate => 'जीत प्रतिशत';

  @override
  String countryProfile(String code) {
    return 'देश: $code';
  }

  @override
  String get world => 'विश्व';

  @override
  String get country => 'देश';

  @override
  String recordValue(int wins, int losses) {
    return '$wins जीत • $losses हार';
  }

  @override
  String get onlineArena => 'ऑनलाइन एरीना';

  @override
  String get onlineArenaSubtitle =>
      'क्विक मैच, मित्र चुनौती और रैंकिंग एक ही जगह।';

  @override
  String get quickMatch => 'क्विक मैच';

  @override
  String get onlineBackendRequired =>
      'ऑनलाइन क्लाइंट आधार तैयार है। Firebase Auth, Realtime Database और Cloud Functions तैनात होने तक रैंक्ड मैचमेकिंग सुरक्षित रूप से बंद रहेगी।';

  @override
  String get challengeFriends => 'मित्रों को चुनौती दें';

  @override
  String get viewRankings => 'रैंकिंग देखें';

  @override
  String tutorialProgress(int current, int total) {
    return 'चरण $current / $total';
  }

  @override
  String get tutorialPlaceTitle => 'अपने मोहरे रखें';

  @override
  String get tutorialPlaceBody =>
      'रखने के चरण में खाली बिंदु पर टैप करें। अपनी योजना बनाते हुए प्रतिद्वंद्वी को रोकें।';

  @override
  String get tutorialMillTitle => 'मिल बनाएँ';

  @override
  String get tutorialMillBody => 'एक वैध रेखा पर आपके तीन मोहरे मिल बनाते हैं।';

  @override
  String get tutorialCaptureTitle => 'मोहरा हटाएँ';

  @override
  String get tutorialCaptureBody =>
      'मिल बनने के बाद हाइलाइट किए गए विरोधी मोहरे को चुनें। उपलब्ध होने पर मिल के बाहर का मोहरा पहले हटता है।';

  @override
  String get tutorialMoveTitle => 'रेखाओं पर चलें';

  @override
  String get tutorialMoveBody =>
      'सभी मोहरे रखने के बाद एक मोहरे को पास के खाली बिंदु पर चलाएँ। लंबे दबाव से खींच भी सकते हैं।';

  @override
  String get tutorialBlockTitle => 'प्रतिद्वंद्वी को रोकें';

  @override
  String get tutorialBlockBody =>
      'जंक्शन नियंत्रित करें और रास्ते बंद करें। 9/12 मोहरों में वैध चाल न होने पर हार होती है।';

  @override
  String get tutorialFlyTitle => 'तीन मोहरों पर उड़ें';

  @override
  String get tutorialFlyBody =>
      'फ्लाइंग नियम चालू हो और आपके तीन मोहरे बचें तो किसी भी खाली बिंदु पर जा सकते हैं।';

  @override
  String get tutorialDoubleMillTitle => 'दोहराते खतरे बनाएँ';

  @override
  String get tutorialDoubleMillBody =>
      'उन्नत खेल में जुड़े मिलों के बीच चलकर कैप्चर मजबूर करें और गतिशीलता बनाए रखें।';

  @override
  String get previous => 'पिछला';

  @override
  String get finish => 'समाप्त';

  @override
  String get next => 'अगला';

  @override
  String get gameExperience => 'गेम अनुभव';

  @override
  String get reduceMotion => 'मोशन कम करें';

  @override
  String get reduceMotionSubtitle => 'पल्स और गैर-जरूरी गति बंद करता है।';

  @override
  String get showMoveHints => 'चाल संकेत दिखाएँ';

  @override
  String get showMoveHintsSubtitle =>
      'वैध गंतव्य और हटाए जा सकने वाले मोहरे दिखाता है।';

  @override
  String get colorAssist => 'रंग सहायता';

  @override
  String get colorAssistSubtitle =>
      'स्थिति केवल रंग से न बताने के लिए आकार और बॉर्डर जोड़ता है।';

  @override
  String get boardSurface => 'बोर्ड सतह';

  @override
  String get surfaceWood => 'लकड़ी';

  @override
  String get surfaceDarkStone => 'गहरा पत्थर';

  @override
  String get surfaceMarble => 'संगमरमर';

  @override
  String get surfaceMinimal => 'मिनिमल';

  @override
  String get pieceTheme => 'मोहरा शैली';

  @override
  String get pieceClassic => 'क्लासिक';

  @override
  String get pieceMarble => 'संगमरमर';

  @override
  String get pieceObsidian => 'ऑब्सिडियन';

  @override
  String get progression => 'प्रगति';

  @override
  String levelLabel(int level) {
    return 'स्तर $level';
  }

  @override
  String xpProgress(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String get addFriendTitle => 'मित्र जोड़ें';

  @override
  String get addFriendSubtitle =>
      'खिलाड़ी का नाम लिखकर उसे मित्र सूची में जोड़ें।';

  @override
  String get friendNameLabel => 'खिलाड़ी का नाम';

  @override
  String get friendNameHint => 'खिलाड़ी का नाम लिखें';

  @override
  String get addFriendButton => 'मित्र जोड़ें';

  @override
  String get friendNameTooShort => 'कम से कम 2 अक्षर दर्ज करें।';

  @override
  String get friendAlreadyAdded => 'यह खिलाड़ी पहले से आपकी मित्र सूची में है।';

  @override
  String friendAdded(String name) {
    return '$name को मित्र सूची में जोड़ दिया गया।';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'मैं आपको Morris World में $game की चुनौती देता हूँ! गेम खोलें या यहाँ से इंस्टॉल करें: $link';
  }

  @override
  String get resultVictoryPraise => 'बधाई! शानदार खेल। रीमैच खेलें?';

  @override
  String get resultDefeatPraise => 'अच्छा मुकाबला! रीमैच के लिए तैयार?';

  @override
  String get resultDrawPraise => 'शानदार खेल — मुकाबला बराबरी पर रहा। एक और?';

  @override
  String get resultLocalPraise => 'शानदार मुकाबला! रीमैच खेलें?';

  @override
  String get rematch => 'रीमैच खेलें';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get playerName => 'खिलाड़ी का नाम';

  @override
  String get countryCode => 'देश कोड';

  @override
  String get saveProfile => 'प्रोफ़ाइल सहेजें';

  @override
  String get profileSaved => 'प्रोफ़ाइल सहेजी गई।';

  @override
  String get profileSaveFailed => 'प्रोफ़ाइल सहेजी नहीं जा सकी।';

  @override
  String get profileNameRequired => 'खिलाड़ी का नाम खाली नहीं हो सकता।';

  @override
  String get profileCountryCodeHint => 'जैसे IN';

  @override
  String get profileCountryCodeInvalid => 'देश कोड दो अक्षरों का होना चाहिए।';

  @override
  String get profileLocalSaveNote =>
      'आपकी प्रोफ़ाइल जानकारी इस डिवाइस पर सुरक्षित रूप से सहेजी जाती है।';
}
