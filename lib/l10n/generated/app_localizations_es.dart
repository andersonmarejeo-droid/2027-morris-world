// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => '3-9-12 Morris';

  @override
  String get ageAudienceTitle => '¿Quién va a jugar?';

  @override
  String get ageAudienceBody =>
      'Elige un grupo de edad para que la experiencia sea adecuada para todos.';

  @override
  String get ageAudienceChild => 'Menor de 18 o prefiero no decirlo';

  @override
  String get ageAudienceAdult => '18 años o más';

  @override
  String get ageAudiencePrivacy =>
      'No pedimos la fecha de nacimiento. Esta elección solo se guarda en este dispositivo. Los anuncios no son personalizados y las salas en línea no están disponibles para menores de 18 años ni para quienes prefieran no responder. Los anuncios son aptos para familias y tienen una clasificación máxima G.';

  @override
  String get ageAudienceOnlineRestricted =>
      'Las salas en línea solo están disponibles para quienes indican tener 18 años o más. Los menores y quienes prefieran no responder pueden jugar contra el ordenador o en el mismo dispositivo.';

  @override
  String get ageAudienceGotIt => 'Entendido';

  @override
  String get home => 'Inicio';

  @override
  String get selectGameTitle => 'Elige tu juego';

  @override
  String get selectGameSubtitle =>
      'Tres juegos clásicos de estrategia en un solo espacio social y tranquilo.';

  @override
  String get game3Name => 'Molino de tres';

  @override
  String get game3Description => 'Rápido, sencillo y táctico.';

  @override
  String get game9Name => 'Molino de nueve';

  @override
  String get game9Description => 'El juego clásico principal.';

  @override
  String get game12Name => 'Molino de doce';

  @override
  String get game12Description =>
      'Un tablero más denso y una estrategia más profunda.';

  @override
  String selectModeTitle(String gameName) {
    return '¿Cómo quieres jugar a $gameName?';
  }

  @override
  String get online => 'En línea';

  @override
  String get onlineSubtitle =>
      'Busca un rival en línea; si no hay, juega contra el ordenador';

  @override
  String get createPrivateRoom => 'Crear sala privada';

  @override
  String get joinPrivateRoom => 'Unirse con código de sala';

  @override
  String get roomCode => 'Código de sala';

  @override
  String get roomCodeHint => 'Escribe el código que compartió tu amigo';

  @override
  String get waitingForOpponent => 'La partida empieza cuando se una tu amigo.';

  @override
  String get copyRoomCode => 'Copiar código';

  @override
  String get roomCodeCopied => 'Código de sala copiado.';

  @override
  String get sparkPrivateRoomNotice =>
      'Los niños deben usar el juego en línea con un padre, madre o tutor. Comparte el código solo con personas conocidas. No hay clasificación, búsqueda pública ni chat.';

  @override
  String get onlineOpponent => 'Rival';

  @override
  String get onlineWaitingTurn => 'Esperando el movimiento de tu rival.';

  @override
  String get onlineMoveFailed =>
      'No se pudo enviar el movimiento. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get onlineRoomUnavailable =>
      'La sala no existe o ya está llena. Comprueba el código.';

  @override
  String get closeOnlineRoom => 'Cerrar sala';

  @override
  String get exitMatch => 'Salir de la partida';

  @override
  String get exitMatchConfirm =>
      'La partida continúa. Si sales, tu rival será declarado ganador. ¿Salir?';

  @override
  String get opponentLeft => 'Tu rival salió de la partida; has ganado.';

  @override
  String get opponentTimedOut =>
      'Tu rival no hizo ningún movimiento durante dos minutos; has ganado.';

  @override
  String get challenge => 'Desafiar';

  @override
  String get challengeSubtitle =>
      'Invita a un amigo dentro del juego o con un enlace';

  @override
  String get offline => 'Sin conexión';

  @override
  String get offlineSubtitle =>
      'Juega contra la IA o dos jugadores en un dispositivo';

  @override
  String get computerModeTitle => 'Jugar contra la computadora';

  @override
  String get computerModeSubtitle => 'No requiere internet • elige dificultad';

  @override
  String get sameDeviceSubtitle =>
      'Dos jugadores por turnos en este dispositivo';

  @override
  String get howToPlay => 'Cómo jugar';

  @override
  String get friends => 'Amigos';

  @override
  String get rankings => 'Clasificación';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Usar idioma del dispositivo';

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
  String get restart => 'Reiniciar';

  @override
  String get lightPlayer => 'Claro';

  @override
  String get darkPlayer => 'Oscuro';

  @override
  String playerWon(String player) {
    return '$player ganó';
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
  String get quickGoodMove => '¡Buen movimiento!';

  @override
  String get quickCongrats => '¡Felicidades!';

  @override
  String get quickGoodGame => '¡Buena partida!';

  @override
  String get quickMore => 'Más';

  @override
  String get shareInvite => 'Desafiar por WhatsApp';

  @override
  String get challengeButton => 'Desafiar';

  @override
  String challengePrepared(String name) {
    return 'El desafío para $name está listo.';
  }

  @override
  String get presenceOnline => 'En línea';

  @override
  String get presenceInMatch => 'En partida';

  @override
  String get presenceOffline => 'Sin conexión';

  @override
  String get offlineDifficultyTitle => 'Elige dificultad';

  @override
  String get beginner => 'Principiante';

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Media';

  @override
  String get hard => 'Difícil';

  @override
  String get master => 'Maestro';

  @override
  String get sameDevice => 'Dos jugadores en este dispositivo';

  @override
  String featureComingSoon(String feature) {
    return '$feature es el siguiente paso de desarrollo.';
  }

  @override
  String get errorMatchFinished => 'Esta partida terminó.';

  @override
  String get errorCaptureRequired => 'Primero retira una pieza rival.';

  @override
  String get errorPlacementFinished => 'La fase de colocación terminó.';

  @override
  String get errorPointOccupied => 'Este punto está ocupado.';

  @override
  String get errorNotMovementPhase => 'Aún no se pueden mover las piezas.';

  @override
  String get errorNotYourPiece => 'Esa pieza no es tuya.';

  @override
  String get errorTargetOccupied => 'El destino está ocupado.';

  @override
  String get errorNotAdjacent =>
      'Muévete por una línea conectada a un punto adyacente.';

  @override
  String get errorNoCaptureRight => 'Ahora no puedes capturar.';

  @override
  String get errorOpponentPieceRequired => 'Elige una pieza rival.';

  @override
  String get errorProtectedMillPiece =>
      'Elige primero una pieza fuera de un molino.';

  @override
  String get errorInvalidPoint => 'Punto de tablero no válido.';

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
      'Tu posición actual se guarda automáticamente. ¿Qué quieres hacer?';

  @override
  String get matchLoadError => 'No se pudo abrir la partida guardada.';

  @override
  String get errorTitle => 'Algo salió mal';

  @override
  String get routeError => 'No se pudo abrir esta pantalla de forma segura.';

  @override
  String get backHome => 'Volver al inicio';

  @override
  String get noFriendsYet => 'Aún no tienes amigos.';

  @override
  String get rankingsUnavailable =>
      'Las clasificaciones mundial, nacional y de amigos aún no están conectadas a datos reales de jugadores. Aparecerán aquí cuando el servicio esté disponible.';

  @override
  String get sound => 'Sonido';

  @override
  String get haptic => 'Respuesta háptica';

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
  String get restartMatchTitle => '¿Reiniciar partida?';

  @override
  String get restartMatchBody =>
      'La posición guardada actual será reemplazada por una partida nueva.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get aiFoundationNotice =>
      'Los niveles más altos calculan más jugadas y cometen menos errores tácticos.';

  @override
  String get saveFailedStayInMatch =>
      'La partida no se pudo guardar de forma segura. Permanece en la partida e inténtalo de nuevo.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Claras: $light  •  Oscuras: $dark';
  }

  @override
  String get aiThinking => 'El ordenador está pensando…';

  @override
  String get computerPlayer => 'Computadora';

  @override
  String get you => 'Tú';

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
    return 'Punto $number, vacío';
  }

  @override
  String ratingValue(int rating) {
    return 'Puntuación $rating';
  }

  @override
  String get inviteLinkReady => 'El enlace de invitación está listo.';

  @override
  String get ratings => 'Puntuaciones';

  @override
  String get statistics => 'Estadísticas';

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
    return 'País: $code';
  }

  @override
  String get world => 'Mundo';

  @override
  String get country => 'País';

  @override
  String recordValue(int wins, int losses) {
    return '$wins V • $losses D';
  }

  @override
  String get onlineArena => 'Arena en línea';

  @override
  String get onlineArenaSubtitle =>
      'Partidas rápidas, retos a amigos y clasificaciones en un solo lugar.';

  @override
  String get quickMatch => 'Partida rápida';

  @override
  String get onlineBackendRequired =>
      'Las salas privadas no están disponibles ahora. Comprueba tu conexión a internet e inténtalo de nuevo.';

  @override
  String get challengeInviteOpenedWithoutRoom =>
      'La invitación de WhatsApp está lista. No se pudo crear una sala en línea, así que no se incluyó ningún código.';

  @override
  String get challengeFriends => 'Retar a amigos';

  @override
  String get viewRankings => 'Ver clasificación';

  @override
  String tutorialProgress(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get tutorialPlaceTitle => 'Coloca tus fichas';

  @override
  String get tutorialPlaceBody =>
      'Durante la colocación toca un punto vacío. Crea planes y bloquea al rival.';

  @override
  String get tutorialMillTitle => 'Forma un molino';

  @override
  String get tutorialMillBody =>
      'Tres fichas propias en una línea válida forman un molino.';

  @override
  String get tutorialCaptureTitle => 'Captura una ficha';

  @override
  String get tutorialCaptureBody =>
      'Tras formar un molino elige una ficha rival resaltada. Primero se capturan fichas fuera de molinos cuando existan.';

  @override
  String get tutorialMoveTitle => 'Muévete por las líneas';

  @override
  String get tutorialMoveBody =>
      'Al terminar la colocación mueve una ficha a un punto vacío adyacente. También puedes mantener pulsado y arrastrar.';

  @override
  String get tutorialBlockTitle => 'Bloquea al rival';

  @override
  String get tutorialBlockBody =>
      'Controla intersecciones y cierra rutas. Sin movimientos legales se pierde en 9 y 12 fichas.';

  @override
  String get tutorialFlyTitle => 'Vuela con tres fichas';

  @override
  String get tutorialFlyBody =>
      'Con la regla de vuelo, al quedar tres fichas puedes mover a cualquier punto vacío.';

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
      'Añade formas y bordes para no depender solo del color.';

  @override
  String get boardSurface => 'Superficie del tablero';

  @override
  String get surfaceWood => 'Madera';

  @override
  String get surfaceDarkStone => 'Piedra oscura';

  @override
  String get surfaceMarble => 'Mármol';

  @override
  String get surfaceMinimal => 'Minimalista';

  @override
  String get pieceTheme => 'Estilo de fichas';

  @override
  String get pieceClassic => 'Clásico';

  @override
  String get pieceMarble => 'Mármol';

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
  String get addFriendTitle => 'Añadir amigo';

  @override
  String get addFriendSubtitle => 'Añade un jugador por su nombre.';

  @override
  String get friendNameLabel => 'Nombre del jugador';

  @override
  String get friendNameHint => 'Escribe un nombre';

  @override
  String get addFriendButton => 'Añadir amigo';

  @override
  String get friendNameTooShort => 'Escribe al menos 2 caracteres.';

  @override
  String get friendAlreadyAdded =>
      'Este jugador ya está en tu lista de amigos.';

  @override
  String friendAdded(String name) {
    return '$name se añadió a tus amigos.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return '¡Juguemos juntos a $game en 3-9-12 Morris! Descarga la aplicación aquí: $link';
  }

  @override
  String get resultVictoryPraise => '¡Felicidades! Gran partida. ¿Revancha?';

  @override
  String get resultDefeatPraise => '¡Buena lucha! ¿Listo para la revancha?';

  @override
  String get resultDrawPraise => 'Gran partida: terminó en empate. ¿Otra?';

  @override
  String get resultLocalPraise => '¡Gran partida! ¿Jugamos la revancha?';

  @override
  String get rematch => 'Jugar revancha';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get playerName => 'Nombre de jugador';

  @override
  String get countryCode => 'Código de país';

  @override
  String get saveProfile => 'Guardar perfil';

  @override
  String get profileSaved => 'Perfil guardado.';

  @override
  String get profileSaveFailed => 'No se pudo guardar el perfil.';

  @override
  String get profileNameRequired =>
      'El nombre de jugador no puede estar vacío.';

  @override
  String get profileCountryCodeHint => 'p. ej. ES';

  @override
  String get profileCountryCodeInvalid =>
      'El código de país debe tener dos letras.';

  @override
  String get profileLocalSaveNote =>
      'Los datos de tu perfil se guardan de forma segura en este dispositivo.';

  @override
  String get accountAndLegal => 'Cuenta e información legal';

  @override
  String get termsOfUse => 'Condiciones de uso';

  @override
  String get termsSummary =>
      '3-9-12 Tas ofrece los juegos clásicos de 3, 9 y 12 fichas. Usa la aplicación conforme a la ley. El perfil y las partidas guardadas se almacenan en este dispositivo; no hay compras dentro de la aplicación.\n\nCuando se activen las salas en línea, se podrán usar servicios de terceros como Firebase. Comparte los códigos de sala solo con personas conocidas. Las aplicaciones externas tienen sus propias condiciones.\n\nEste texto es información general del producto, no un contrato vinculante. La dirección oficial del editor y las condiciones legales de cada país aún no se han verificado.';

  @override
  String get legalInformation => 'Información legal';

  @override
  String get legalInformationBody =>
      'Editor: Mustafa Polat · ZP GAMES\nContacto: andersonmarejeo@gmail.com\n\nLa dirección oficial de notificaciones y el nombre registrado de la empresa aún no se han verificado. Usa el correo de contacto para avisos legales.';

  @override
  String get onlineSignOut => 'Cerrar sesión en línea';

  @override
  String get onlineSignOutDone =>
      'Se cerró la sesión en línea. Las partidas guardadas en este dispositivo se conservaron.';

  @override
  String get onlineSessionMissing =>
      'No hay una sesión en línea activa en este dispositivo.';

  @override
  String get deleteLocalData => 'Eliminar los datos de este dispositivo';

  @override
  String get deleteLocalDataTitle => '¿Eliminar los datos de este dispositivo?';

  @override
  String get deleteLocalDataBody =>
      'Esto eliminará permanentemente de este dispositivo tu perfil, amigos añadidos y partidas guardadas. No elimina datos de salas Firebase ni una cuenta remota. Esta acción no se puede deshacer.';

  @override
  String get deleteLocalDataDone =>
      'Se eliminaron el perfil, la lista de amigos y las partidas guardadas de este dispositivo.';

  @override
  String get deleteAction => 'Eliminar datos';

  @override
  String get gameOptions => 'Opciones de partida';

  @override
  String get drawRuleNotice =>
      'La partida termina en tablas si la misma posición, incluido el turno, se repite 5 veces o tras 100 movimientos seguidos sin capturas.';

  @override
  String get offerDraw => 'Ofrecer tablas';

  @override
  String get drawOfferPrompt =>
      '¿Quieres ofrecer tablas? La partida solo terminará en empate si tu rival acepta.';

  @override
  String get drawOfferReceived => 'Oferta de tablas';

  @override
  String get drawOfferReceivedBody => 'Tu rival propone tablas. ¿Aceptas?';

  @override
  String get acceptDraw => 'Aceptar tablas';

  @override
  String get declineDraw => 'Rechazar';

  @override
  String get drawOfferDeclined => 'Se rechazó la oferta de tablas.';

  @override
  String get computerDrawOfferAccepted =>
      'El ordenador aceptó la oferta de tablas.';

  @override
  String get computerDrawOfferDeclined =>
      'El ordenador rechazó la oferta de tablas.';

  @override
  String get resignMatch => 'Rendirse';

  @override
  String get resignConfirm => '¿Seguro que quieres rendirte? Ganará tu rival.';
}
