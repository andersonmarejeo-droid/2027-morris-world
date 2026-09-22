// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => '3-9-12 Taş';

  @override
  String get home => 'Startseite';

  @override
  String get selectGameTitle => 'Spiel auswÃ¤hlen';

  @override
  String get selectGameSubtitle =>
      'Drei klassische Strategiespiele in einer ruhigen sozialen Welt.';

  @override
  String get game3Name => 'Drei-MÃ¼hle';

  @override
  String get game3Description => 'Schnell, einfach und taktisch.';

  @override
  String get game9Name => 'MÃ¼hle';

  @override
  String get game9Description => 'Das klassische Hauptspiel.';

  @override
  String get game12Name => 'ZwÃ¶lf-MÃ¼hle';

  @override
  String get game12Description => 'Dichteres Brett, tiefere Strategie.';

  @override
  String selectModeTitle(String gameName) {
    return 'Wie mÃ¶chtest du $gameName spielen?';
  }

  @override
  String get online => 'Online';

  @override
  String get onlineSubtitle => 'Finde weltweit einen echten Gegner';

  @override
  String get challenge => 'Herausfordern';

  @override
  String get challengeSubtitle => 'Freund im Spiel oder per Link einladen';

  @override
  String get offline => 'Offline';

  @override
  String get offlineSubtitle => 'Gegen KI oder zu zweit auf einem GerÃ¤t';

  @override
  String get computerModeTitle => 'Gegen Computer spielen';

  @override
  String get computerModeSubtitle =>
      'Kein Internet nÃ¶tig â€¢ Schwierigkeit wÃ¤hlen';

  @override
  String get sameDeviceSubtitle =>
      'Zu zweit abwechselnd auf diesem GerÃ¤t spielen';

  @override
  String get howToPlay => 'Spielregeln';

  @override
  String get friends => 'Freunde';

  @override
  String get rankings => 'Rangliste';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'GerÃ¤tesprache verwenden';

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
  String get restart => 'Neu starten';

  @override
  String get lightPlayer => 'Hell';

  @override
  String get darkPlayer => 'Dunkel';

  @override
  String playerWon(String player) {
    return '$player hat gewonnen';
  }

  @override
  String get draw => 'Unentschieden';

  @override
  String capturePrompt(String player) {
    return '$player: gegnerischen Stein entfernen';
  }

  @override
  String placePrompt(String player) {
    return '$player: Stein setzen';
  }

  @override
  String movePrompt(String player) {
    return '$player: ziehen';
  }

  @override
  String get quickGoodMove => 'Guter Zug!';

  @override
  String get quickCongrats => 'GlÃ¼ckwunsch!';

  @override
  String get quickGoodGame => 'Gutes Spiel!';

  @override
  String get quickMore => 'Mehr';

  @override
  String get shareInvite => 'Ãœber WhatsApp herausfordern';

  @override
  String get challengeButton => 'Herausfordern';

  @override
  String challengePrepared(String name) {
    return 'Herausforderung fÃ¼r $name ist bereit.';
  }

  @override
  String get presenceOnline => 'Online';

  @override
  String get presenceInMatch => 'Im Spiel';

  @override
  String get presenceOffline => 'Offline';

  @override
  String get offlineDifficultyTitle => 'Schwierigkeit wÃ¤hlen';

  @override
  String get beginner => 'AnfÃ¤nger';

  @override
  String get easy => 'Leicht';

  @override
  String get medium => 'Mittel';

  @override
  String get hard => 'Schwer';

  @override
  String get master => 'Meister';

  @override
  String get sameDevice => 'Zwei Spieler auf diesem GerÃ¤t';

  @override
  String featureComingSoon(String feature) {
    return '$feature ist der nÃ¤chste Entwicklungsschritt.';
  }

  @override
  String get errorMatchFinished => 'Dieses Spiel ist beendet.';

  @override
  String get errorCaptureRequired =>
      'Entferne zuerst einen gegnerischen Stein.';

  @override
  String get errorPlacementFinished => 'Die Setzphase ist beendet.';

  @override
  String get errorPointOccupied => 'Dieser Punkt ist belegt.';

  @override
  String get errorNotMovementPhase =>
      'Steine kÃ¶nnen noch nicht bewegt werden.';

  @override
  String get errorNotYourPiece => 'Dieser Stein gehÃ¶rt dir nicht.';

  @override
  String get errorTargetOccupied => 'Der Zielpunkt ist belegt.';

  @override
  String get errorNotAdjacent =>
      'Ziehe entlang einer Linie zu einem benachbarten Punkt.';

  @override
  String get errorNoCaptureRight => 'Du darfst jetzt keinen Stein entfernen.';

  @override
  String get errorOpponentPieceRequired => 'WÃ¤hle einen gegnerischen Stein.';

  @override
  String get errorProtectedMillPiece =>
      'WÃ¤hle zuerst einen Stein auÃŸerhalb einer MÃ¼hle.';

  @override
  String get errorInvalidPoint => 'UngÃ¼ltiger Brettpunkt.';

  @override
  String get errorBoardMismatch =>
      'Dieses Spiel verwendet ein inkompatibles Brett.';

  @override
  String get continueMatch => 'Spiel fortsetzen';

  @override
  String continueMatchSubtitle(String gameName) {
    return 'Setze dein $gameName-Spiel fort';
  }

  @override
  String get resume => 'Zum Spiel zurÃ¼ck';

  @override
  String get saveAndExit => 'Speichern und beenden';

  @override
  String get abandonMatch => 'Spiel aufgeben';

  @override
  String get matchInProgressTitle => 'Spiel lÃ¤uft';

  @override
  String get matchInProgressBody =>
      'Deine aktuelle Position wird automatisch gespeichert. Was mÃ¶chtest du tun?';

  @override
  String get matchLoadError =>
      'Das gespeicherte Spiel konnte nicht geÃ¶ffnet werden.';

  @override
  String get errorTitle => 'Etwas ist schiefgelaufen';

  @override
  String get routeError => 'Diese Seite konnte nicht sicher geÃ¶ffnet werden.';

  @override
  String get backHome => 'Zur Startseite';

  @override
  String get noFriendsYet => 'Noch keine Freunde.';

  @override
  String get sound => 'Ton';

  @override
  String get haptic => 'Haptisches Feedback';

  @override
  String get boardView => 'Brettansicht';

  @override
  String get viewFlat => '2D';

  @override
  String get viewRealistic => 'Realistisch';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'Gast';

  @override
  String get localProfile => 'Lokales Profil';

  @override
  String get genericLoadError => 'Der Inhalt konnte nicht geladen werden.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get restartMatchTitle => 'Spiel neu starten?';

  @override
  String get restartMatchBody =>
      'Der aktuell gespeicherte Stand wird durch ein neues Spiel ersetzt.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get aiFoundationNotice =>
      'HÃ¶here Stufen berechnen mehr ZÃ¼ge voraus und machen weniger taktische Fehler.';

  @override
  String get saveFailedStayInMatch =>
      'Das Spiel konnte nicht sicher gespeichert werden. Bleibe im Spiel und versuche es erneut.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Hell: $light  â€¢  Dunkel: $dark';
  }

  @override
  String get aiThinking => 'Computer denkt nachâ€¦';

  @override
  String get computerPlayer => 'Computer';

  @override
  String get you => 'Du';

  @override
  String moveCountLabel(int count) {
    return 'Zug $count';
  }

  @override
  String boardPointLight(int number) {
    return 'Punkt $number, heller Stein';
  }

  @override
  String boardPointDark(int number) {
    return 'Punkt $number, dunkler Stein';
  }

  @override
  String boardPointEmpty(int number) {
    return 'Punkt $number, leer';
  }

  @override
  String ratingValue(int rating) {
    return 'Wertung $rating';
  }

  @override
  String get inviteLinkReady => 'Einladungslink ist bereit.';

  @override
  String get ratings => 'Wertungen';

  @override
  String get statistics => 'Statistiken';

  @override
  String get wins => 'Siege';

  @override
  String get losses => 'Niederlagen';

  @override
  String get bestStreak => 'Beste Serie';

  @override
  String get winRate => 'Siegquote';

  @override
  String countryProfile(String code) {
    return 'Land: $code';
  }

  @override
  String get world => 'Welt';

  @override
  String get country => 'Land';

  @override
  String recordValue(int wins, int losses) {
    return '$wins S â€¢ $losses N';
  }

  @override
  String get onlineArena => 'Online-Arena';

  @override
  String get onlineArenaSubtitle =>
      'Schnelle Partien, Herausforderungen und Ranglisten an einem Ort.';

  @override
  String get quickMatch => 'Schnelles Spiel';

  @override
  String get onlineBackendRequired =>
      'Die Online-Clientbasis ist bereit. Ranglisten-Matchmaking bleibt deaktiviert, bis Firebase Auth, Realtime Database und Cloud Functions bereitgestellt sind.';

  @override
  String get challengeFriends => 'Freunde herausfordern';

  @override
  String get viewRankings => 'Rangliste ansehen';

  @override
  String tutorialProgress(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String get tutorialPlaceTitle => 'Steine setzen';

  @override
  String get tutorialPlaceBody =>
      'Tippe in der Setzphase auf einen freien Punkt. Plane eigene MÃ¼hlen und blockiere den Gegner.';

  @override
  String get tutorialMillTitle => 'MÃ¼hle bilden';

  @override
  String get tutorialMillBody =>
      'Drei eigene Steine auf einer gÃ¼ltigen Linie bilden eine MÃ¼hle.';

  @override
  String get tutorialCaptureTitle => 'Stein schlagen';

  @override
  String get tutorialCaptureBody =>
      'Nach einer MÃ¼hle wÃ¤hlst du einen markierten gegnerischen Stein. Steine auÃŸerhalb von MÃ¼hlen mÃ¼ssen zuerst geschlagen werden.';

  @override
  String get tutorialMoveTitle => 'Entlang der Linien ziehen';

  @override
  String get tutorialMoveBody =>
      'Nach dem Setzen ziehst du zu einem benachbarten freien Punkt. Langes DrÃ¼cken und Ziehen ist ebenfalls mÃ¶glich.';

  @override
  String get tutorialBlockTitle => 'Gegner blockieren';

  @override
  String get tutorialBlockBody =>
      'Kontrolliere Kreuzungen und sperre Wege. Ohne legalen Zug verliert man bei 9/12 Steinen.';

  @override
  String get tutorialFlyTitle => 'Mit drei Steinen fliegen';

  @override
  String get tutorialFlyBody =>
      'Bei aktivierter Flugregel darfst du mit drei Steinen auf jeden freien Punkt ziehen.';

  @override
  String get tutorialDoubleMillTitle => 'Wiederholte Drohungen';

  @override
  String get tutorialDoubleMillBody =>
      'Fortgeschrittenes Spiel verbindet MÃ¼hlen, erzwingt SchlÃ¤ge und erhÃ¤lt Beweglichkeit.';

  @override
  String get previous => 'ZurÃ¼ck';

  @override
  String get finish => 'Fertig';

  @override
  String get next => 'Weiter';

  @override
  String get gameExperience => 'Spielerlebnis';

  @override
  String get reduceMotion => 'Bewegung reduzieren';

  @override
  String get reduceMotionSubtitle =>
      'Deaktiviert Pulsieren und unnÃ¶tige Bewegung.';

  @override
  String get showMoveHints => 'Zughinweise anzeigen';

  @override
  String get showMoveHintsSubtitle =>
      'Markiert gÃ¼ltige Ziele und Schlagsteine.';

  @override
  String get colorAssist => 'FarbunterstÃ¼tzung';

  @override
  String get colorAssistSubtitle =>
      'ZusÃ¤tzliche Formen und RÃ¤nder vermitteln ZustÃ¤nde nicht nur durch Farbe.';

  @override
  String get boardSurface => 'BrettoberflÃ¤che';

  @override
  String get surfaceWood => 'Holz';

  @override
  String get surfaceDarkStone => 'Dunkler Stein';

  @override
  String get surfaceMarble => 'Marmor';

  @override
  String get surfaceMinimal => 'Minimal';

  @override
  String get pieceTheme => 'Steinstil';

  @override
  String get pieceClassic => 'Klassisch';

  @override
  String get pieceMarble => 'Marmor';

  @override
  String get pieceObsidian => 'Obsidian';

  @override
  String get progression => 'Fortschritt';

  @override
  String levelLabel(int level) {
    return 'Stufe $level';
  }

  @override
  String xpProgress(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String get addFriendTitle => 'Freund hinzufÃ¼gen';

  @override
  String get addFriendSubtitle =>
      'FÃ¼ge einen Spieler per Name zu deiner Freundesliste hinzu.';

  @override
  String get friendNameLabel => 'Spielername';

  @override
  String get friendNameHint => 'Spielername eingeben';

  @override
  String get addFriendButton => 'Freund hinzufÃ¼gen';

  @override
  String get friendNameTooShort => 'Gib mindestens 2 Zeichen ein.';

  @override
  String get friendAlreadyAdded =>
      'Dieser Spieler ist bereits in deiner Freundesliste.';

  @override
  String friendAdded(String name) {
    return '$name wurde zu deinen Freunden hinzugefÃ¼gt.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Ich fordere dich in Morris World zu $game heraus! Ã–ffne oder installiere das Spiel hier: $link';
  }

  @override
  String get resultVictoryPraise =>
      'GlÃ¼ckwunsch! Stark gespielt. Lust auf eine Revanche?';

  @override
  String get resultDefeatPraise => 'Gut gekÃ¤mpft! Bereit fÃ¼r eine Revanche?';

  @override
  String get resultDrawPraise =>
      'Tolles Spiel â€” unentschieden. Noch eine Runde?';

  @override
  String get resultLocalPraise => 'Tolles Spiel! Lust auf eine Revanche?';

  @override
  String get rematch => 'Revanche spielen';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get playerName => 'Spielername';

  @override
  String get countryCode => 'LÃ¤ndercode';

  @override
  String get saveProfile => 'Profil speichern';

  @override
  String get profileSaved => 'Profil gespeichert.';

  @override
  String get profileSaveFailed => 'Das Profil konnte nicht gespeichert werden.';

  @override
  String get profileNameRequired => 'Der Spielername darf nicht leer sein.';

  @override
  String get profileCountryCodeHint => 'z. B. DE';

  @override
  String get profileCountryCodeInvalid =>
      'Der LÃ¤ndercode muss aus zwei Buchstaben bestehen.';

  @override
  String get profileLocalSaveNote =>
      'Deine Profildaten werden sicher auf diesem GerÃ¤t gespeichert.';
}
