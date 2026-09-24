// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Morris World';

  @override
  String get home => 'Accueil';

  @override
  String get selectGameTitle => 'Choisissez votre jeu';

  @override
  String get selectGameSubtitle =>
      'Trois jeux de stratégie classiques dans un univers social et sobre.';

  @override
  String get game3Name => 'Mérelle à trois';

  @override
  String get game3Description => 'Rapide, simple et tactique.';

  @override
  String get game9Name => 'Jeu du moulin';

  @override
  String get game9Description => 'Le grand classique.';

  @override
  String get game12Name => 'Mérelle à douze';

  @override
  String get game12Description =>
      'Un plateau plus dense, une stratégie plus profonde.';

  @override
  String selectModeTitle(String gameName) {
    return 'Comment voulez-vous jouer à $gameName ?';
  }

  @override
  String get online => 'En ligne';

  @override
  String get onlineSubtitle => 'Trouvez un adversaire réel dans le monde';

  @override
  String get challenge => 'Défier';

  @override
  String get challengeSubtitle => 'Invitez un ami dans le jeu ou par lien';

  @override
  String get offline => 'Hors ligne';

  @override
  String get offlineSubtitle =>
      'Jouez contre l\'IA ou à deux sur le même appareil';

  @override
  String get computerModeTitle => 'Jouer contre l’ordinateur';

  @override
  String get computerModeSubtitle =>
      'Aucune connexion requise • choisissez la difficulté';

  @override
  String get sameDeviceSubtitle =>
      'Jouez à deux à tour de rôle sur cet appareil';

  @override
  String get howToPlay => 'Comment jouer';

  @override
  String get friends => 'Amis';

  @override
  String get rankings => 'Classement';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Réglages';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Utiliser la langue de l\'appareil';

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
  String get restart => 'Recommencer';

  @override
  String get lightPlayer => 'Clair';

  @override
  String get darkPlayer => 'Foncé';

  @override
  String playerWon(String player) {
    return '$player a gagné';
  }

  @override
  String get draw => 'Match nul';

  @override
  String capturePrompt(String player) {
    return '$player : retirez une pièce adverse';
  }

  @override
  String placePrompt(String player) {
    return '$player : placez une pièce';
  }

  @override
  String movePrompt(String player) {
    return '$player : jouez votre coup';
  }

  @override
  String get quickGoodMove => 'Beau coup !';

  @override
  String get quickCongrats => 'Félicitations !';

  @override
  String get quickGoodGame => 'Belle partie !';

  @override
  String get quickMore => 'Plus';

  @override
  String get shareInvite => 'Défier via WhatsApp';

  @override
  String get challengeButton => 'Défier';

  @override
  String challengePrepared(String name) {
    return 'Le défi pour $name est prêt.';
  }

  @override
  String get presenceOnline => 'En ligne';

  @override
  String get presenceInMatch => 'En partie';

  @override
  String get presenceOffline => 'Hors ligne';

  @override
  String get offlineDifficultyTitle => 'Choisir la difficulté';

  @override
  String get beginner => 'Débutant';

  @override
  String get easy => 'Facile';

  @override
  String get medium => 'Moyen';

  @override
  String get hard => 'Difficile';

  @override
  String get master => 'Maître';

  @override
  String get sameDevice => 'Deux joueurs sur cet appareil';

  @override
  String featureComingSoon(String feature) {
    return '$feature est la prochaine étape de développement.';
  }

  @override
  String get errorMatchFinished => 'Cette partie est terminée.';

  @override
  String get errorCaptureRequired => 'Retirez d\'abord une pièce adverse.';

  @override
  String get errorPlacementFinished => 'La phase de placement est terminée.';

  @override
  String get errorPointOccupied => 'Ce point est occupé.';

  @override
  String get errorNotMovementPhase =>
      'Les pièces ne peuvent pas encore bouger.';

  @override
  String get errorNotYourPiece => 'Cette pièce ne vous appartient pas.';

  @override
  String get errorTargetOccupied => 'Le point cible est occupé.';

  @override
  String get errorNotAdjacent =>
      'Déplacez-vous le long d\'une ligne vers un point adjacent.';

  @override
  String get errorNoCaptureRight => 'Vous ne pouvez pas capturer maintenant.';

  @override
  String get errorOpponentPieceRequired => 'Choisissez une pièce adverse.';

  @override
  String get errorProtectedMillPiece =>
      'Choisissez d\'abord une pièce hors d\'un moulin.';

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
      'Votre position actuelle est enregistrée automatiquement. Que voulez-vous faire ?';

  @override
  String get matchLoadError => 'La partie enregistrée n’a pas pu être ouverte.';

  @override
  String get errorTitle => 'Un problème est survenu';

  @override
  String get routeError =>
      'Cet écran n’a pas pu être ouvert en toute sécurité.';

  @override
  String get backHome => 'Retour à l’accueil';

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
  String get viewRealistic => 'Réaliste';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'Invité';

  @override
  String get localProfile => 'Profil local';

  @override
  String get genericLoadError => 'Le contenu n’a pas pu être chargé.';

  @override
  String get retry => 'Réessayer';

  @override
  String get restartMatchTitle => 'Recommencer la partie ?';

  @override
  String get restartMatchBody =>
      'La position enregistrée actuelle sera remplacée par une nouvelle partie.';

  @override
  String get cancel => 'Annuler';

  @override
  String get aiFoundationNotice =>
      'Les niveaux élevés calculent davantage de coups et font moins d’erreurs tactiques.';

  @override
  String get saveFailedStayInMatch =>
      'La partie n’a pas pu être enregistrée en toute sécurité. Restez dans la partie et réessayez.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Clairs : $light  •  Foncés : $dark';
  }

  @override
  String get aiThinking => 'L’ordinateur réfléchit…';

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
    return 'Point $number, pion foncé';
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
  String get inviteLinkReady => 'Le lien d’invitation est prêt.';

  @override
  String get ratings => 'Classements';

  @override
  String get statistics => 'Statistiques';

  @override
  String get wins => 'Victoires';

  @override
  String get losses => 'Défaites';

  @override
  String get bestStreak => 'Meilleure série';

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
    return '$wins V • $losses D';
  }

  @override
  String get onlineArena => 'Arène en ligne';

  @override
  String get onlineArenaSubtitle =>
      'Parties rapides, défis entre amis et classements au même endroit.';

  @override
  String get quickMatch => 'Partie rapide';

  @override
  String get onlineBackendRequired =>
      'La base du client en ligne est prête. Le matchmaking classé reste désactivé jusqu’au déploiement de Firebase Auth, Realtime Database et Cloud Functions.';

  @override
  String get challengeFriends => 'Défier des amis';

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
      'Pendant le placement, touchez un point vide. Préparez vos alignements tout en bloquant l’adversaire.';

  @override
  String get tutorialMillTitle => 'Formez un moulin';

  @override
  String get tutorialMillBody =>
      'Trois pions sur une ligne valide forment un moulin.';

  @override
  String get tutorialCaptureTitle => 'Capturez un pion';

  @override
  String get tutorialCaptureBody =>
      'Après un moulin, choisissez un pion adverse surligné. Les pions hors moulin sont prioritaires.';

  @override
  String get tutorialMoveTitle => 'Déplacez-vous sur les lignes';

  @override
  String get tutorialMoveBody =>
      'Après le placement, déplacez un pion vers un point vide adjacent. Le glisser-déposer est aussi disponible.';

  @override
  String get tutorialBlockTitle => 'Bloquez l’adversaire';

  @override
  String get tutorialBlockBody =>
      'Contrôlez les intersections et fermez les routes. Sans coup légal, on perd en 9/12 pions.';

  @override
  String get tutorialFlyTitle => 'Volez avec trois pions';

  @override
  String get tutorialFlyBody =>
      'Avec la règle de vol, à trois pions vous pouvez aller sur n’importe quel point vide.';

  @override
  String get tutorialDoubleMillTitle => 'Créez des menaces répétées';

  @override
  String get tutorialDoubleMillBody =>
      'Le jeu avancé relie les moulins, force les captures et préserve la mobilité.';

  @override
  String get previous => 'Précédent';

  @override
  String get finish => 'Terminer';

  @override
  String get next => 'Suivant';

  @override
  String get gameExperience => 'Expérience de jeu';

  @override
  String get reduceMotion => 'Réduire les animations';

  @override
  String get reduceMotionSubtitle =>
      'Désactive les pulsations et mouvements non essentiels.';

  @override
  String get showMoveHints => 'Afficher les aides';

  @override
  String get showMoveHintsSubtitle =>
      'Surligne les destinations légales et les captures possibles.';

  @override
  String get colorAssist => 'Aide couleur';

  @override
  String get colorAssistSubtitle =>
      'Ajoute formes et contours pour ne pas dépendre uniquement de la couleur.';

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
  String get friendNameTooShort => 'Saisissez au moins 2 caractères.';

  @override
  String get friendAlreadyAdded => 'Ce joueur est déjà dans vos amis.';

  @override
  String friendAdded(String name) {
    return '$name a été ajouté à vos amis.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Je te défie à $game dans Morris World ! Ouvre ou installe le jeu ici : $link';
  }

  @override
  String get resultVictoryPraise => 'Bravo ! Très belle partie. Une revanche ?';

  @override
  String get resultDefeatPraise => 'Bien joué ! Prêt pour la revanche ?';

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
  String get profileSaved => 'Profil enregistré.';

  @override
  String get profileSaveFailed => 'Le profil n’a pas pu être enregistré.';

  @override
  String get profileNameRequired => 'Le nom du joueur ne peut pas être vide.';

  @override
  String get profileCountryCodeHint => 'ex. FR';

  @override
  String get profileCountryCodeInvalid =>
      'Le code pays doit comporter deux lettres.';

  @override
  String get profileLocalSaveNote =>
      'Les informations de ton profil sont enregistrées en toute sécurité sur cet appareil.';
}
