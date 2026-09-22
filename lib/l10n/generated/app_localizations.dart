import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('tr'),
    Locale('en'),
    Locale('ar'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'3-9-12 Taş'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @selectGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your game'**
  String get selectGameTitle;

  /// No description provided for @selectGameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Three classic strategy games, one calm social world.'**
  String get selectGameSubtitle;

  /// No description provided for @game3Name.
  ///
  /// In en, this message translates to:
  /// **'Three Men\'s Morris'**
  String get game3Name;

  /// No description provided for @game3Description.
  ///
  /// In en, this message translates to:
  /// **'Fast, simple and tactical.'**
  String get game3Description;

  /// No description provided for @game9Name.
  ///
  /// In en, this message translates to:
  /// **'Nine Men\'s Morris'**
  String get game9Name;

  /// No description provided for @game9Description.
  ///
  /// In en, this message translates to:
  /// **'The classic main game.'**
  String get game9Description;

  /// No description provided for @game12Name.
  ///
  /// In en, this message translates to:
  /// **'Twelve Men\'s Morris'**
  String get game12Name;

  /// No description provided for @game12Description.
  ///
  /// In en, this message translates to:
  /// **'A denser board with deeper strategy.'**
  String get game12Description;

  /// No description provided for @selectModeTitle.
  ///
  /// In en, this message translates to:
  /// **'How would you like to play {gameName}?'**
  String selectModeTitle(String gameName);

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @onlineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find a real opponent worldwide'**
  String get onlineSubtitle;

  /// No description provided for @challenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get challenge;

  /// No description provided for @challengeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend in-game or by link'**
  String get challengeSubtitle;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @offlineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play AI or two players on one device'**
  String get offlineSubtitle;

  /// No description provided for @computerModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Play vs Computer'**
  String get computerModeTitle;

  /// No description provided for @computerModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No internet required â€¢ choose a difficulty'**
  String get computerModeSubtitle;

  /// No description provided for @sameDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take turns with two players on this device'**
  String get sameDeviceSubtitle;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get howToPlay;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @rankings.
  ///
  /// In en, this message translates to:
  /// **'Rankings'**
  String get rankings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get systemLanguage;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'TÃ¼rkÃ§e'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'EspaÃ±ol'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'FranÃ§ais'**
  String get languageFrench;

  /// No description provided for @languagePortugueseBrazil.
  ///
  /// In en, this message translates to:
  /// **'PortuguÃªs (Brasil)'**
  String get languagePortugueseBrazil;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©'**
  String get languageArabic;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'à¤¹à¤¿à¤¨à¥à¤¦à¥€'**
  String get languageHindi;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @lightPlayer.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightPlayer;

  /// No description provided for @darkPlayer.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkPlayer;

  /// No description provided for @playerWon.
  ///
  /// In en, this message translates to:
  /// **'{player} won'**
  String playerWon(String player);

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get draw;

  /// No description provided for @capturePrompt.
  ///
  /// In en, this message translates to:
  /// **'{player}: remove one opponent piece'**
  String capturePrompt(String player);

  /// No description provided for @placePrompt.
  ///
  /// In en, this message translates to:
  /// **'{player}: place a piece'**
  String placePrompt(String player);

  /// No description provided for @movePrompt.
  ///
  /// In en, this message translates to:
  /// **'{player}: make your move'**
  String movePrompt(String player);

  /// No description provided for @quickGoodMove.
  ///
  /// In en, this message translates to:
  /// **'Good move!'**
  String get quickGoodMove;

  /// No description provided for @quickCongrats.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get quickCongrats;

  /// No description provided for @quickGoodGame.
  ///
  /// In en, this message translates to:
  /// **'Good game!'**
  String get quickGoodGame;

  /// No description provided for @quickMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get quickMore;

  /// No description provided for @shareInvite.
  ///
  /// In en, this message translates to:
  /// **'Challenge via WhatsApp'**
  String get shareInvite;

  /// No description provided for @challengeButton.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get challengeButton;

  /// No description provided for @challengePrepared.
  ///
  /// In en, this message translates to:
  /// **'Challenge for {name} is ready.'**
  String challengePrepared(String name);

  /// No description provided for @presenceOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get presenceOnline;

  /// No description provided for @presenceInMatch.
  ///
  /// In en, this message translates to:
  /// **'In match'**
  String get presenceInMatch;

  /// No description provided for @presenceOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get presenceOffline;

  /// No description provided for @offlineDifficultyTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose difficulty'**
  String get offlineDifficultyTitle;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @master.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get master;

  /// No description provided for @sameDevice.
  ///
  /// In en, this message translates to:
  /// **'Two players on this device'**
  String get sameDevice;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} infrastructure is next in the roadmap.'**
  String featureComingSoon(String feature);

  /// No description provided for @errorMatchFinished.
  ///
  /// In en, this message translates to:
  /// **'This match is finished.'**
  String get errorMatchFinished;

  /// No description provided for @errorCaptureRequired.
  ///
  /// In en, this message translates to:
  /// **'Remove an opponent piece first.'**
  String get errorCaptureRequired;

  /// No description provided for @errorPlacementFinished.
  ///
  /// In en, this message translates to:
  /// **'Placement is already finished.'**
  String get errorPlacementFinished;

  /// No description provided for @errorPointOccupied.
  ///
  /// In en, this message translates to:
  /// **'This point is occupied.'**
  String get errorPointOccupied;

  /// No description provided for @errorNotMovementPhase.
  ///
  /// In en, this message translates to:
  /// **'Pieces cannot move yet.'**
  String get errorNotMovementPhase;

  /// No description provided for @errorNotYourPiece.
  ///
  /// In en, this message translates to:
  /// **'That piece is not yours.'**
  String get errorNotYourPiece;

  /// No description provided for @errorTargetOccupied.
  ///
  /// In en, this message translates to:
  /// **'The target point is occupied.'**
  String get errorTargetOccupied;

  /// No description provided for @errorNotAdjacent.
  ///
  /// In en, this message translates to:
  /// **'Move along a connected line to an adjacent point.'**
  String get errorNotAdjacent;

  /// No description provided for @errorNoCaptureRight.
  ///
  /// In en, this message translates to:
  /// **'You cannot capture a piece now.'**
  String get errorNoCaptureRight;

  /// No description provided for @errorOpponentPieceRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose an opponent piece.'**
  String get errorOpponentPieceRequired;

  /// No description provided for @errorProtectedMillPiece.
  ///
  /// In en, this message translates to:
  /// **'Choose a piece outside a mill first.'**
  String get errorProtectedMillPiece;

  /// No description provided for @errorInvalidPoint.
  ///
  /// In en, this message translates to:
  /// **'Invalid board point.'**
  String get errorInvalidPoint;

  /// No description provided for @errorBoardMismatch.
  ///
  /// In en, this message translates to:
  /// **'This match uses an incompatible board definition.'**
  String get errorBoardMismatch;

  /// No description provided for @continueMatch.
  ///
  /// In en, this message translates to:
  /// **'Continue match'**
  String get continueMatch;

  /// No description provided for @continueMatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Resume your {gameName} match'**
  String continueMatchSubtitle(String gameName);

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Return to match'**
  String get resume;

  /// No description provided for @saveAndExit.
  ///
  /// In en, this message translates to:
  /// **'Save and exit'**
  String get saveAndExit;

  /// No description provided for @abandonMatch.
  ///
  /// In en, this message translates to:
  /// **'Abandon match'**
  String get abandonMatch;

  /// No description provided for @matchInProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Match in progress'**
  String get matchInProgressTitle;

  /// No description provided for @matchInProgressBody.
  ///
  /// In en, this message translates to:
  /// **'Your current position is saved automatically. What would you like to do?'**
  String get matchInProgressBody;

  /// No description provided for @matchLoadError.
  ///
  /// In en, this message translates to:
  /// **'The saved match could not be opened.'**
  String get matchLoadError;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @routeError.
  ///
  /// In en, this message translates to:
  /// **'This screen could not be opened safely.'**
  String get routeError;

  /// No description provided for @backHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backHome;

  /// No description provided for @noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'No friends yet.'**
  String get noFriendsYet;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @haptic.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get haptic;

  /// No description provided for @boardView.
  ///
  /// In en, this message translates to:
  /// **'Board view'**
  String get boardView;

  /// No description provided for @viewFlat.
  ///
  /// In en, this message translates to:
  /// **'2D'**
  String get viewFlat;

  /// No description provided for @viewRealistic.
  ///
  /// In en, this message translates to:
  /// **'Realistic'**
  String get viewRealistic;

  /// No description provided for @viewPerspective.
  ///
  /// In en, this message translates to:
  /// **'3D'**
  String get viewPerspective;

  /// No description provided for @guestPlayer.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestPlayer;

  /// No description provided for @localProfile.
  ///
  /// In en, this message translates to:
  /// **'Local profile'**
  String get localProfile;

  /// No description provided for @genericLoadError.
  ///
  /// In en, this message translates to:
  /// **'The content could not be loaded.'**
  String get genericLoadError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @restartMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart match?'**
  String get restartMatchTitle;

  /// No description provided for @restartMatchBody.
  ///
  /// In en, this message translates to:
  /// **'The current saved position will be replaced by a new match.'**
  String get restartMatchBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @aiFoundationNotice.
  ///
  /// In en, this message translates to:
  /// **'Higher levels look further ahead and make fewer tactical mistakes.'**
  String get aiFoundationNotice;

  /// No description provided for @saveFailedStayInMatch.
  ///
  /// In en, this message translates to:
  /// **'The match could not be saved safely. Stay in the match and try again.'**
  String get saveFailedStayInMatch;

  /// No description provided for @piecesToPlaceStatus.
  ///
  /// In en, this message translates to:
  /// **'Light: {light}  â€¢  Dark: {dark}'**
  String piecesToPlaceStatus(int light, int dark);

  /// No description provided for @aiThinking.
  ///
  /// In en, this message translates to:
  /// **'Computer is thinkingâ€¦'**
  String get aiThinking;

  /// No description provided for @computerPlayer.
  ///
  /// In en, this message translates to:
  /// **'Computer'**
  String get computerPlayer;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @moveCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Move {count}'**
  String moveCountLabel(int count);

  /// No description provided for @boardPointLight.
  ///
  /// In en, this message translates to:
  /// **'Point {number}, light piece'**
  String boardPointLight(int number);

  /// No description provided for @boardPointDark.
  ///
  /// In en, this message translates to:
  /// **'Point {number}, dark piece'**
  String boardPointDark(int number);

  /// No description provided for @boardPointEmpty.
  ///
  /// In en, this message translates to:
  /// **'Point {number}, empty'**
  String boardPointEmpty(int number);

  /// No description provided for @ratingValue.
  ///
  /// In en, this message translates to:
  /// **'Rating {rating}'**
  String ratingValue(int rating);

  /// No description provided for @inviteLinkReady.
  ///
  /// In en, this message translates to:
  /// **'Invite link is ready to share.'**
  String get inviteLinkReady;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @losses.
  ///
  /// In en, this message translates to:
  /// **'Losses'**
  String get losses;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get bestStreak;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win rate'**
  String get winRate;

  /// No description provided for @countryProfile.
  ///
  /// In en, this message translates to:
  /// **'Country: {code}'**
  String countryProfile(String code);

  /// No description provided for @world.
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get world;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @recordValue.
  ///
  /// In en, this message translates to:
  /// **'{wins} W â€¢ {losses} L'**
  String recordValue(int wins, int losses);

  /// No description provided for @onlineArena.
  ///
  /// In en, this message translates to:
  /// **'Online Arena'**
  String get onlineArena;

  /// No description provided for @onlineArenaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick matches, friend challenges and rankings in one place.'**
  String get onlineArenaSubtitle;

  /// No description provided for @quickMatch.
  ///
  /// In en, this message translates to:
  /// **'Quick Match'**
  String get quickMatch;

  /// No description provided for @onlineBackendRequired.
  ///
  /// In en, this message translates to:
  /// **'The online client foundation is ready. Ranked matchmaking stays safely disabled until Firebase Auth, Realtime Database and Cloud Functions are deployed.'**
  String get onlineBackendRequired;

  /// No description provided for @challengeFriends.
  ///
  /// In en, this message translates to:
  /// **'Challenge Friends'**
  String get challengeFriends;

  /// No description provided for @viewRankings.
  ///
  /// In en, this message translates to:
  /// **'View Rankings'**
  String get viewRankings;

  /// No description provided for @tutorialProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String tutorialProgress(int current, int total);

  /// No description provided for @tutorialPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Place your pieces'**
  String get tutorialPlaceTitle;

  /// No description provided for @tutorialPlaceBody.
  ///
  /// In en, this message translates to:
  /// **'During placement, tap an empty point. Build plans while also blocking your opponent.'**
  String get tutorialPlaceBody;

  /// No description provided for @tutorialMillTitle.
  ///
  /// In en, this message translates to:
  /// **'Build a mill'**
  String get tutorialMillTitle;

  /// No description provided for @tutorialMillBody.
  ///
  /// In en, this message translates to:
  /// **'Three of your pieces on one valid line form a mill. The highlighted line shows the pattern.'**
  String get tutorialMillBody;

  /// No description provided for @tutorialCaptureTitle.
  ///
  /// In en, this message translates to:
  /// **'Capture a piece'**
  String get tutorialCaptureTitle;

  /// No description provided for @tutorialCaptureBody.
  ///
  /// In en, this message translates to:
  /// **'After forming a mill, choose a highlighted opponent piece. Pieces outside mills must be captured first when available.'**
  String get tutorialCaptureBody;

  /// No description provided for @tutorialMoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Move along the lines'**
  String get tutorialMoveTitle;

  /// No description provided for @tutorialMoveBody.
  ///
  /// In en, this message translates to:
  /// **'After all pieces are placed, move one piece to an adjacent empty point. You can also long-press and drag.'**
  String get tutorialMoveBody;

  /// No description provided for @tutorialBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Block the opponent'**
  String get tutorialBlockTitle;

  /// No description provided for @tutorialBlockBody.
  ///
  /// In en, this message translates to:
  /// **'Control intersections and close routes. A player with no legal move loses in standard 9 and 12 Stone.'**
  String get tutorialBlockBody;

  /// No description provided for @tutorialFlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Fly with three pieces'**
  String get tutorialFlyTitle;

  /// No description provided for @tutorialFlyBody.
  ///
  /// In en, this message translates to:
  /// **'When flying is enabled and you are down to three pieces, a piece can move to any empty point.'**
  String get tutorialFlyBody;

  /// No description provided for @tutorialDoubleMillTitle.
  ///
  /// In en, this message translates to:
  /// **'Create repeating threats'**
  String get tutorialDoubleMillTitle;

  /// No description provided for @tutorialDoubleMillBody.
  ///
  /// In en, this message translates to:
  /// **'Advanced play is about moving between connected mills, forcing captures while keeping mobility.'**
  String get tutorialDoubleMillBody;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @gameExperience.
  ///
  /// In en, this message translates to:
  /// **'Game experience'**
  String get gameExperience;

  /// No description provided for @reduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get reduceMotion;

  /// No description provided for @reduceMotionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turns off pulsing and nonessential movement.'**
  String get reduceMotionSubtitle;

  /// No description provided for @showMoveHints.
  ///
  /// In en, this message translates to:
  /// **'Show move hints'**
  String get showMoveHints;

  /// No description provided for @showMoveHintsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Highlights legal destinations and capture targets.'**
  String get showMoveHintsSubtitle;

  /// No description provided for @colorAssist.
  ///
  /// In en, this message translates to:
  /// **'Color assistance'**
  String get colorAssist;

  /// No description provided for @colorAssistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adds shapes and borders so states are not communicated by color alone.'**
  String get colorAssistSubtitle;

  /// No description provided for @boardSurface.
  ///
  /// In en, this message translates to:
  /// **'Board surface'**
  String get boardSurface;

  /// No description provided for @surfaceWood.
  ///
  /// In en, this message translates to:
  /// **'Wood'**
  String get surfaceWood;

  /// No description provided for @surfaceDarkStone.
  ///
  /// In en, this message translates to:
  /// **'Dark stone'**
  String get surfaceDarkStone;

  /// No description provided for @surfaceMarble.
  ///
  /// In en, this message translates to:
  /// **'Marble'**
  String get surfaceMarble;

  /// No description provided for @surfaceMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get surfaceMinimal;

  /// No description provided for @pieceTheme.
  ///
  /// In en, this message translates to:
  /// **'Piece style'**
  String get pieceTheme;

  /// No description provided for @pieceClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get pieceClassic;

  /// No description provided for @pieceMarble.
  ///
  /// In en, this message translates to:
  /// **'Marble'**
  String get pieceMarble;

  /// No description provided for @pieceObsidian.
  ///
  /// In en, this message translates to:
  /// **'Obsidian'**
  String get pieceObsidian;

  /// No description provided for @progression.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progression;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelLabel(int level);

  /// No description provided for @xpProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target} XP'**
  String xpProgress(int current, int target);

  /// No description provided for @addFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Add friend'**
  String get addFriendTitle;

  /// No description provided for @addFriendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a player by name to your friends list.'**
  String get addFriendSubtitle;

  /// No description provided for @friendNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Player name'**
  String get friendNameLabel;

  /// No description provided for @friendNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a player name'**
  String get friendNameHint;

  /// No description provided for @addFriendButton.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriendButton;

  /// No description provided for @friendNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 2 characters.'**
  String get friendNameTooShort;

  /// No description provided for @friendAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'This player is already in your friends list.'**
  String get friendAlreadyAdded;

  /// No description provided for @friendAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} was added to your friends.'**
  String friendAdded(String name);

  /// No description provided for @whatsappChallengeInvite.
  ///
  /// In en, this message translates to:
  /// **'I challenge you to {game} in Morris World! Open or install the game here: {link}'**
  String whatsappChallengeInvite(String game, String link);

  /// No description provided for @resultVictoryPraise.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Great game. Want a rematch?'**
  String get resultVictoryPraise;

  /// No description provided for @resultDefeatPraise.
  ///
  /// In en, this message translates to:
  /// **'Good fight! Ready for a rematch?'**
  String get resultDefeatPraise;

  /// No description provided for @resultDrawPraise.
  ///
  /// In en, this message translates to:
  /// **'Great game â€” it ended in a draw. One more?'**
  String get resultDrawPraise;

  /// No description provided for @resultLocalPraise.
  ///
  /// In en, this message translates to:
  /// **'Great match! Want to play a rematch?'**
  String get resultLocalPraise;

  /// No description provided for @rematch.
  ///
  /// In en, this message translates to:
  /// **'Play Rematch'**
  String get rematch;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @playerName.
  ///
  /// In en, this message translates to:
  /// **'Player name'**
  String get playerName;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'Country code'**
  String get countryCode;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved.'**
  String get profileSaved;

  /// No description provided for @profileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'The profile could not be saved.'**
  String get profileSaveFailed;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Player name cannot be empty.'**
  String get profileNameRequired;

  /// No description provided for @profileCountryCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. US'**
  String get profileCountryCodeHint;

  /// No description provided for @profileCountryCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Country code must be two letters.'**
  String get profileCountryCodeInvalid;

  /// No description provided for @profileLocalSaveNote.
  ///
  /// In en, this message translates to:
  /// **'Your profile details are saved safely on this device.'**
  String get profileLocalSaveNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
