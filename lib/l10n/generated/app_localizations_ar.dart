// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => '3-9-12 Morris';

  @override
  String get ageAudienceTitle => 'من سيلعب؟';

  @override
  String get ageAudienceBody =>
      'اختر الفئة العمرية لنقدّم تجربة مناسبة للجميع.';

  @override
  String get ageAudienceChild => 'أقل من 18 عامًا أو لا أريد الإجابة';

  @override
  String get ageAudienceAdult => '18 عامًا أو أكثر';

  @override
  String get ageAudiencePrivacy =>
      'لا نطلب تاريخ الميلاد. يُحفظ هذا الاختيار على هذا الجهاز فقط. الإعلانات غير مخصصة والغرف عبر الإنترنت غير متاحة لمن هم دون 18 عامًا أو لمن لا يجيبون. الإعلانات مناسبة للعائلة وبحد أقصى لتصنيف G.';

  @override
  String get ageAudienceOnlineRestricted =>
      'الغرف عبر الإنترنت متاحة فقط لمن يذكرون أن أعمارهم 18 عامًا أو أكثر. يمكن للأصغر سنًا ومن لا يجيبون اللعب ضد الكمبيوتر أو على الجهاز نفسه.';

  @override
  String get ageAudienceGotIt => 'فهمت';

  @override
  String get home => 'الرئيسية';

  @override
  String get selectGameTitle => 'اختر لعبتك';

  @override
  String get selectGameSubtitle =>
      'ثلاث ألعاب استراتيجية كلاسيكية في عالم اجتماعي هادئ.';

  @override
  String get game3Name => '3 أحجار';

  @override
  String get game3Description => 'سريعة وبسيطة وتكتيكية.';

  @override
  String get game9Name => '9 أحجار';

  @override
  String get game9Description => 'اللعبة الكلاسيكية الرئيسية.';

  @override
  String get game12Name => '12 حجرًا';

  @override
  String get game12Description => 'لوحة أكثر كثافة واستراتيجية أعمق.';

  @override
  String selectModeTitle(String gameName) {
    return 'كيف تريد لعب $gameName؟';
  }

  @override
  String get online => 'عبر الإنترنت';

  @override
  String get onlineSubtitle =>
      'ابحث عن خصم عبر الإنترنت؛ وإن لم تجد فستواجه الكمبيوتر';

  @override
  String get createPrivateRoom => 'إنشاء غرفة خاصة';

  @override
  String get joinPrivateRoom => 'الانضمام برمز الغرفة';

  @override
  String get roomCode => 'رمز الغرفة';

  @override
  String get roomCodeHint => 'أدخل الرمز الذي أرسله صديقك';

  @override
  String get waitingForOpponent => 'ستبدأ المباراة عند انضمام صديقك.';

  @override
  String get copyRoomCode => 'نسخ الرمز';

  @override
  String get roomCodeCopied => 'تم نسخ رمز الغرفة.';

  @override
  String get sparkPrivateRoomNotice =>
      'ينبغي للأطفال استخدام اللعب عبر الإنترنت بإشراف أحد الوالدين أو الوصي. شارك الرمز مع أشخاص تعرفهم فقط. لا توجد تصنيفات أو مطابقة عامة أو دردشة.';

  @override
  String get onlineOpponent => 'الخصم';

  @override
  String get onlineWaitingTurn => 'بانتظار حركة خصمك.';

  @override
  String get onlineMoveFailed =>
      'تعذر إرسال الحركة. تحقق من الاتصال وحاول مجددًا.';

  @override
  String get onlineRoomUnavailable =>
      'الغرفة غير موجودة أو ممتلئة. تحقق من الرمز.';

  @override
  String get closeOnlineRoom => 'إغلاق الغرفة';

  @override
  String get exitMatch => 'مغادرة المباراة';

  @override
  String get exitMatchConfirm =>
      'المباراة مستمرة. إذا غادرت فسيُعلن فوز خصمك. هل تريد المغادرة؟';

  @override
  String get opponentLeft => 'غادر خصمك المباراة؛ لقد فزت.';

  @override
  String get opponentTimedOut => 'لم يتحرك خصمك لمدة دقيقتين؛ لقد فزت.';

  @override
  String get challenge => 'تحدَّ';

  @override
  String get challengeSubtitle => 'ادعُ صديقًا من داخل اللعبة أو عبر رابط';

  @override
  String get offline => 'دون اتصال';

  @override
  String get offlineSubtitle =>
      'العب ضد الذكاء الاصطناعي أو لاعبين على جهاز واحد';

  @override
  String get computerModeTitle => 'العب ضد الكمبيوتر';

  @override
  String get computerModeSubtitle => 'لا يحتاج إلى إنترنت • اختر مستوى الصعوبة';

  @override
  String get sameDeviceSubtitle => 'لاعبان يتناوبان على هذا الجهاز';

  @override
  String get howToPlay => 'طريقة اللعب';

  @override
  String get friends => 'الأصدقاء';

  @override
  String get rankings => 'الترتيب';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get systemLanguage => 'استخدام لغة الجهاز';

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
  String get restart => 'إعادة البدء';

  @override
  String get lightPlayer => 'فاتح';

  @override
  String get darkPlayer => 'داكن';

  @override
  String playerWon(String player) {
    return 'فاز $player';
  }

  @override
  String get draw => 'تعادل';

  @override
  String capturePrompt(String player) {
    return '$player: أزل حجرًا للخصم';
  }

  @override
  String placePrompt(String player) {
    return '$player: ضع حجرًا';
  }

  @override
  String movePrompt(String player) {
    return '$player: قم بحركتك';
  }

  @override
  String get quickGoodMove => 'حركة جيدة!';

  @override
  String get quickCongrats => 'تهانينا!';

  @override
  String get quickGoodGame => 'لعبة جميلة!';

  @override
  String get quickMore => 'المزيد';

  @override
  String get shareInvite => 'تحدَّ عبر واتساب';

  @override
  String get challengeButton => 'تحدَّ';

  @override
  String challengePrepared(String name) {
    return 'تم تجهيز التحدي لـ $name.';
  }

  @override
  String get presenceOnline => 'متصل';

  @override
  String get presenceInMatch => 'في مباراة';

  @override
  String get presenceOffline => 'غير متصل';

  @override
  String get offlineDifficultyTitle => 'اختر مستوى الصعوبة';

  @override
  String get beginner => 'مبتدئ';

  @override
  String get easy => 'سهل';

  @override
  String get medium => 'متوسط';

  @override
  String get hard => 'صعب';

  @override
  String get master => 'خبير';

  @override
  String get sameDevice => 'لاعبان على هذا الجهاز';

  @override
  String featureComingSoon(String feature) {
    return 'بنية $feature هي خطوة التطوير التالية.';
  }

  @override
  String get errorMatchFinished => 'انتهت هذه المباراة.';

  @override
  String get errorCaptureRequired => 'أزل حجرًا للخصم أولًا.';

  @override
  String get errorPlacementFinished => 'انتهت مرحلة وضع الأحجار.';

  @override
  String get errorPointOccupied => 'هذه النقطة مشغولة.';

  @override
  String get errorNotMovementPhase => 'لا يمكن تحريك الأحجار بعد.';

  @override
  String get errorNotYourPiece => 'هذا الحجر ليس لك.';

  @override
  String get errorTargetOccupied => 'النقطة المستهدفة مشغولة.';

  @override
  String get errorNotAdjacent => 'تحرك على خط متصل إلى نقطة مجاورة.';

  @override
  String get errorNoCaptureRight => 'لا يمكنك أخذ حجر الآن.';

  @override
  String get errorOpponentPieceRequired => 'اختر حجرًا للخصم.';

  @override
  String get errorProtectedMillPiece => 'اختر أولًا حجرًا خارج صف مكتمل.';

  @override
  String get errorInvalidPoint => 'نقطة لوحة غير صالحة.';

  @override
  String get errorBoardMismatch => 'تستخدم هذه المباراة لوحة غير متوافقة.';

  @override
  String get continueMatch => 'متابعة المباراة';

  @override
  String continueMatchSubtitle(String gameName) {
    return 'تابع مباراة $gameName من حيث توقفت';
  }

  @override
  String get resume => 'العودة إلى المباراة';

  @override
  String get saveAndExit => 'حفظ وخروج';

  @override
  String get abandonMatch => 'إنهاء المباراة';

  @override
  String get matchInProgressTitle => 'المباراة مستمرة';

  @override
  String get matchInProgressBody =>
      'يتم حفظ وضع المباراة الحالي تلقائيًا. ماذا تريد أن تفعل؟';

  @override
  String get matchLoadError => 'تعذر فتح المباراة المحفوظة.';

  @override
  String get errorTitle => 'حدث خطأ';

  @override
  String get routeError => 'تعذر فتح هذه الشاشة بأمان.';

  @override
  String get backHome => 'العودة للرئيسية';

  @override
  String get noFriendsYet => 'لا يوجد أصدقاء بعد.';

  @override
  String get rankingsUnavailable =>
      'لم ترتبط تصنيفات العالم والبلد والأصدقاء بعد ببيانات لاعبين حقيقية. ستظهر التصنيفات الموثقة هنا عند توفر الخدمة.';

  @override
  String get sound => 'الصوت';

  @override
  String get haptic => 'الاهتزاز اللمسي';

  @override
  String get boardView => 'عرض اللوحة';

  @override
  String get viewFlat => '2D';

  @override
  String get viewRealistic => 'واقعي';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'ضيف';

  @override
  String get localProfile => 'ملف محلي';

  @override
  String get genericLoadError => 'تعذر تحميل المحتوى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get restartMatchTitle => 'إعادة بدء المباراة؟';

  @override
  String get restartMatchBody =>
      'سيتم استبدال الوضع المحفوظ الحالي بمباراة جديدة.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get aiFoundationNotice =>
      'كلما ارتفع المستوى، حسب الذكاء الاصطناعي عدداً أكبر من النقلات وقلّت أخطاؤه التكتيكية.';

  @override
  String get saveFailedStayInMatch =>
      'تعذر حفظ المباراة بأمان. ابقَ في المباراة وحاول مرة أخرى.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'الفاتح: $light  •  الداكن: $dark';
  }

  @override
  String get aiThinking => 'الكمبيوتر يفكر…';

  @override
  String get computerPlayer => 'الكمبيوتر';

  @override
  String get you => 'أنت';

  @override
  String moveCountLabel(int count) {
    return 'النقلة $count';
  }

  @override
  String boardPointLight(int number) {
    return 'النقطة $number، حجر فاتح';
  }

  @override
  String boardPointDark(int number) {
    return 'النقطة $number، حجر داكن';
  }

  @override
  String boardPointEmpty(int number) {
    return 'النقطة $number، فارغة';
  }

  @override
  String ratingValue(int rating) {
    return 'التصنيف $rating';
  }

  @override
  String get inviteLinkReady => 'رابط الدعوة جاهز للمشاركة.';

  @override
  String get ratings => 'التصنيفات';

  @override
  String get statistics => 'الإحصاءات';

  @override
  String get wins => 'الانتصارات';

  @override
  String get losses => 'الخسائر';

  @override
  String get bestStreak => 'أفضل سلسلة';

  @override
  String get winRate => 'نسبة الفوز';

  @override
  String countryProfile(String code) {
    return 'البلد: $code';
  }

  @override
  String get world => 'العالم';

  @override
  String get country => 'البلد';

  @override
  String recordValue(int wins, int losses) {
    return '$wins ف • $losses خ';
  }

  @override
  String get onlineArena => 'الساحة عبر الإنترنت';

  @override
  String get onlineArenaSubtitle =>
      'مباريات سريعة وتحديات للأصدقاء وتصنيفات في مكان واحد.';

  @override
  String get quickMatch => 'مباراة سريعة';

  @override
  String get onlineBackendRequired =>
      'الغرف الخاصة غير متاحة الآن. تحقق من اتصال الإنترنت وحاول مجددًا.';

  @override
  String get challengeInviteOpenedWithoutRoom =>
      'تم فتح دعوة واتساب. تعذّر إنشاء غرفة مباشرة، لذا لم تتم إضافة رمز غرفة.';

  @override
  String get challengeFriends => 'تحدي الأصدقاء';

  @override
  String get viewRankings => 'عرض التصنيفات';

  @override
  String tutorialProgress(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get tutorialPlaceTitle => 'ضع أحجارك';

  @override
  String get tutorialPlaceBody =>
      'أثناء مرحلة الوضع اضغط نقطة فارغة. ابنِ خطتك وامنع خصمك.';

  @override
  String get tutorialMillTitle => 'كوّن طاحونة';

  @override
  String get tutorialMillBody => 'ثلاثة أحجار لك على خط صالح تكوّن طاحونة.';

  @override
  String get tutorialCaptureTitle => 'التقط حجراً';

  @override
  String get tutorialCaptureBody =>
      'بعد تكوين طاحونة اختر حجراً للخصم مميزاً. يجب أخذ الأحجار خارج الطواحين أولاً عند توفرها.';

  @override
  String get tutorialMoveTitle => 'تحرك على الخطوط';

  @override
  String get tutorialMoveBody =>
      'بعد وضع جميع الأحجار حرّك حجراً إلى نقطة فارغة مجاورة. ويمكن السحب بالضغط المطول.';

  @override
  String get tutorialBlockTitle => 'احاصر الخصم';

  @override
  String get tutorialBlockBody =>
      'سيطر على التقاطعات وأغلق المسارات. من لا يملك حركة قانونية يخسر في 9 و12 حجراً.';

  @override
  String get tutorialFlyTitle => 'اطِر بثلاثة أحجار';

  @override
  String get tutorialFlyBody =>
      'عند تفعيل الطيران ووصولك إلى ثلاثة أحجار يمكنك الانتقال إلى أي نقطة فارغة.';

  @override
  String get tutorialDoubleMillTitle => 'اصنع تهديدات متكررة';

  @override
  String get tutorialDoubleMillBody =>
      'اللعب المتقدم يربط الطواحين ويفرض الالتقاط ويحافظ على الحركة.';

  @override
  String get previous => 'السابق';

  @override
  String get finish => 'إنهاء';

  @override
  String get next => 'التالي';

  @override
  String get gameExperience => 'تجربة اللعب';

  @override
  String get reduceMotion => 'تقليل الحركة';

  @override
  String get reduceMotionSubtitle => 'يعطل النبض والحركات غير الضرورية.';

  @override
  String get showMoveHints => 'إظهار تلميحات النقل';

  @override
  String get showMoveHintsSubtitle => 'يبرز الوجهات القانونية وأهداف الالتقاط.';

  @override
  String get colorAssist => 'مساعدة الألوان';

  @override
  String get colorAssistSubtitle =>
      'يضيف أشكالاً وحدوداً حتى لا تعتمد الحالات على اللون فقط.';

  @override
  String get boardSurface => 'سطح اللوحة';

  @override
  String get surfaceWood => 'خشب';

  @override
  String get surfaceDarkStone => 'حجر داكن';

  @override
  String get surfaceMarble => 'رخام';

  @override
  String get surfaceMinimal => 'بسيط';

  @override
  String get pieceTheme => 'نمط الأحجار';

  @override
  String get pieceClassic => 'كلاسيكي';

  @override
  String get pieceMarble => 'رخام';

  @override
  String get pieceObsidian => 'سبج';

  @override
  String get progression => 'التقدم';

  @override
  String levelLabel(int level) {
    return 'المستوى $level';
  }

  @override
  String xpProgress(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String get addFriendTitle => 'إضافة صديق';

  @override
  String get addFriendSubtitle => 'أضف لاعبًا إلى قائمة أصدقائك بالاسم.';

  @override
  String get friendNameLabel => 'اسم اللاعب';

  @override
  String get friendNameHint => 'اكتب اسم اللاعب';

  @override
  String get addFriendButton => 'إضافة صديق';

  @override
  String get friendNameTooShort => 'أدخل حرفين على الأقل.';

  @override
  String get friendAlreadyAdded => 'هذا اللاعب موجود بالفعل في قائمة أصدقائك.';

  @override
  String friendAdded(String name) {
    return 'تمت إضافة $name إلى أصدقائك.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'لنلعب $game معًا في 3-9-12 Morris! نزّل التطبيق من هنا: $link';
  }

  @override
  String get resultVictoryPraise => 'تهانينا! لعب رائع. هل تريد مباراة ثأرية؟';

  @override
  String get resultDefeatPraise => 'مباراة جيدة! هل أنت مستعد للثأر؟';

  @override
  String get resultDrawPraise => 'مباراة رائعة وانتهت بالتعادل. جولة أخرى؟';

  @override
  String get resultLocalPraise => 'مباراة رائعة! هل تريدان مباراة ثأرية؟';

  @override
  String get rematch => 'مباراة ثأرية';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get playerName => 'اسم اللاعب';

  @override
  String get countryCode => 'رمز الدولة';

  @override
  String get saveProfile => 'حفظ الملف الشخصي';

  @override
  String get profileSaved => 'تم حفظ الملف الشخصي.';

  @override
  String get profileSaveFailed => 'تعذر حفظ الملف الشخصي.';

  @override
  String get profileNameRequired => 'لا يمكن أن يكون اسم اللاعب فارغًا.';

  @override
  String get profileCountryCodeHint => 'مثال: TR';

  @override
  String get profileCountryCodeInvalid => 'يجب أن يتكون رمز الدولة من حرفين.';

  @override
  String get profileLocalSaveNote =>
      'يتم حفظ تفاصيل ملفك الشخصي بأمان على هذا الجهاز.';

  @override
  String get accountAndLegal => 'الحساب والمعلومات القانونية';

  @override
  String get termsOfUse => 'شروط الاستخدام';

  @override
  String get termsSummary =>
      'يقدم 3-9-12 Tas ألعاب 3 و9 و12 قطعة الكلاسيكية. استخدم التطبيق وفقًا للقانون. يُحفظ الملف الشخصي والألعاب على هذا الجهاز، ولا توجد مشتريات داخل التطبيق.\n\nعند تفعيل الغرف عبر الإنترنت، قد تُستخدم خدمات جهات خارجية مثل Firebase. شارك رموز الغرف مع أشخاص تعرفهم فقط. لتطبيقات المشاركة الخارجية شروطها الخاصة.\n\nهذه معلومات عامة عن المنتج وليست اتفاقية ملزمة. لم يتم التحقق بعد من العنوان الرسمي للناشر والشروط القانونية الخاصة بكل بلد.';

  @override
  String get legalInformation => 'معلومات قانونية';

  @override
  String get legalInformationBody =>
      'الناشر: مصطفى بولات · ZP GAMES\nللتواصل: andersonmarejeo@gmail.com\n\nلم يتم التحقق بعد من عنوان التبليغ الرسمي والاسم التجاري المسجل. استخدم بريد التواصل للإشعارات القانونية.';

  @override
  String get onlineSignOut => 'تسجيل الخروج من الجلسة عبر الإنترنت';

  @override
  String get onlineSignOutDone =>
      'تم تسجيل الخروج. تم الاحتفاظ بالألعاب المحفوظة على هذا الجهاز.';

  @override
  String get onlineSessionMissing =>
      'لا توجد جلسة نشطة عبر الإنترنت على هذا الجهاز.';

  @override
  String get deleteLocalData => 'حذف بيانات المستخدم على هذا الجهاز';

  @override
  String get deleteLocalDataTitle =>
      'هل تريد حذف بيانات المستخدم على هذا الجهاز؟';

  @override
  String get deleteLocalDataBody =>
      'سيؤدي ذلك نهائيًا إلى حذف ملفك الشخصي والأصدقاء الذين أضفتهم والألعاب المحفوظة من هذا الجهاز. لن يحذف بيانات غرف Firebase أو أي حساب بعيد. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get deleteLocalDataDone =>
      'تم حذف الملف الشخصي وقائمة الأصدقاء والألعاب المحفوظة على هذا الجهاز.';

  @override
  String get deleteAction => 'حذف البيانات';

  @override
  String get gameOptions => 'خيارات المباراة';

  @override
  String get drawRuleNotice =>
      'تنتهي المباراة بالتعادل إذا تكرر الوضع نفسه على اللوحة، مع صاحب الدور، 5 مرات، أو بعد 100 نقلة متتالية دون أسر.';

  @override
  String get offerDraw => 'اقترح التعادل';

  @override
  String get drawOfferPrompt =>
      'هل تريد اقتراح التعادل؟ تنتهي المباراة بالتعادل فقط إذا وافق الخصم.';

  @override
  String get drawOfferReceived => 'اقتراح تعادل';

  @override
  String get drawOfferReceivedBody => 'يقترح خصمك التعادل. هل توافق؟';

  @override
  String get acceptDraw => 'قبول التعادل';

  @override
  String get declineDraw => 'رفض';

  @override
  String get drawOfferDeclined => 'رفض الخصم اقتراح التعادل.';

  @override
  String get computerDrawOfferAccepted => 'وافق الكمبيوتر على اقتراح التعادل.';

  @override
  String get computerDrawOfferDeclined => 'رفض الكمبيوتر اقتراح التعادل.';

  @override
  String get resignMatch => 'استسلام';

  @override
  String get resignConfirm => 'هل أنت متأكد من الاستسلام؟ سيفوز خصمك.';
}
