// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => '3-9-12 Morris';

  @override
  String get ageAudienceTitle => 'Wer spielt?';

  @override
  String get ageAudienceBody =>
      'Wähle eine Altersgruppe, damit wir das Erlebnis für alle passend gestalten können.';

  @override
  String get ageAudienceChild => 'Unter 18 oder keine Angabe';

  @override
  String get ageAudienceAdult => '18 oder älter';

  @override
  String get ageAudiencePrivacy =>
      'Wir fragen nicht nach dem Geburtsdatum. Diese Auswahl wird nur auf diesem Gerät gespeichert. Für Personen unter 18 und ohne Altersangabe sind Anzeigen nicht personalisiert und Online-Räume gesperrt. Anzeigen sind familienfreundlich und höchstens mit G bewertet.';

  @override
  String get ageAudienceOnlineRestricted =>
      'Online-Räume sind nur für Personen verfügbar, die angeben, mindestens 18 Jahre alt zu sein. Jüngere und Personen ohne Altersangabe können gegen den Computer oder auf demselben Gerät spielen.';

  @override
  String get ageAudienceGotIt => 'Verstanden';

  @override
  String get home => 'Startseite';

  @override
  String get selectGameTitle => 'Spiel auswählen';

  @override
  String get selectGameSubtitle =>
      'Drei klassische Strategiespiele in einer ruhigen sozialen Welt.';

  @override
  String get game3Name => 'Drei-Mühle';

  @override
  String get game3Description => 'Schnell, einfach und taktisch.';

  @override
  String get game9Name => 'Mühle';

  @override
  String get game9Description => 'Das klassische Hauptspiel.';

  @override
  String get game12Name => 'Zwölf-Mühle';

  @override
  String get game12Description => 'Dichteres Brett, tiefere Strategie.';

  @override
  String selectModeTitle(String gameName) {
    return 'Wie möchtest du $gameName spielen?';
  }

  @override
  String get online => 'Online';

  @override
  String get onlineSubtitle =>
      'Suche einen Online-Gegner; sonst spielst du gegen den Computer';

  @override
  String get createPrivateRoom => 'Privaten Raum erstellen';

  @override
  String get joinPrivateRoom => 'Mit Raumcode beitreten';

  @override
  String get roomCode => 'Raumcode';

  @override
  String get roomCodeHint => 'Gib den Code deines Freundes ein';

  @override
  String get waitingForOpponent =>
      'Das Spiel beginnt, sobald dein Freund beitritt.';

  @override
  String get copyRoomCode => 'Code kopieren';

  @override
  String get roomCodeCopied => 'Raumcode kopiert.';

  @override
  String get sparkPrivateRoomNotice =>
      'Kinder sollten Online-Spiele mit einem Elternteil oder Erziehungsberechtigten nutzen. Teile Raumcodes nur mit Personen, die du kennst. Es gibt keine Rangliste, öffentliche Suche oder Chat.';

  @override
  String get onlineOpponent => 'Gegner';

  @override
  String get onlineWaitingTurn => 'Warte auf den Zug deines Gegners.';

  @override
  String get onlineMoveFailed =>
      'Zug konnte nicht gesendet werden. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get onlineRoomUnavailable =>
      'Raum nicht gefunden oder bereits voll. Prüfe den Code.';

  @override
  String get closeOnlineRoom => 'Raum schließen';

  @override
  String get exitMatch => 'Partie verlassen';

  @override
  String get exitMatchConfirm =>
      'Die Partie läuft noch. Wenn du gehst, gewinnt dein Gegner. Partie verlassen?';

  @override
  String get opponentLeft =>
      'Dein Gegner hat die Partie verlassen; du gewinnst.';

  @override
  String get opponentTimedOut =>
      'Dein Gegner hat zwei Minuten lang keinen Zug gemacht; du gewinnst.';

  @override
  String get challenge => 'Herausfordern';

  @override
  String get challengeSubtitle => 'Freund im Spiel oder per Link einladen';

  @override
  String get offline => 'Offline';

  @override
  String get offlineSubtitle => 'Gegen KI oder zu zweit auf einem Gerät';

  @override
  String get computerModeTitle => 'Gegen Computer spielen';

  @override
  String get computerModeSubtitle =>
      'Kein Internet nötig • Schwierigkeit wählen';

  @override
  String get sameDeviceSubtitle =>
      'Zu zweit abwechselnd auf diesem Gerät spielen';

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
  String get systemLanguage => 'Gerätesprache verwenden';

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
  String get quickCongrats => 'Glückwunsch!';

  @override
  String get quickGoodGame => 'Gutes Spiel!';

  @override
  String get quickMore => 'Mehr';

  @override
  String get shareInvite => 'Über WhatsApp herausfordern';

  @override
  String get challengeButton => 'Herausfordern';

  @override
  String challengePrepared(String name) {
    return 'Herausforderung für $name ist bereit.';
  }

  @override
  String get presenceOnline => 'Online';

  @override
  String get presenceInMatch => 'Im Spiel';

  @override
  String get presenceOffline => 'Offline';

  @override
  String get offlineDifficultyTitle => 'Schwierigkeit wählen';

  @override
  String get beginner => 'Anfänger';

  @override
  String get easy => 'Leicht';

  @override
  String get medium => 'Mittel';

  @override
  String get hard => 'Schwer';

  @override
  String get master => 'Meister';

  @override
  String get sameDevice => 'Zwei Spieler auf diesem Gerät';

  @override
  String featureComingSoon(String feature) {
    return '$feature ist der nächste Entwicklungsschritt.';
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
  String get errorNotMovementPhase => 'Steine können noch nicht bewegt werden.';

  @override
  String get errorNotYourPiece => 'Dieser Stein gehört dir nicht.';

  @override
  String get errorTargetOccupied => 'Der Zielpunkt ist belegt.';

  @override
  String get errorNotAdjacent =>
      'Ziehe entlang einer Linie zu einem benachbarten Punkt.';

  @override
  String get errorNoCaptureRight => 'Du darfst jetzt keinen Stein entfernen.';

  @override
  String get errorOpponentPieceRequired => 'Wähle einen gegnerischen Stein.';

  @override
  String get errorProtectedMillPiece =>
      'Wähle zuerst einen Stein außerhalb einer Mühle.';

  @override
  String get errorInvalidPoint => 'Ungültiger Brettpunkt.';

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
  String get resume => 'Zum Spiel zurück';

  @override
  String get saveAndExit => 'Speichern und beenden';

  @override
  String get abandonMatch => 'Spiel aufgeben';

  @override
  String get matchInProgressTitle => 'Spiel läuft';

  @override
  String get matchInProgressBody =>
      'Deine aktuelle Position wird automatisch gespeichert. Was möchtest du tun?';

  @override
  String get matchLoadError =>
      'Das gespeicherte Spiel konnte nicht geöffnet werden.';

  @override
  String get errorTitle => 'Etwas ist schiefgelaufen';

  @override
  String get routeError => 'Diese Seite konnte nicht sicher geöffnet werden.';

  @override
  String get backHome => 'Zur Startseite';

  @override
  String get noFriendsYet => 'Noch keine Freunde.';

  @override
  String get rankingsUnavailable =>
      'Die Ranglisten für Welt, Land und Freunde sind noch nicht mit Live-Spielerdaten verbunden. Verifizierte Ranglisten erscheinen hier, sobald der Dienst verfügbar ist.';

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
      'Höhere Stufen berechnen mehr Züge voraus und machen weniger taktische Fehler.';

  @override
  String get saveFailedStayInMatch =>
      'Das Spiel konnte nicht sicher gespeichert werden. Bleibe im Spiel und versuche es erneut.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Hell: $light  •  Dunkel: $dark';
  }

  @override
  String get aiThinking => 'Computer denkt nach…';

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
    return '$wins S • $losses N';
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
      'Private Online-Räume sind derzeit nicht verfügbar. Prüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get challengeInviteOpenedWithoutRoom =>
      'Die WhatsApp-Einladung ist bereit. Ein Online-Raum konnte nicht erstellt werden, daher ist kein Raumcode enthalten.';

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
      'Tippe in der Setzphase auf einen freien Punkt. Plane eigene Mühlen und blockiere den Gegner.';

  @override
  String get tutorialMillTitle => 'Mühle bilden';

  @override
  String get tutorialMillBody =>
      'Drei eigene Steine auf einer gültigen Linie bilden eine Mühle.';

  @override
  String get tutorialCaptureTitle => 'Stein schlagen';

  @override
  String get tutorialCaptureBody =>
      'Nach einer Mühle wählst du einen markierten gegnerischen Stein. Steine außerhalb von Mühlen müssen zuerst geschlagen werden.';

  @override
  String get tutorialMoveTitle => 'Entlang der Linien ziehen';

  @override
  String get tutorialMoveBody =>
      'Nach dem Setzen ziehst du zu einem benachbarten freien Punkt. Langes Drücken und Ziehen ist ebenfalls möglich.';

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
      'Fortgeschrittenes Spiel verbindet Mühlen, erzwingt Schläge und erhält Beweglichkeit.';

  @override
  String get previous => 'Zurück';

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
      'Deaktiviert Pulsieren und unnötige Bewegung.';

  @override
  String get showMoveHints => 'Zughinweise anzeigen';

  @override
  String get showMoveHintsSubtitle =>
      'Markiert gültige Ziele und Schlagsteine.';

  @override
  String get colorAssist => 'Farbunterstützung';

  @override
  String get colorAssistSubtitle =>
      'Zusätzliche Formen und Ränder vermitteln Zustände nicht nur durch Farbe.';

  @override
  String get boardSurface => 'Brettoberfläche';

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
  String get addFriendTitle => 'Freund hinzufügen';

  @override
  String get addFriendSubtitle =>
      'Füge einen Spieler per Name zu deiner Freundesliste hinzu.';

  @override
  String get friendNameLabel => 'Spielername';

  @override
  String get friendNameHint => 'Spielername eingeben';

  @override
  String get addFriendButton => 'Freund hinzufügen';

  @override
  String get friendNameTooShort => 'Gib mindestens 2 Zeichen ein.';

  @override
  String get friendAlreadyAdded =>
      'Dieser Spieler ist bereits in deiner Freundesliste.';

  @override
  String friendAdded(String name) {
    return '$name wurde zu deinen Freunden hinzugefügt.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Lass uns gemeinsam $game in 3-9-12 Morris spielen! Hol dir die App hier: $link';
  }

  @override
  String get resultVictoryPraise =>
      'Glückwunsch! Stark gespielt. Lust auf eine Revanche?';

  @override
  String get resultDefeatPraise => 'Gut gekämpft! Bereit für eine Revanche?';

  @override
  String get resultDrawPraise =>
      'Tolles Spiel — unentschieden. Noch eine Runde?';

  @override
  String get resultLocalPraise => 'Tolles Spiel! Lust auf eine Revanche?';

  @override
  String get rematch => 'Revanche spielen';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get playerName => 'Spielername';

  @override
  String get countryCode => 'Ländercode';

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
      'Der Ländercode muss aus zwei Buchstaben bestehen.';

  @override
  String get profileLocalSaveNote =>
      'Deine Profildaten werden sicher auf diesem Gerät gespeichert.';

  @override
  String get accountAndLegal => 'Konto und Rechtliches';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get termsSummary =>
      '3-9-12 Tas bietet die klassischen Spiele 3, 9 und 12 Steine. Verwende die App im Einklang mit dem geltenden Recht. Profil und Spielstände werden auf diesem Gerät gespeichert; In-App-Käufe gibt es nicht.\n\nWenn Online-Räume aktiviert sind, können Drittanbieter wie Firebase verwendet werden. Teile Raumcodes nur mit Personen, die du kennst. Für externe Teilen-Apps gelten deren eigene Bedingungen.\n\nDies sind allgemeine Produktinformationen und kein verbindlicher Vertrag. Die offizielle Anschrift des Anbieters und länderspezifische Rechtsbedingungen wurden noch nicht bestätigt.';

  @override
  String get legalInformation => 'Rechtliche Hinweise';

  @override
  String get legalInformationBody =>
      'Anbieter: Mustafa Polat · ZP GAMES\nKontakt: andersonmarejeo@gmail.com\n\nDie offizielle Zustellanschrift und der eingetragene Firmenname wurden noch nicht bestätigt. Rechtliche Mitteilungen bitte an die Kontaktadresse senden.';

  @override
  String get onlineSignOut => 'Von der Online-Sitzung abmelden';

  @override
  String get onlineSignOutDone =>
      'Du bist abgemeldet. Gespeicherte Spiele auf diesem Gerät bleiben erhalten.';

  @override
  String get onlineSessionMissing =>
      'Auf diesem Gerät ist keine Online-Sitzung aktiv.';

  @override
  String get deleteLocalData => 'Nutzerdaten auf diesem Gerät löschen';

  @override
  String get deleteLocalDataTitle => 'Nutzerdaten auf diesem Gerät löschen?';

  @override
  String get deleteLocalDataBody =>
      'Dadurch werden dein Profil, hinzugefügte Freunde und gespeicherte Spiele dauerhaft von diesem Gerät gelöscht. Firebase-Online-Räume oder ein Remote-Konto werden nicht gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get deleteLocalDataDone =>
      'Profil, Freundesliste und gespeicherte Spiele auf diesem Gerät wurden gelöscht.';

  @override
  String get deleteAction => 'Daten löschen';

  @override
  String get gameOptions => 'Spieloptionen';

  @override
  String get drawRuleNotice =>
      'Die Partie endet remis, wenn dieselbe Brettstellung einschließlich des Zugrechts fünfmal vorkommt oder 100 Züge in Folge kein Stein geschlagen wurde.';

  @override
  String get offerDraw => 'Remis anbieten';

  @override
  String get drawOfferPrompt =>
      'Möchtest du Remis anbieten? Die Partie endet nur remis, wenn der Gegner zustimmt.';

  @override
  String get drawOfferReceived => 'Remisangebot';

  @override
  String get drawOfferReceivedBody =>
      'Dein Gegner bietet Remis an. Nimmst du an?';

  @override
  String get acceptDraw => 'Remis annehmen';

  @override
  String get declineDraw => 'Ablehnen';

  @override
  String get drawOfferDeclined => 'Das Remisangebot wurde abgelehnt.';

  @override
  String get computerDrawOfferAccepted =>
      'Der Computer hat das Remisangebot angenommen.';

  @override
  String get computerDrawOfferDeclined =>
      'Der Computer hat das Remisangebot abgelehnt.';

  @override
  String get resignMatch => 'Aufgeben';

  @override
  String get resignConfirm =>
      'Möchtest du wirklich aufgeben? Dein Gegner gewinnt.';
}
