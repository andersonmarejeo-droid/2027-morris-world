// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '3-9-12 Taş';

  @override
  String get home => 'Home';

  @override
  String get selectGameTitle => 'Choose your game';

  @override
  String get selectGameSubtitle =>
      'Three classic strategy games, one calm social world.';

  @override
  String get game3Name => 'Three Men\'s Morris';

  @override
  String get game3Description => 'Fast, simple and tactical.';

  @override
  String get game9Name => 'Nine Men\'s Morris';

  @override
  String get game9Description => 'The classic main game.';

  @override
  String get game12Name => 'Twelve Men\'s Morris';

  @override
  String get game12Description => 'A denser board with deeper strategy.';

  @override
  String selectModeTitle(String gameName) {
    return 'How would you like to play $gameName?';
  }

  @override
  String get online => 'Online';

  @override
  String get onlineSubtitle => 'Find a real opponent worldwide';

  @override
  String get challenge => 'Challenge';

  @override
  String get challengeSubtitle => 'Invite a friend in-game or by link';

  @override
  String get offline => 'Offline';

  @override
  String get offlineSubtitle => 'Play AI or two players on one device';

  @override
  String get computerModeTitle => 'Play vs Computer';

  @override
  String get computerModeSubtitle =>
      'No internet required â€¢ choose a difficulty';

  @override
  String get sameDeviceSubtitle => 'Take turns with two players on this device';

  @override
  String get howToPlay => 'How to play';

  @override
  String get friends => 'Friends';

  @override
  String get rankings => 'Rankings';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'Use device language';

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
  String get restart => 'Restart';

  @override
  String get lightPlayer => 'Light';

  @override
  String get darkPlayer => 'Dark';

  @override
  String playerWon(String player) {
    return '$player won';
  }

  @override
  String get draw => 'Draw';

  @override
  String capturePrompt(String player) {
    return '$player: remove one opponent piece';
  }

  @override
  String placePrompt(String player) {
    return '$player: place a piece';
  }

  @override
  String movePrompt(String player) {
    return '$player: make your move';
  }

  @override
  String get quickGoodMove => 'Good move!';

  @override
  String get quickCongrats => 'Congratulations!';

  @override
  String get quickGoodGame => 'Good game!';

  @override
  String get quickMore => 'More';

  @override
  String get shareInvite => 'Challenge via WhatsApp';

  @override
  String get challengeButton => 'Challenge';

  @override
  String challengePrepared(String name) {
    return 'Challenge for $name is ready.';
  }

  @override
  String get presenceOnline => 'Online';

  @override
  String get presenceInMatch => 'In match';

  @override
  String get presenceOffline => 'Offline';

  @override
  String get offlineDifficultyTitle => 'Choose difficulty';

  @override
  String get beginner => 'Beginner';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get master => 'Master';

  @override
  String get sameDevice => 'Two players on this device';

  @override
  String featureComingSoon(String feature) {
    return '$feature infrastructure is next in the roadmap.';
  }

  @override
  String get errorMatchFinished => 'This match is finished.';

  @override
  String get errorCaptureRequired => 'Remove an opponent piece first.';

  @override
  String get errorPlacementFinished => 'Placement is already finished.';

  @override
  String get errorPointOccupied => 'This point is occupied.';

  @override
  String get errorNotMovementPhase => 'Pieces cannot move yet.';

  @override
  String get errorNotYourPiece => 'That piece is not yours.';

  @override
  String get errorTargetOccupied => 'The target point is occupied.';

  @override
  String get errorNotAdjacent =>
      'Move along a connected line to an adjacent point.';

  @override
  String get errorNoCaptureRight => 'You cannot capture a piece now.';

  @override
  String get errorOpponentPieceRequired => 'Choose an opponent piece.';

  @override
  String get errorProtectedMillPiece => 'Choose a piece outside a mill first.';

  @override
  String get errorInvalidPoint => 'Invalid board point.';

  @override
  String get errorBoardMismatch =>
      'This match uses an incompatible board definition.';

  @override
  String get continueMatch => 'Continue match';

  @override
  String continueMatchSubtitle(String gameName) {
    return 'Resume your $gameName match';
  }

  @override
  String get resume => 'Return to match';

  @override
  String get saveAndExit => 'Save and exit';

  @override
  String get abandonMatch => 'Abandon match';

  @override
  String get matchInProgressTitle => 'Match in progress';

  @override
  String get matchInProgressBody =>
      'Your current position is saved automatically. What would you like to do?';

  @override
  String get matchLoadError => 'The saved match could not be opened.';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get routeError => 'This screen could not be opened safely.';

  @override
  String get backHome => 'Back to home';

  @override
  String get noFriendsYet => 'No friends yet.';

  @override
  String get sound => 'Sound';

  @override
  String get haptic => 'Haptic feedback';

  @override
  String get boardView => 'Board view';

  @override
  String get viewFlat => '2D';

  @override
  String get viewRealistic => 'Realistic';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'Guest';

  @override
  String get localProfile => 'Local profile';

  @override
  String get genericLoadError => 'The content could not be loaded.';

  @override
  String get retry => 'Retry';

  @override
  String get restartMatchTitle => 'Restart match?';

  @override
  String get restartMatchBody =>
      'The current saved position will be replaced by a new match.';

  @override
  String get cancel => 'Cancel';

  @override
  String get aiFoundationNotice =>
      'Higher levels look further ahead and make fewer tactical mistakes.';

  @override
  String get saveFailedStayInMatch =>
      'The match could not be saved safely. Stay in the match and try again.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Light: $light  â€¢  Dark: $dark';
  }

  @override
  String get aiThinking => 'Computer is thinkingâ€¦';

  @override
  String get computerPlayer => 'Computer';

  @override
  String get you => 'You';

  @override
  String moveCountLabel(int count) {
    return 'Move $count';
  }

  @override
  String boardPointLight(int number) {
    return 'Point $number, light piece';
  }

  @override
  String boardPointDark(int number) {
    return 'Point $number, dark piece';
  }

  @override
  String boardPointEmpty(int number) {
    return 'Point $number, empty';
  }

  @override
  String ratingValue(int rating) {
    return 'Rating $rating';
  }

  @override
  String get inviteLinkReady => 'Invite link is ready to share.';

  @override
  String get ratings => 'Ratings';

  @override
  String get statistics => 'Statistics';

  @override
  String get wins => 'Wins';

  @override
  String get losses => 'Losses';

  @override
  String get bestStreak => 'Best streak';

  @override
  String get winRate => 'Win rate';

  @override
  String countryProfile(String code) {
    return 'Country: $code';
  }

  @override
  String get world => 'World';

  @override
  String get country => 'Country';

  @override
  String recordValue(int wins, int losses) {
    return '$wins W â€¢ $losses L';
  }

  @override
  String get onlineArena => 'Online Arena';

  @override
  String get onlineArenaSubtitle =>
      'Quick matches, friend challenges and rankings in one place.';

  @override
  String get quickMatch => 'Quick Match';

  @override
  String get onlineBackendRequired =>
      'The online client foundation is ready. Ranked matchmaking stays safely disabled until Firebase Auth, Realtime Database and Cloud Functions are deployed.';

  @override
  String get challengeFriends => 'Challenge Friends';

  @override
  String get viewRankings => 'View Rankings';

  @override
  String tutorialProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get tutorialPlaceTitle => 'Place your pieces';

  @override
  String get tutorialPlaceBody =>
      'During placement, tap an empty point. Build plans while also blocking your opponent.';

  @override
  String get tutorialMillTitle => 'Build a mill';

  @override
  String get tutorialMillBody =>
      'Three of your pieces on one valid line form a mill. The highlighted line shows the pattern.';

  @override
  String get tutorialCaptureTitle => 'Capture a piece';

  @override
  String get tutorialCaptureBody =>
      'After forming a mill, choose a highlighted opponent piece. Pieces outside mills must be captured first when available.';

  @override
  String get tutorialMoveTitle => 'Move along the lines';

  @override
  String get tutorialMoveBody =>
      'After all pieces are placed, move one piece to an adjacent empty point. You can also long-press and drag.';

  @override
  String get tutorialBlockTitle => 'Block the opponent';

  @override
  String get tutorialBlockBody =>
      'Control intersections and close routes. A player with no legal move loses in standard 9 and 12 Stone.';

  @override
  String get tutorialFlyTitle => 'Fly with three pieces';

  @override
  String get tutorialFlyBody =>
      'When flying is enabled and you are down to three pieces, a piece can move to any empty point.';

  @override
  String get tutorialDoubleMillTitle => 'Create repeating threats';

  @override
  String get tutorialDoubleMillBody =>
      'Advanced play is about moving between connected mills, forcing captures while keeping mobility.';

  @override
  String get previous => 'Previous';

  @override
  String get finish => 'Finish';

  @override
  String get next => 'Next';

  @override
  String get gameExperience => 'Game experience';

  @override
  String get reduceMotion => 'Reduce motion';

  @override
  String get reduceMotionSubtitle =>
      'Turns off pulsing and nonessential movement.';

  @override
  String get showMoveHints => 'Show move hints';

  @override
  String get showMoveHintsSubtitle =>
      'Highlights legal destinations and capture targets.';

  @override
  String get colorAssist => 'Color assistance';

  @override
  String get colorAssistSubtitle =>
      'Adds shapes and borders so states are not communicated by color alone.';

  @override
  String get boardSurface => 'Board surface';

  @override
  String get surfaceWood => 'Wood';

  @override
  String get surfaceDarkStone => 'Dark stone';

  @override
  String get surfaceMarble => 'Marble';

  @override
  String get surfaceMinimal => 'Minimal';

  @override
  String get pieceTheme => 'Piece style';

  @override
  String get pieceClassic => 'Classic';

  @override
  String get pieceMarble => 'Marble';

  @override
  String get pieceObsidian => 'Obsidian';

  @override
  String get progression => 'Progress';

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String xpProgress(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String get addFriendTitle => 'Add friend';

  @override
  String get addFriendSubtitle => 'Add a player by name to your friends list.';

  @override
  String get friendNameLabel => 'Player name';

  @override
  String get friendNameHint => 'Enter a player name';

  @override
  String get addFriendButton => 'Add Friend';

  @override
  String get friendNameTooShort => 'Enter at least 2 characters.';

  @override
  String get friendAlreadyAdded =>
      'This player is already in your friends list.';

  @override
  String friendAdded(String name) {
    return '$name was added to your friends.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'I challenge you to $game in Morris World! Open or install the game here: $link';
  }

  @override
  String get resultVictoryPraise =>
      'Congratulations! Great game. Want a rematch?';

  @override
  String get resultDefeatPraise => 'Good fight! Ready for a rematch?';

  @override
  String get resultDrawPraise => 'Great game â€” it ended in a draw. One more?';

  @override
  String get resultLocalPraise => 'Great match! Want to play a rematch?';

  @override
  String get rematch => 'Play Rematch';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get playerName => 'Player name';

  @override
  String get countryCode => 'Country code';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get profileSaved => 'Profile saved.';

  @override
  String get profileSaveFailed => 'The profile could not be saved.';

  @override
  String get profileNameRequired => 'Player name cannot be empty.';

  @override
  String get profileCountryCodeHint => 'e.g. US';

  @override
  String get profileCountryCodeInvalid => 'Country code must be two letters.';

  @override
  String get profileLocalSaveNote =>
      'Your profile details are saved safely on this device.';
}
