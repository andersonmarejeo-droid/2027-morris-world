// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => '3-9-12 Taş';

  @override
  String get home => 'InÃ­cio';

  @override
  String get selectGameTitle => 'Escolha seu jogo';

  @override
  String get selectGameSubtitle =>
      'TrÃªs jogos clÃ¡ssicos de estratÃ©gia em um Ãºnico espaÃ§o social e tranquilo.';

  @override
  String get game3Name => 'Moinho de 3';

  @override
  String get game3Description => 'RÃ¡pido, simples e tÃ¡tico.';

  @override
  String get game9Name => 'Moinho de 9';

  @override
  String get game9Description => 'O clÃ¡ssico principal.';

  @override
  String get game12Name => 'Moinho de 12';

  @override
  String get game12Description =>
      'Tabuleiro mais denso e estratÃ©gia mais profunda.';

  @override
  String selectModeTitle(String gameName) {
    return 'Como vocÃª quer jogar $gameName?';
  }

  @override
  String get online => 'Online';

  @override
  String get onlineSubtitle => 'Encontre um adversÃ¡rio real no mundo';

  @override
  String get challenge => 'Desafiar';

  @override
  String get challengeSubtitle => 'Convide um amigo no jogo ou por link';

  @override
  String get offline => 'Offline';

  @override
  String get offlineSubtitle =>
      'Jogue contra IA ou dois jogadores no mesmo aparelho';

  @override
  String get computerModeTitle => 'Jogar contra o computador';

  @override
  String get computerModeSubtitle =>
      'NÃ£o precisa de internet â€¢ escolha a dificuldade';

  @override
  String get sameDeviceSubtitle => 'Dois jogadores alternam neste dispositivo';

  @override
  String get howToPlay => 'Como jogar';

  @override
  String get friends => 'Amigos';

  @override
  String get rankings => 'Ranking';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'ConfiguraÃ§Ãµes';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Usar idioma do aparelho';

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
  String get darkPlayer => 'Escuro';

  @override
  String playerWon(String player) {
    return '$player venceu';
  }

  @override
  String get draw => 'Empate';

  @override
  String capturePrompt(String player) {
    return '$player: remova uma peÃ§a adversÃ¡ria';
  }

  @override
  String placePrompt(String player) {
    return '$player: coloque uma peÃ§a';
  }

  @override
  String movePrompt(String player) {
    return '$player: faÃ§a sua jogada';
  }

  @override
  String get quickGoodMove => 'Boa jogada!';

  @override
  String get quickCongrats => 'ParabÃ©ns!';

  @override
  String get quickGoodGame => 'Bom jogo!';

  @override
  String get quickMore => 'Mais';

  @override
  String get shareInvite => 'Desafiar pelo WhatsApp';

  @override
  String get challengeButton => 'Desafiar';

  @override
  String challengePrepared(String name) {
    return 'O desafio para $name estÃ¡ pronto.';
  }

  @override
  String get presenceOnline => 'Online';

  @override
  String get presenceInMatch => 'Em partida';

  @override
  String get presenceOffline => 'Offline';

  @override
  String get offlineDifficultyTitle => 'Escolha a dificuldade';

  @override
  String get beginner => 'Iniciante';

  @override
  String get easy => 'FÃ¡cil';

  @override
  String get medium => 'MÃ©dio';

  @override
  String get hard => 'DifÃ­cil';

  @override
  String get master => 'Mestre';

  @override
  String get sameDevice => 'Dois jogadores neste aparelho';

  @override
  String featureComingSoon(String feature) {
    return '$feature Ã© o prÃ³ximo passo de desenvolvimento.';
  }

  @override
  String get errorMatchFinished => 'Esta partida terminou.';

  @override
  String get errorCaptureRequired => 'Remova primeiro uma peÃ§a adversÃ¡ria.';

  @override
  String get errorPlacementFinished => 'A fase de colocaÃ§Ã£o terminou.';

  @override
  String get errorPointOccupied => 'Este ponto estÃ¡ ocupado.';

  @override
  String get errorNotMovementPhase => 'As peÃ§as ainda nÃ£o podem se mover.';

  @override
  String get errorNotYourPiece => 'Essa peÃ§a nÃ£o Ã© sua.';

  @override
  String get errorTargetOccupied => 'O destino estÃ¡ ocupado.';

  @override
  String get errorNotAdjacent =>
      'Mova por uma linha conectada atÃ© um ponto adjacente.';

  @override
  String get errorNoCaptureRight => 'VocÃª nÃ£o pode capturar agora.';

  @override
  String get errorOpponentPieceRequired => 'Escolha uma peÃ§a adversÃ¡ria.';

  @override
  String get errorProtectedMillPiece =>
      'Escolha primeiro uma peÃ§a fora de um moinho.';

  @override
  String get errorInvalidPoint => 'Ponto de tabuleiro invÃ¡lido.';

  @override
  String get errorBoardMismatch =>
      'Esta partida usa um tabuleiro incompatÃ­vel.';

  @override
  String get continueMatch => 'Continuar partida';

  @override
  String continueMatchSubtitle(String gameName) {
    return 'Retome sua partida de $gameName';
  }

  @override
  String get resume => 'Voltar ao jogo';

  @override
  String get saveAndExit => 'Salvar e sair';

  @override
  String get abandonMatch => 'Abandonar partida';

  @override
  String get matchInProgressTitle => 'Partida em andamento';

  @override
  String get matchInProgressBody =>
      'Sua posiÃ§Ã£o atual Ã© salva automaticamente. O que vocÃª quer fazer?';

  @override
  String get matchLoadError => 'NÃ£o foi possÃ­vel abrir a partida salva.';

  @override
  String get errorTitle => 'Algo deu errado';

  @override
  String get routeError => 'NÃ£o foi possÃ­vel abrir esta tela com seguranÃ§a.';

  @override
  String get backHome => 'Voltar ao inÃ­cio';

  @override
  String get noFriendsYet => 'VocÃª ainda nÃ£o tem amigos.';

  @override
  String get sound => 'Som';

  @override
  String get haptic => 'Feedback tÃ¡til';

  @override
  String get boardView => 'Visual do tabuleiro';

  @override
  String get viewFlat => '2D';

  @override
  String get viewRealistic => 'Realista';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'Convidado';

  @override
  String get localProfile => 'Perfil local';

  @override
  String get genericLoadError => 'NÃ£o foi possÃ­vel carregar o conteÃºdo.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get restartMatchTitle => 'Reiniciar partida?';

  @override
  String get restartMatchBody =>
      'A posiÃ§Ã£o salva atual serÃ¡ substituÃ­da por uma nova partida.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get aiFoundationNotice =>
      'Os nÃ­veis mais altos calculam mais jogadas e cometem menos erros tÃ¡ticos.';

  @override
  String get saveFailedStayInMatch =>
      'A partida nÃ£o pÃ´de ser salva com seguranÃ§a. PermaneÃ§a na partida e tente novamente.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Claras: $light  â€¢  Escuras: $dark';
  }

  @override
  String get aiThinking => 'O computador estÃ¡ a pensarâ€¦';

  @override
  String get computerPlayer => 'Computador';

  @override
  String get you => 'VocÃª';

  @override
  String moveCountLabel(int count) {
    return 'Jogada $count';
  }

  @override
  String boardPointLight(int number) {
    return 'Ponto $number, peÃ§a clara';
  }

  @override
  String boardPointDark(int number) {
    return 'Ponto $number, peÃ§a escura';
  }

  @override
  String boardPointEmpty(int number) {
    return 'Ponto $number, vazio';
  }

  @override
  String ratingValue(int rating) {
    return 'Rating $rating';
  }

  @override
  String get inviteLinkReady => 'O link de convite estÃ¡ pronto.';

  @override
  String get ratings => 'Ratings';

  @override
  String get statistics => 'EstatÃ­sticas';

  @override
  String get wins => 'VitÃ³rias';

  @override
  String get losses => 'Derrotas';

  @override
  String get bestStreak => 'Melhor sequÃªncia';

  @override
  String get winRate => 'Taxa de vitÃ³ria';

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
  String get onlineArena => 'Arena Online';

  @override
  String get onlineArenaSubtitle =>
      'Partidas rÃ¡pidas, desafios de amigos e rankings em um sÃ³ lugar.';

  @override
  String get quickMatch => 'Partida rÃ¡pida';

  @override
  String get onlineBackendRequired =>
      'A base do cliente online estÃ¡ pronta. O matchmaking ranqueado permanece desativado atÃ© a implantaÃ§Ã£o do Firebase Auth, Realtime Database e Cloud Functions.';

  @override
  String get challengeFriends => 'Desafiar amigos';

  @override
  String get viewRankings => 'Ver ranking';

  @override
  String tutorialProgress(int current, int total) {
    return 'Etapa $current de $total';
  }

  @override
  String get tutorialPlaceTitle => 'Coloque suas peÃ§as';

  @override
  String get tutorialPlaceBody =>
      'Na fase de colocaÃ§Ã£o, toque em um ponto vazio. Crie planos e bloqueie o adversÃ¡rio.';

  @override
  String get tutorialMillTitle => 'Forme um moinho';

  @override
  String get tutorialMillBody =>
      'TrÃªs peÃ§as suas em uma linha vÃ¡lida formam um moinho.';

  @override
  String get tutorialCaptureTitle => 'Capture uma peÃ§a';

  @override
  String get tutorialCaptureBody =>
      'ApÃ³s formar um moinho, escolha uma peÃ§a adversÃ¡ria destacada. PeÃ§as fora de moinhos devem ser capturadas primeiro.';

  @override
  String get tutorialMoveTitle => 'Mova pelas linhas';

  @override
  String get tutorialMoveBody =>
      'Depois de colocar todas as peÃ§as, mova para um ponto vazio adjacente. TambÃ©m Ã© possÃ­vel pressionar e arrastar.';

  @override
  String get tutorialBlockTitle => 'Bloqueie o adversÃ¡rio';

  @override
  String get tutorialBlockBody =>
      'Controle cruzamentos e feche rotas. Sem jogada legal, perde-se no 9/12 peÃ§as.';

  @override
  String get tutorialFlyTitle => 'Voe com trÃªs peÃ§as';

  @override
  String get tutorialFlyBody =>
      'Com a regra de voo, ao ficar com trÃªs peÃ§as vocÃª pode ir para qualquer ponto vazio.';

  @override
  String get tutorialDoubleMillTitle => 'Crie ameaÃ§as repetidas';

  @override
  String get tutorialDoubleMillBody =>
      'O jogo avanÃ§ado conecta moinhos, forÃ§a capturas e mantÃ©m mobilidade.';

  @override
  String get previous => 'Anterior';

  @override
  String get finish => 'Concluir';

  @override
  String get next => 'PrÃ³ximo';

  @override
  String get gameExperience => 'ExperiÃªncia de jogo';

  @override
  String get reduceMotion => 'Reduzir movimento';

  @override
  String get reduceMotionSubtitle =>
      'Desativa pulsos e movimentos nÃ£o essenciais.';

  @override
  String get showMoveHints => 'Mostrar dicas de jogada';

  @override
  String get showMoveHintsSubtitle =>
      'Destaca destinos legais e alvos capturÃ¡veis.';

  @override
  String get colorAssist => 'AssistÃªncia de cor';

  @override
  String get colorAssistSubtitle =>
      'Adiciona formas e bordas para nÃ£o depender apenas da cor.';

  @override
  String get boardSurface => 'SuperfÃ­cie do tabuleiro';

  @override
  String get surfaceWood => 'Madeira';

  @override
  String get surfaceDarkStone => 'Pedra escura';

  @override
  String get surfaceMarble => 'MÃ¡rmore';

  @override
  String get surfaceMinimal => 'Minimalista';

  @override
  String get pieceTheme => 'Estilo das peÃ§as';

  @override
  String get pieceClassic => 'ClÃ¡ssico';

  @override
  String get pieceMarble => 'MÃ¡rmore';

  @override
  String get pieceObsidian => 'Obsidiana';

  @override
  String get progression => 'Progresso';

  @override
  String levelLabel(int level) {
    return 'NÃ­vel $level';
  }

  @override
  String xpProgress(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String get addFriendTitle => 'Adicionar amigo';

  @override
  String get addFriendSubtitle => 'Adicione um jogador pelo nome.';

  @override
  String get friendNameLabel => 'Nome do jogador';

  @override
  String get friendNameHint => 'Digite um nome';

  @override
  String get addFriendButton => 'Adicionar amigo';

  @override
  String get friendNameTooShort => 'Digite pelo menos 2 caracteres.';

  @override
  String get friendAlreadyAdded =>
      'Este jogador jÃ¡ estÃ¡ na sua lista de amigos.';

  @override
  String friendAdded(String name) {
    return '$name foi adicionado aos seus amigos.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Desafio vocÃª para $game no Morris World! Abra ou instale o jogo aqui: $link';
  }

  @override
  String get resultVictoryPraise => 'ParabÃ©ns! Ã“tima partida. Quer revanche?';

  @override
  String get resultDefeatPraise => 'Boa luta! Pronto para a revanche?';

  @override
  String get resultDrawPraise =>
      'Ã“tima partida â€” terminou empatada. Mais uma?';

  @override
  String get resultLocalPraise => 'Ã“tima partida! Quer revanche?';

  @override
  String get rematch => 'Jogar revanche';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get playerName => 'Nome do jogador';

  @override
  String get countryCode => 'CÃ³digo do paÃ­s';

  @override
  String get saveProfile => 'Guardar perfil';

  @override
  String get profileSaved => 'Perfil guardado.';

  @override
  String get profileSaveFailed => 'NÃ£o foi possÃ­vel guardar o perfil.';

  @override
  String get profileNameRequired => 'O nome do jogador nÃ£o pode ficar vazio.';

  @override
  String get profileCountryCodeHint => 'ex. PT';

  @override
  String get profileCountryCodeInvalid =>
      'O cÃ³digo do paÃ­s deve ter duas letras.';

  @override
  String get profileLocalSaveNote =>
      'Os dados do teu perfil sÃ£o guardados com seguranÃ§a neste dispositivo.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => '3-9-12 Taş';

  @override
  String get home => 'InÃ­cio';

  @override
  String get selectGameTitle => 'Escolha seu jogo';

  @override
  String get selectGameSubtitle =>
      'TrÃªs jogos clÃ¡ssicos de estratÃ©gia em um Ãºnico espaÃ§o social e tranquilo.';

  @override
  String get game3Name => 'Moinho de 3';

  @override
  String get game3Description => 'RÃ¡pido, simples e tÃ¡tico.';

  @override
  String get game9Name => 'Moinho de 9';

  @override
  String get game9Description => 'O clÃ¡ssico principal.';

  @override
  String get game12Name => 'Moinho de 12';

  @override
  String get game12Description =>
      'Tabuleiro mais denso e estratÃ©gia mais profunda.';

  @override
  String selectModeTitle(String gameName) {
    return 'Como vocÃª quer jogar $gameName?';
  }

  @override
  String get online => 'Online';

  @override
  String get onlineSubtitle => 'Encontre um adversÃ¡rio real no mundo';

  @override
  String get challenge => 'Desafiar';

  @override
  String get challengeSubtitle => 'Convide um amigo no jogo ou por link';

  @override
  String get offline => 'Offline';

  @override
  String get offlineSubtitle =>
      'Jogue contra IA ou dois jogadores no mesmo aparelho';

  @override
  String get computerModeTitle => 'Jogar contra o computador';

  @override
  String get computerModeSubtitle =>
      'NÃ£o precisa de internet â€¢ escolha a dificuldade';

  @override
  String get sameDeviceSubtitle => 'Dois jogadores se alternam neste aparelho';

  @override
  String get howToPlay => 'Como jogar';

  @override
  String get friends => 'Amigos';

  @override
  String get rankings => 'Ranking';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'ConfiguraÃ§Ãµes';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Usar idioma do aparelho';

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
  String get darkPlayer => 'Escuro';

  @override
  String playerWon(String player) {
    return '$player venceu';
  }

  @override
  String get draw => 'Empate';

  @override
  String capturePrompt(String player) {
    return '$player: remova uma peÃ§a adversÃ¡ria';
  }

  @override
  String placePrompt(String player) {
    return '$player: coloque uma peÃ§a';
  }

  @override
  String movePrompt(String player) {
    return '$player: faÃ§a sua jogada';
  }

  @override
  String get quickGoodMove => 'Boa jogada!';

  @override
  String get quickCongrats => 'ParabÃ©ns!';

  @override
  String get quickGoodGame => 'Bom jogo!';

  @override
  String get quickMore => 'Mais';

  @override
  String get shareInvite => 'Desafiar pelo WhatsApp';

  @override
  String get challengeButton => 'Desafiar';

  @override
  String challengePrepared(String name) {
    return 'O desafio para $name estÃ¡ pronto.';
  }

  @override
  String get presenceOnline => 'Online';

  @override
  String get presenceInMatch => 'Em partida';

  @override
  String get presenceOffline => 'Offline';

  @override
  String get offlineDifficultyTitle => 'Escolha a dificuldade';

  @override
  String get beginner => 'Iniciante';

  @override
  String get easy => 'FÃ¡cil';

  @override
  String get medium => 'MÃ©dio';

  @override
  String get hard => 'DifÃ­cil';

  @override
  String get master => 'Mestre';

  @override
  String get sameDevice => 'Dois jogadores neste aparelho';

  @override
  String featureComingSoon(String feature) {
    return '$feature Ã© o prÃ³ximo passo de desenvolvimento.';
  }

  @override
  String get errorMatchFinished => 'Esta partida terminou.';

  @override
  String get errorCaptureRequired => 'Remova primeiro uma peÃ§a adversÃ¡ria.';

  @override
  String get errorPlacementFinished => 'A fase de colocaÃ§Ã£o terminou.';

  @override
  String get errorPointOccupied => 'Este ponto estÃ¡ ocupado.';

  @override
  String get errorNotMovementPhase => 'As peÃ§as ainda nÃ£o podem se mover.';

  @override
  String get errorNotYourPiece => 'Essa peÃ§a nÃ£o Ã© sua.';

  @override
  String get errorTargetOccupied => 'O destino estÃ¡ ocupado.';

  @override
  String get errorNotAdjacent =>
      'Mova por uma linha conectada atÃ© um ponto adjacente.';

  @override
  String get errorNoCaptureRight => 'VocÃª nÃ£o pode capturar agora.';

  @override
  String get errorOpponentPieceRequired => 'Escolha uma peÃ§a adversÃ¡ria.';

  @override
  String get errorProtectedMillPiece =>
      'Escolha primeiro uma peÃ§a fora de um moinho.';

  @override
  String get errorInvalidPoint => 'Ponto de tabuleiro invÃ¡lido.';

  @override
  String get errorBoardMismatch =>
      'Esta partida usa um tabuleiro incompatÃ­vel.';

  @override
  String get continueMatch => 'Continuar partida';

  @override
  String continueMatchSubtitle(String gameName) {
    return 'Retome sua partida de $gameName';
  }

  @override
  String get resume => 'Voltar ao jogo';

  @override
  String get saveAndExit => 'Salvar e sair';

  @override
  String get abandonMatch => 'Abandonar partida';

  @override
  String get matchInProgressTitle => 'Partida em andamento';

  @override
  String get matchInProgressBody =>
      'Sua posiÃ§Ã£o atual Ã© salva automaticamente. O que vocÃª quer fazer?';

  @override
  String get matchLoadError => 'NÃ£o foi possÃ­vel abrir a partida salva.';

  @override
  String get errorTitle => 'Algo deu errado';

  @override
  String get routeError => 'NÃ£o foi possÃ­vel abrir esta tela com seguranÃ§a.';

  @override
  String get backHome => 'Voltar ao inÃ­cio';

  @override
  String get noFriendsYet => 'VocÃª ainda nÃ£o tem amigos.';

  @override
  String get sound => 'Som';

  @override
  String get haptic => 'Feedback tÃ¡til';

  @override
  String get boardView => 'Visual do tabuleiro';

  @override
  String get viewFlat => '2D';

  @override
  String get viewRealistic => 'Realista';

  @override
  String get viewPerspective => '3D';

  @override
  String get guestPlayer => 'Convidado';

  @override
  String get localProfile => 'Perfil local';

  @override
  String get genericLoadError => 'NÃ£o foi possÃ­vel carregar o conteÃºdo.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get restartMatchTitle => 'Reiniciar partida?';

  @override
  String get restartMatchBody =>
      'A posiÃ§Ã£o salva atual serÃ¡ substituÃ­da por uma nova partida.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get aiFoundationNotice =>
      'Os nÃ­veis mais altos calculam mais jogadas e cometem menos erros tÃ¡ticos.';

  @override
  String get saveFailedStayInMatch =>
      'A partida nÃ£o pÃ´de ser salva com seguranÃ§a. PermaneÃ§a na partida e tente novamente.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Claras: $light  â€¢  Escuras: $dark';
  }

  @override
  String get aiThinking => 'O computador estÃ¡ pensandoâ€¦';

  @override
  String get computerPlayer => 'Computador';

  @override
  String get you => 'VocÃª';

  @override
  String moveCountLabel(int count) {
    return 'Jogada $count';
  }

  @override
  String boardPointLight(int number) {
    return 'Ponto $number, peÃ§a clara';
  }

  @override
  String boardPointDark(int number) {
    return 'Ponto $number, peÃ§a escura';
  }

  @override
  String boardPointEmpty(int number) {
    return 'Ponto $number, vazio';
  }

  @override
  String ratingValue(int rating) {
    return 'Rating $rating';
  }

  @override
  String get inviteLinkReady => 'O link de convite estÃ¡ pronto.';

  @override
  String get ratings => 'Ratings';

  @override
  String get statistics => 'EstatÃ­sticas';

  @override
  String get wins => 'VitÃ³rias';

  @override
  String get losses => 'Derrotas';

  @override
  String get bestStreak => 'Melhor sequÃªncia';

  @override
  String get winRate => 'Taxa de vitÃ³ria';

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
  String get onlineArena => 'Arena Online';

  @override
  String get onlineArenaSubtitle =>
      'Partidas rÃ¡pidas, desafios de amigos e rankings em um sÃ³ lugar.';

  @override
  String get quickMatch => 'Partida rÃ¡pida';

  @override
  String get onlineBackendRequired =>
      'A base do cliente online estÃ¡ pronta. O matchmaking ranqueado permanece desativado atÃ© a implantaÃ§Ã£o do Firebase Auth, Realtime Database e Cloud Functions.';

  @override
  String get challengeFriends => 'Desafiar amigos';

  @override
  String get viewRankings => 'Ver ranking';

  @override
  String tutorialProgress(int current, int total) {
    return 'Etapa $current de $total';
  }

  @override
  String get tutorialPlaceTitle => 'Coloque suas peÃ§as';

  @override
  String get tutorialPlaceBody =>
      'Na fase de colocaÃ§Ã£o, toque em um ponto vazio. Crie planos e bloqueie o adversÃ¡rio.';

  @override
  String get tutorialMillTitle => 'Forme um moinho';

  @override
  String get tutorialMillBody =>
      'TrÃªs peÃ§as suas em uma linha vÃ¡lida formam um moinho.';

  @override
  String get tutorialCaptureTitle => 'Capture uma peÃ§a';

  @override
  String get tutorialCaptureBody =>
      'ApÃ³s formar um moinho, escolha uma peÃ§a adversÃ¡ria destacada. PeÃ§as fora de moinhos devem ser capturadas primeiro.';

  @override
  String get tutorialMoveTitle => 'Mova pelas linhas';

  @override
  String get tutorialMoveBody =>
      'Depois de colocar todas as peÃ§as, mova para um ponto vazio adjacente. TambÃ©m Ã© possÃ­vel pressionar e arrastar.';

  @override
  String get tutorialBlockTitle => 'Bloqueie o adversÃ¡rio';

  @override
  String get tutorialBlockBody =>
      'Controle cruzamentos e feche rotas. Sem jogada legal, perde-se no 9/12 peÃ§as.';

  @override
  String get tutorialFlyTitle => 'Voe com trÃªs peÃ§as';

  @override
  String get tutorialFlyBody =>
      'Com a regra de voo, ao ficar com trÃªs peÃ§as vocÃª pode ir para qualquer ponto vazio.';

  @override
  String get tutorialDoubleMillTitle => 'Crie ameaÃ§as repetidas';

  @override
  String get tutorialDoubleMillBody =>
      'O jogo avanÃ§ado conecta moinhos, forÃ§a capturas e mantÃ©m mobilidade.';

  @override
  String get previous => 'Anterior';

  @override
  String get finish => 'Concluir';

  @override
  String get next => 'PrÃ³ximo';

  @override
  String get gameExperience => 'ExperiÃªncia de jogo';

  @override
  String get reduceMotion => 'Reduzir movimento';

  @override
  String get reduceMotionSubtitle =>
      'Desativa pulsos e movimentos nÃ£o essenciais.';

  @override
  String get showMoveHints => 'Mostrar dicas de jogada';

  @override
  String get showMoveHintsSubtitle =>
      'Destaca destinos legais e alvos capturÃ¡veis.';

  @override
  String get colorAssist => 'AssistÃªncia de cor';

  @override
  String get colorAssistSubtitle =>
      'Adiciona formas e bordas para nÃ£o depender apenas da cor.';

  @override
  String get boardSurface => 'SuperfÃ­cie do tabuleiro';

  @override
  String get surfaceWood => 'Madeira';

  @override
  String get surfaceDarkStone => 'Pedra escura';

  @override
  String get surfaceMarble => 'MÃ¡rmore';

  @override
  String get surfaceMinimal => 'Minimalista';

  @override
  String get pieceTheme => 'Estilo das peÃ§as';

  @override
  String get pieceClassic => 'ClÃ¡ssico';

  @override
  String get pieceMarble => 'MÃ¡rmore';

  @override
  String get pieceObsidian => 'Obsidiana';

  @override
  String get progression => 'Progresso';

  @override
  String levelLabel(int level) {
    return 'NÃ­vel $level';
  }

  @override
  String xpProgress(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String get addFriendTitle => 'Adicionar amigo';

  @override
  String get addFriendSubtitle => 'Adicione um jogador pelo nome.';

  @override
  String get friendNameLabel => 'Nome do jogador';

  @override
  String get friendNameHint => 'Digite um nome';

  @override
  String get addFriendButton => 'Adicionar amigo';

  @override
  String get friendNameTooShort => 'Digite pelo menos 2 caracteres.';

  @override
  String get friendAlreadyAdded =>
      'Este jogador jÃ¡ estÃ¡ na sua lista de amigos.';

  @override
  String friendAdded(String name) {
    return '$name foi adicionado aos seus amigos.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Desafio vocÃª para $game no Morris World! Abra ou instale o jogo aqui: $link';
  }

  @override
  String get resultVictoryPraise => 'ParabÃ©ns! Ã“tima partida. Quer revanche?';

  @override
  String get resultDefeatPraise => 'Boa disputa! Pronto para a revanche?';

  @override
  String get resultDrawPraise =>
      'Ã“tima partida â€” terminou empatada. Mais uma?';

  @override
  String get resultLocalPraise => 'Ã“tima partida! Quer revanche?';

  @override
  String get rematch => 'Jogar revanche';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get playerName => 'Nome do jogador';

  @override
  String get countryCode => 'CÃ³digo do paÃ­s';

  @override
  String get saveProfile => 'Salvar perfil';

  @override
  String get profileSaved => 'Perfil salvo.';

  @override
  String get profileSaveFailed => 'NÃ£o foi possÃ­vel salvar o perfil.';

  @override
  String get profileNameRequired => 'O nome do jogador nÃ£o pode ficar vazio.';

  @override
  String get profileCountryCodeHint => 'ex. BR';

  @override
  String get profileCountryCodeInvalid =>
      'O cÃ³digo do paÃ­s deve ter duas letras.';

  @override
  String get profileLocalSaveNote =>
      'Os dados do seu perfil sÃ£o salvos com seguranÃ§a neste dispositivo.';
}
