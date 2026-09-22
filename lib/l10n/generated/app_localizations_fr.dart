// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => '3-9-12 Taş';

  @override
  String get home => 'Accueil';

  @override
  String get selectGameTitle => 'Choisissez votre jeu';

  @override
  String get selectGameSubtitle =>
      'Trois jeux de stratÃ©gie classiques dans un univers social et sobre.';

  @override
  String get game3Name => 'MÃ©relle Ã  trois';

  @override
  String get game3Description => 'Rapide, simple et tactique.';

  @override
  String get game9Name => 'Jeu du moulin';

  @override
  String get game9Description => 'Le grand classique.';

  @override
  String get game12Name => 'MÃ©relle Ã  douze';

  @override
  String get game12Description =>
      'Un plateau plus dense, une stratÃ©gie plus profonde.';

  @override
  String selectModeTitle(String gameName) {
    return 'Comment voulez-vous jouer Ã  $gameName ?';
  }

  @override
  String get online => 'En ligne';

  @override
  String get onlineSubtitle => 'Trouvez un adversaire rÃ©el dans le monde';

  @override
  String get challenge => 'DÃ©fier';

  @override
  String get challengeSubtitle => 'Invitez un ami dans le jeu ou par lien';

  @override
  String get offline => 'Hors ligne';

  @override
  String get offlineSubtitle =>
      'Jouez contre l\'IA ou Ã  deux sur le mÃªme appareil';

  @override
  String get computerModeTitle => 'Jouer contre lâ€™ordinateur';

  @override
  String get computerModeSubtitle =>
      'Aucune connexion requise â€¢ choisissez la difficultÃ©';

  @override
  String get sameDeviceSubtitle =>
      'Jouez Ã  deux Ã  tour de rÃ´le sur cet appareil';

  @override
  String get howToPlay => 'Comment jouer';

  @override
  String get friends => 'Amis';

  @override
  String get rankings => 'Classement';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'RÃ©glages';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Utiliser la langue de l\'appareil';

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
  String get restart => 'Recommencer';

  @override
  String get lightPlayer => 'Clair';

  @override
  String get darkPlayer => 'FoncÃ©';

  @override
  String playerWon(String player) {
    return '$player a gagnÃ©';
  }

  @override
  String get draw => 'Match nul';

  @override
  String capturePrompt(String player) {
    return '$player : retirez une piÃ¨ce adverse';
  }

  @override
  String placePrompt(String player) {
    return '$player : placez une piÃ¨ce';
  }

  @override
  String movePrompt(String player) {
    return '$player : jouez votre coup';
  }

  @override
  String get quickGoodMove => 'Beau coup !';

  @override
  String get quickCongrats => 'FÃ©licitations !';

  @override
  String get quickGoodGame => 'Belle partie !';

  @override
  String get quickMore => 'Plus';

  @override
  String get shareInvite => 'DÃ©fier via WhatsApp';

  @override
  String get challengeButton => 'DÃ©fier';

  @override
  String challengePrepared(String name) {
    return 'Le dÃ©fi pour $name est prÃªt.';
  }

  @override
  String get presenceOnline => 'En ligne';

  @override
  String get presenceInMatch => 'En partie';

  @override
  String get presenceOffline => 'Hors ligne';

  @override
  String get offlineDifficultyTitle => 'Choisir la difficultÃ©';

  @override
  String get beginner => 'DÃ©butant';

  @override
  String get easy => 'Facile';

  @override
  String get medium => 'Moyen';

  @override
  String get hard => 'Difficile';

  @override
  String get master => 'MaÃ®tre';

  @override
  String get sameDevice => 'Deux joueurs sur cet appareil';

  @override
  String featureComingSoon(String feature) {
    return '$feature est la prochaine Ã©tape de dÃ©veloppement.';
  }

  @override
  String get errorMatchFinished => 'Cette partie est terminÃ©e.';

  @override
  String get errorCaptureRequired => 'Retirez d\'abord une piÃ¨ce adverse.';

  @override
  String get errorPlacementFinished => 'La phase de placement est terminÃ©e.';

  @override
  String get errorPointOccupied => 'Ce point est occupÃ©.';

  @override
  String get errorNotMovementPhase =>
      'Les piÃ¨ces ne peuvent pas encore bouger.';

  @override
  String get errorNotYourPiece => 'Cette piÃ¨ce ne vous appartient pas.';

  @override
  String get errorTargetOccupied => 'Le point cible est occupÃ©.';

  @override
  String get errorNotAdjacent =>
      'DÃ©placez-vous le long d\'une ligne vers un point adjacent.';

  @override
  String get errorNoCaptureRight => 'Vous ne pouvez pas capturer maintenant.';

  @override
  String get errorOpponentPieceRequired => 'Choisissez une piÃ¨ce adverse.';

  @override
  String get errorProtectedMillPiece =>
      'Choisissez d\'abord une piÃ¨ce hors d\'un moulin.';

  @override
  String get errorInvalidPoint => 'Point de plateau invalide.';

  @override
  String get errorBoardMismatch =>
      'Cette partie utilise un plateau incompatible.';

  @override
  String get continueMatch => 'Continuer la partie';

  @override
  String continueMatchSubtitle(String gameName) {
    return 'Reprenez votre partie de $gameName';
  }

  @override
  String get resume => 'Revenir au jeu';

  @override
  String get saveAndExit => 'Enregistrer et quitter';

  @override
  String get abandonMatch => 'Abandonner la partie';

  @override
  String get matchInProgressTitle => 'Partie en cours';

  @override
  String get matchInProgressBody =>
      'Votre position actuelle est enregistrÃ©e automatiquement. Que voulez-vous faire ?';

  @override
  String get matchLoadError =>
      'La partie enregistrÃ©e nâ€™a pas pu Ãªtre ouverte.';

  @override
  String get errorTitle => 'Un problÃ¨me est survenu';

  @override
  String get routeError =>
      'Cet Ã©cran nâ€™a pas pu Ãªtre ouvert en toute sÃ©curitÃ©.';

  @override
  String get backHome => 'Retour Ã  lâ€™accueil';

  @override
  String get noFriendsYet => 'Aucun ami pour le moment.';

  @override
  String get sound => 'Son';

  @override
  String get haptic => 'Retour haptique';

  @override
  String get boardView => 'Vue du plateau';

  @override
  String get viewFlat => '2D';

  @override
  String get viewRealistic => 'RÃ©aliste';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'InvitÃ©';

  @override
  String get localProfile => 'Profil local';

  @override
  String get genericLoadError => 'Le contenu nâ€™a pas pu Ãªtre chargÃ©.';

  @override
  String get retry => 'RÃ©essayer';

  @override
  String get restartMatchTitle => 'Recommencer la partie ?';

  @override
  String get restartMatchBody =>
      'La position enregistrÃ©e actuelle sera remplacÃ©e par une nouvelle partie.';

  @override
  String get cancel => 'Annuler';

  @override
  String get aiFoundationNotice =>
      'Les niveaux Ã©levÃ©s calculent davantage de coups et font moins dâ€™erreurs tactiques.';

  @override
  String get saveFailedStayInMatch =>
      'La partie nâ€™a pas pu Ãªtre enregistrÃ©e en toute sÃ©curitÃ©. Restez dans la partie et rÃ©essayez.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Clairs : $light  â€¢  FoncÃ©s : $dark';
  }

  @override
  String get aiThinking => 'Lâ€™ordinateur rÃ©flÃ©chitâ€¦';

  @override
  String get computerPlayer => 'Ordinateur';

  @override
  String get you => 'Vous';

  @override
  String moveCountLabel(int count) {
    return 'Coup $count';
  }

  @override
  String boardPointLight(int number) {
    return 'Point $number, pion clair';
  }

  @override
  String boardPointDark(int number) {
    return 'Point $number, pion foncÃ©';
  }

  @override
  String boardPointEmpty(int number) {
    return 'Point $number, vide';
  }

  @override
  String ratingValue(int rating) {
    return 'Classement $rating';
  }

  @override
  String get inviteLinkReady => 'Le lien dâ€™invitation est prÃªt.';

  @override
  String get ratings => 'Classements';

  @override
  String get statistics => 'Statistiques';

  @override
  String get wins => 'Victoires';

  @override
  String get losses => 'DÃ©faites';

  @override
  String get bestStreak => 'Meilleure sÃ©rie';

  @override
  String get winRate => 'Taux de victoire';

  @override
  String countryProfile(String code) {
    return 'Pays : $code';
  }

  @override
  String get world => 'Monde';

  @override
  String get country => 'Pays';

  @override
  String recordValue(int wins, int losses) {
    return '$wins V â€¢ $losses D';
  }

  @override
  String get onlineArena => 'ArÃ¨ne en ligne';

  @override
  String get onlineArenaSubtitle =>
      'Parties rapides, dÃ©fis entre amis et classements au mÃªme endroit.';

  @override
  String get quickMatch => 'Partie rapide';

  @override
  String get onlineBackendRequired =>
      'La base du client en ligne est prÃªte. Le matchmaking classÃ© reste dÃ©sactivÃ© jusquâ€™au dÃ©ploiement de Firebase Auth, Realtime Database et Cloud Functions.';

  @override
  String get challengeFriends => 'DÃ©fier des amis';

  @override
  String get viewRankings => 'Voir le classement';

  @override
  String tutorialProgress(int current, int total) {
    return 'Ã‰tape $current sur $total';
  }

  @override
  String get tutorialPlaceTitle => 'Placez vos pions';

  @override
  String get tutorialPlaceBody =>
      'Pendant le placement, touchez un point vide. PrÃ©parez vos alignements tout en bloquant lâ€™adversaire.';

  @override
  String get tutorialMillTitle => 'Formez un moulin';

  @override
  String get tutorialMillBody =>
      'Trois pions sur une ligne valide forment un moulin.';

  @override
  String get tutorialCaptureTitle => 'Capturez un pion';

  @override
  String get tutorialCaptureBody =>
      'AprÃ¨s un moulin, choisissez un pion adverse surlignÃ©. Les pions hors moulin sont prioritaires.';

  @override
  String get tutorialMoveTitle => 'DÃ©placez-vous sur les lignes';

  @override
  String get tutorialMoveBody =>
      'AprÃ¨s le placement, dÃ©placez un pion vers un point vide adjacent. Le glisser-dÃ©poser est aussi disponible.';

  @override
  String get tutorialBlockTitle => 'Bloquez lâ€™adversaire';

  @override
  String get tutorialBlockBody =>
      'ContrÃ´lez les intersections et fermez les routes. Sans coup lÃ©gal, on perd en 9/12 pions.';

  @override
  String get tutorialFlyTitle => 'Volez avec trois pions';

  @override
  String get tutorialFlyBody =>
      'Avec la rÃ¨gle de vol, Ã  trois pions vous pouvez aller sur nâ€™importe quel point vide.';

  @override
  String get tutorialDoubleMillTitle => 'CrÃ©ez des menaces rÃ©pÃ©tÃ©es';

  @override
  String get tutorialDoubleMillBody =>
      'Le jeu avancÃ© relie les moulins, force les captures et prÃ©serve la mobilitÃ©.';

  @override
  String get previous => 'PrÃ©cÃ©dent';

  @override
  String get finish => 'Terminer';

  @override
  String get next => 'Suivant';

  @override
  String get gameExperience => 'ExpÃ©rience de jeu';

  @override
  String get reduceMotion => 'RÃ©duire les animations';

  @override
  String get reduceMotionSubtitle =>
      'DÃ©sactive les pulsations et mouvements non essentiels.';

  @override
  String get showMoveHints => 'Afficher les aides';

  @override
  String get showMoveHintsSubtitle =>
      'Surligne les destinations lÃ©gales et les captures possibles.';

  @override
  String get colorAssist => 'Aide couleur';

  @override
  String get colorAssistSubtitle =>
      'Ajoute formes et contours pour ne pas dÃ©pendre uniquement de la couleur.';

  @override
  String get boardSurface => 'Surface du plateau';

  @override
  String get surfaceWood => 'Bois';

  @override
  String get surfaceDarkStone => 'Pierre sombre';

  @override
  String get surfaceMarble => 'Marbre';

  @override
  String get surfaceMinimal => 'Minimal';

  @override
  String get pieceTheme => 'Style des pions';

  @override
  String get pieceClassic => 'Classique';

  @override
  String get pieceMarble => 'Marbre';

  @override
  String get pieceObsidian => 'Obsidienne';

  @override
  String get progression => 'Progression';

  @override
  String levelLabel(int level) {
    return 'Niveau $level';
  }

  @override
  String xpProgress(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String get addFriendTitle => 'Ajouter un ami';

  @override
  String get addFriendSubtitle => 'Ajoutez un joueur par son nom.';

  @override
  String get friendNameLabel => 'Nom du joueur';

  @override
  String get friendNameHint => 'Saisissez un nom';

  @override
  String get addFriendButton => 'Ajouter un ami';

  @override
  String get friendNameTooShort => 'Saisissez au moins 2 caractÃ¨res.';

  @override
  String get friendAlreadyAdded => 'Ce joueur est dÃ©jÃ  dans vos amis.';

  @override
  String friendAdded(String name) {
    return '$name a Ã©tÃ© ajoutÃ© Ã  vos amis.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Je te dÃ©fie Ã  $game dans Morris World ! Ouvre ou installe le jeu ici : $link';
  }

  @override
  String get resultVictoryPraise =>
      'Bravo ! TrÃ¨s belle partie. Une revanche ?';

  @override
  String get resultDefeatPraise => 'Bien jouÃ© ! PrÃªt pour la revanche ?';

  @override
  String get resultDrawPraise => 'Belle partie, match nul. Encore une ?';

  @override
  String get resultLocalPraise => 'Belle partie ! Une revanche ?';

  @override
  String get rematch => 'Jouer la revanche';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get playerName => 'Nom du joueur';

  @override
  String get countryCode => 'Code pays';

  @override
  String get saveProfile => 'Enregistrer le profil';

  @override
  String get profileSaved => 'Profil enregistrÃ©.';

  @override
  String get profileSaveFailed => 'Le profil nâ€™a pas pu Ãªtre enregistrÃ©.';

  @override
  String get profileNameRequired => 'Le nom du joueur ne peut pas Ãªtre vide.';

  @override
  String get profileCountryCodeHint => 'ex. FR';

  @override
  String get profileCountryCodeInvalid =>
      'Le code pays doit comporter deux lettres.';

  @override
  String get profileLocalSaveNote =>
      'Les informations de ton profil sont enregistrÃ©es en toute sÃ©curitÃ© sur cet appareil.';
}
