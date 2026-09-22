// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => '3-9-12 Taş';

  @override
  String get home => 'Inicio';

  @override
  String get selectGameTitle => 'Elige tu juego';

  @override
  String get selectGameSubtitle =>
      'Tres juegos clÃ¡sicos de estrategia en un solo espacio social y tranquilo.';

  @override
  String get game3Name => 'Molino de tres';

  @override
  String get game3Description => 'RÃ¡pido, sencillo y tÃ¡ctico.';

  @override
  String get game9Name => 'Molino de nueve';

  @override
  String get game9Description => 'El juego clÃ¡sico principal.';

  @override
  String get game12Name => 'Molino de doce';

  @override
  String get game12Description =>
      'Un tablero mÃ¡s denso y una estrategia mÃ¡s profunda.';

  @override
  String selectModeTitle(String gameName) {
    return 'Â¿CÃ³mo quieres jugar a $gameName?';
  }

  @override
  String get online => 'En lÃ­nea';

  @override
  String get onlineSubtitle => 'Encuentra un rival real en todo el mundo';

  @override
  String get challenge => 'Desafiar';

  @override
  String get challengeSubtitle =>
      'Invita a un amigo dentro del juego o con un enlace';

  @override
  String get offline => 'Sin conexiÃ³n';

  @override
  String get offlineSubtitle =>
      'Juega contra la IA o dos jugadores en un dispositivo';

  @override
  String get computerModeTitle => 'Jugar contra la computadora';

  @override
  String get computerModeSubtitle =>
      'No requiere internet â€¢ elige dificultad';

  @override
  String get sameDeviceSubtitle =>
      'Dos jugadores por turnos en este dispositivo';

  @override
  String get howToPlay => 'CÃ³mo jugar';

  @override
  String get friends => 'Amigos';

  @override
  String get rankings => 'ClasificaciÃ³n';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Usar idioma del dispositivo';

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
  String get restart => 'Reiniciar';

  @override
  String get lightPlayer => 'Claro';

  @override
  String get darkPlayer => 'Oscuro';

  @override
  String playerWon(String player) {
    return '$player ganÃ³';
  }

  @override
  String get draw => 'Empate';

  @override
  String capturePrompt(String player) {
    return '$player: retira una pieza rival';
  }

  @override
  String placePrompt(String player) {
    return '$player: coloca una pieza';
  }

  @override
  String movePrompt(String player) {
    return '$player: haz tu movimiento';
  }

  @override
  String get quickGoodMove => 'Â¡Buen movimiento!';

  @override
  String get quickCongrats => 'Â¡Felicidades!';

  @override
  String get quickGoodGame => 'Â¡Buena partida!';

  @override
  String get quickMore => 'MÃ¡s';

  @override
  String get shareInvite => 'Desafiar por WhatsApp';

  @override
  String get challengeButton => 'Desafiar';

  @override
  String challengePrepared(String name) {
    return 'El desafÃ­o para $name estÃ¡ listo.';
  }

  @override
  String get presenceOnline => 'En lÃ­nea';

  @override
  String get presenceInMatch => 'En partida';

  @override
  String get presenceOffline => 'Sin conexiÃ³n';

  @override
  String get offlineDifficultyTitle => 'Elige dificultad';

  @override
  String get beginner => 'Principiante';

  @override
  String get easy => 'FÃ¡cil';

  @override
  String get medium => 'Media';

  @override
  String get hard => 'DifÃ­cil';

  @override
  String get master => 'Maestro';

  @override
  String get sameDevice => 'Dos jugadores en este dispositivo';

  @override
  String featureComingSoon(String feature) {
    return '$feature es el siguiente paso de desarrollo.';
  }

  @override
  String get errorMatchFinished => 'Esta partida terminÃ³.';

  @override
  String get errorCaptureRequired => 'Primero retira una pieza rival.';

  @override
  String get errorPlacementFinished => 'La fase de colocaciÃ³n terminÃ³.';

  @override
  String get errorPointOccupied => 'Este punto estÃ¡ ocupado.';

  @override
  String get errorNotMovementPhase => 'AÃºn no se pueden mover las piezas.';

  @override
  String get errorNotYourPiece => 'Esa pieza no es tuya.';

  @override
  String get errorTargetOccupied => 'El destino estÃ¡ ocupado.';

  @override
  String get errorNotAdjacent =>
      'MuÃ©vete por una lÃ­nea conectada a un punto adyacente.';

  @override
  String get errorNoCaptureRight => 'Ahora no puedes capturar.';

  @override
  String get errorOpponentPieceRequired => 'Elige una pieza rival.';

  @override
  String get errorProtectedMillPiece =>
      'Elige primero una pieza fuera de un molino.';

  @override
  String get errorInvalidPoint => 'Punto de tablero no vÃ¡lido.';

  @override
  String get errorBoardMismatch => 'Esta partida usa un tablero incompatible.';

  @override
  String get continueMatch => 'Continuar partida';

  @override
  String continueMatchSubtitle(String gameName) {
    return 'Retoma tu partida de $gameName';
  }

  @override
  String get resume => 'Volver a la partida';

  @override
  String get saveAndExit => 'Guardar y salir';

  @override
  String get abandonMatch => 'Abandonar partida';

  @override
  String get matchInProgressTitle => 'Partida en curso';

  @override
  String get matchInProgressBody =>
      'Tu posiciÃ³n actual se guarda automÃ¡ticamente. Â¿QuÃ© quieres hacer?';

  @override
  String get matchLoadError => 'No se pudo abrir la partida guardada.';

  @override
  String get errorTitle => 'Algo saliÃ³ mal';

  @override
  String get routeError => 'No se pudo abrir esta pantalla de forma segura.';

  @override
  String get backHome => 'Volver al inicio';

  @override
  String get noFriendsYet => 'AÃºn no tienes amigos.';

  @override
  String get sound => 'Sonido';

  @override
  String get haptic => 'Respuesta hÃ¡ptica';

  @override
  String get boardView => 'Vista del tablero';

  @override
  String get viewFlat => '2D';

  @override
  String get viewRealistic => 'Realista';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'Invitado';

  @override
  String get localProfile => 'Perfil local';

  @override
  String get genericLoadError => 'No se pudo cargar el contenido.';

  @override
  String get retry => 'Reintentar';

  @override
  String get restartMatchTitle => 'Â¿Reiniciar partida?';

  @override
  String get restartMatchBody =>
      'La posiciÃ³n guardada actual serÃ¡ reemplazada por una partida nueva.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get aiFoundationNotice =>
      'Los niveles mÃ¡s altos calculan mÃ¡s jugadas y cometen menos errores tÃ¡cticos.';

  @override
  String get saveFailedStayInMatch =>
      'La partida no se pudo guardar de forma segura. Permanece en la partida e intÃ©ntalo de nuevo.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Claras: $light  â€¢  Oscuras: $dark';
  }

  @override
  String get aiThinking => 'El ordenador estÃ¡ pensandoâ€¦';

  @override
  String get computerPlayer => 'Computadora';

  @override
  String get you => 'TÃº';

  @override
  String moveCountLabel(int count) {
    return 'Jugada $count';
  }

  @override
  String boardPointLight(int number) {
    return 'Punto $number, ficha clara';
  }

  @override
  String boardPointDark(int number) {
    return 'Punto $number, ficha oscura';
  }

  @override
  String boardPointEmpty(int number) {
    return 'Punto $number, vacÃ­o';
  }

  @override
  String ratingValue(int rating) {
    return 'PuntuaciÃ³n $rating';
  }

  @override
  String get inviteLinkReady => 'El enlace de invitaciÃ³n estÃ¡ listo.';

  @override
  String get ratings => 'Puntuaciones';

  @override
  String get statistics => 'EstadÃ­sticas';

  @override
  String get wins => 'Victorias';

  @override
  String get losses => 'Derrotas';

  @override
  String get bestStreak => 'Mejor racha';

  @override
  String get winRate => 'Porcentaje de victorias';

  @override
  String countryProfile(String code) {
    return 'PaÃ­s: $code';
  }

  @override
  String get world => 'Mundo';

  @override
  String get country => 'PaÃ­s';

  @override
  String recordValue(int wins, int losses) {
    return '$wins V â€¢ $losses D';
  }

  @override
  String get onlineArena => 'Arena en lÃ­nea';

  @override
  String get onlineArenaSubtitle =>
      'Partidas rÃ¡pidas, retos a amigos y clasificaciones en un solo lugar.';

  @override
  String get quickMatch => 'Partida rÃ¡pida';

  @override
  String get onlineBackendRequired =>
      'La base del cliente en lÃ­nea estÃ¡ lista. El emparejamiento competitivo permanece desactivado hasta desplegar Firebase Auth, Realtime Database y Cloud Functions.';

  @override
  String get challengeFriends => 'Retar a amigos';

  @override
  String get viewRankings => 'Ver clasificaciÃ³n';

  @override
  String tutorialProgress(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get tutorialPlaceTitle => 'Coloca tus fichas';

  @override
  String get tutorialPlaceBody =>
      'Durante la colocaciÃ³n toca un punto vacÃ­o. Crea planes y bloquea al rival.';

  @override
  String get tutorialMillTitle => 'Forma un molino';

  @override
  String get tutorialMillBody =>
      'Tres fichas propias en una lÃ­nea vÃ¡lida forman un molino.';

  @override
  String get tutorialCaptureTitle => 'Captura una ficha';

  @override
  String get tutorialCaptureBody =>
      'Tras formar un molino elige una ficha rival resaltada. Primero se capturan fichas fuera de molinos cuando existan.';

  @override
  String get tutorialMoveTitle => 'MuÃ©vete por las lÃ­neas';

  @override
  String get tutorialMoveBody =>
      'Al terminar la colocaciÃ³n mueve una ficha a un punto vacÃ­o adyacente. TambiÃ©n puedes mantener pulsado y arrastrar.';

  @override
  String get tutorialBlockTitle => 'Bloquea al rival';

  @override
  String get tutorialBlockBody =>
      'Controla intersecciones y cierra rutas. Sin movimientos legales se pierde en 9 y 12 fichas.';

  @override
  String get tutorialFlyTitle => 'Vuela con tres fichas';

  @override
  String get tutorialFlyBody =>
      'Con la regla de vuelo, al quedar tres fichas puedes mover a cualquier punto vacÃ­o.';

  @override
  String get tutorialDoubleMillTitle => 'Crea amenazas repetidas';

  @override
  String get tutorialDoubleMillBody =>
      'El juego avanzado conecta molinos, fuerza capturas y conserva movilidad.';

  @override
  String get previous => 'Anterior';

  @override
  String get finish => 'Finalizar';

  @override
  String get next => 'Siguiente';

  @override
  String get gameExperience => 'Experiencia de juego';

  @override
  String get reduceMotion => 'Reducir movimiento';

  @override
  String get reduceMotionSubtitle =>
      'Desactiva pulsos y movimientos no esenciales.';

  @override
  String get showMoveHints => 'Mostrar ayudas de jugada';

  @override
  String get showMoveHintsSubtitle =>
      'Resalta destinos legales y objetivos capturables.';

  @override
  String get colorAssist => 'Ayuda de color';

  @override
  String get colorAssistSubtitle =>
      'AÃ±ade formas y bordes para no depender solo del color.';

  @override
  String get boardSurface => 'Superficie del tablero';

  @override
  String get surfaceWood => 'Madera';

  @override
  String get surfaceDarkStone => 'Piedra oscura';

  @override
  String get surfaceMarble => 'MÃ¡rmol';

  @override
  String get surfaceMinimal => 'Minimalista';

  @override
  String get pieceTheme => 'Estilo de fichas';

  @override
  String get pieceClassic => 'ClÃ¡sico';

  @override
  String get pieceMarble => 'MÃ¡rmol';

  @override
  String get pieceObsidian => 'Obsidiana';

  @override
  String get progression => 'Progreso';

  @override
  String levelLabel(int level) {
    return 'Nivel $level';
  }

  @override
  String xpProgress(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String get addFriendTitle => 'AÃ±adir amigo';

  @override
  String get addFriendSubtitle => 'AÃ±ade un jugador por su nombre.';

  @override
  String get friendNameLabel => 'Nombre del jugador';

  @override
  String get friendNameHint => 'Escribe un nombre';

  @override
  String get addFriendButton => 'AÃ±adir amigo';

  @override
  String get friendNameTooShort => 'Escribe al menos 2 caracteres.';

  @override
  String get friendAlreadyAdded =>
      'Este jugador ya estÃ¡ en tu lista de amigos.';

  @override
  String friendAdded(String name) {
    return '$name se aÃ±adiÃ³ a tus amigos.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Â¡Te reto a $game en Morris World! Abre o instala el juego aquÃ­: $link';
  }

  @override
  String get resultVictoryPraise => 'Â¡Felicidades! Gran partida. Â¿Revancha?';

  @override
  String get resultDefeatPraise => 'Â¡Buena lucha! Â¿Listo para la revancha?';

  @override
  String get resultDrawPraise => 'Gran partida: terminÃ³ en empate. Â¿Otra?';

  @override
  String get resultLocalPraise => 'Â¡Gran partida! Â¿Jugamos la revancha?';

  @override
  String get rematch => 'Jugar revancha';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get playerName => 'Nombre de jugador';

  @override
  String get countryCode => 'CÃ³digo de paÃ­s';

  @override
  String get saveProfile => 'Guardar perfil';

  @override
  String get profileSaved => 'Perfil guardado.';

  @override
  String get profileSaveFailed => 'No se pudo guardar el perfil.';

  @override
  String get profileNameRequired =>
      'El nombre de jugador no puede estar vacÃ­o.';

  @override
  String get profileCountryCodeHint => 'p. ej. ES';

  @override
  String get profileCountryCodeInvalid =>
      'El cÃ³digo de paÃ­s debe tener dos letras.';

  @override
  String get profileLocalSaveNote =>
      'Los datos de tu perfil se guardan de forma segura en este dispositivo.';
}
