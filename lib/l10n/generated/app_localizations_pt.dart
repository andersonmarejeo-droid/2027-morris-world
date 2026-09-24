// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Morris World';

  @override
  String get home => 'Início';

  @override
  String get selectGameTitle => 'Escolha seu jogo';

  @override
  String get selectGameSubtitle =>
      'Três jogos clássicos de estratégia em um único espaço social e tranquilo.';

  @override
  String get game3Name => 'Moinho de 3';

  @override
  String get game3Description => 'Rápido, simples e tático.';

  @override
  String get game9Name => 'Moinho de 9';

  @override
  String get game9Description => 'O clássico principal.';

  @override
  String get game12Name => 'Moinho de 12';

  @override
  String get game12Description =>
      'Tabuleiro mais denso e estratégia mais profunda.';

  @override
  String selectModeTitle(String gameName) {
    return 'Como você quer jogar $gameName?';
  }

  @override
  String get online => 'Online';

  @override
  String get onlineSubtitle => 'Encontre um adversário real no mundo';

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
      'Não precisa de internet • escolha a dificuldade';

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
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Usar idioma do aparelho';

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
  String get darkPlayer => 'Escuro';

  @override
  String playerWon(String player) {
    return '$player venceu';
  }

  @override
  String get draw => 'Empate';

  @override
  String capturePrompt(String player) {
    return '$player: remova uma peça adversária';
  }

  @override
  String placePrompt(String player) {
    return '$player: coloque uma peça';
  }

  @override
  String movePrompt(String player) {
    return '$player: faça sua jogada';
  }

  @override
  String get quickGoodMove => 'Boa jogada!';

  @override
  String get quickCongrats => 'Parabéns!';

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
    return 'O desafio para $name está pronto.';
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
  String get easy => 'Fácil';

  @override
  String get medium => 'Médio';

  @override
  String get hard => 'Difícil';

  @override
  String get master => 'Mestre';

  @override
  String get sameDevice => 'Dois jogadores neste aparelho';

  @override
  String featureComingSoon(String feature) {
    return '$feature é o próximo passo de desenvolvimento.';
  }

  @override
  String get errorMatchFinished => 'Esta partida terminou.';

  @override
  String get errorCaptureRequired => 'Remova primeiro uma peça adversária.';

  @override
  String get errorPlacementFinished => 'A fase de colocação terminou.';

  @override
  String get errorPointOccupied => 'Este ponto está ocupado.';

  @override
  String get errorNotMovementPhase => 'As peças ainda não podem se mover.';

  @override
  String get errorNotYourPiece => 'Essa peça não é sua.';

  @override
  String get errorTargetOccupied => 'O destino está ocupado.';

  @override
  String get errorNotAdjacent =>
      'Mova por uma linha conectada até um ponto adjacente.';

  @override
  String get errorNoCaptureRight => 'Você não pode capturar agora.';

  @override
  String get errorOpponentPieceRequired => 'Escolha uma peça adversária.';

  @override
  String get errorProtectedMillPiece =>
      'Escolha primeiro uma peça fora de um moinho.';

  @override
  String get errorInvalidPoint => 'Ponto de tabuleiro inválido.';

  @override
  String get errorBoardMismatch =>
      'Esta partida usa um tabuleiro incompatível.';

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
      'Sua posição atual é salva automaticamente. O que você quer fazer?';

  @override
  String get matchLoadError => 'Não foi possível abrir a partida salva.';

  @override
  String get errorTitle => 'Algo deu errado';

  @override
  String get routeError => 'Não foi possível abrir esta tela com segurança.';

  @override
  String get backHome => 'Voltar ao início';

  @override
  String get noFriendsYet => 'Você ainda não tem amigos.';

  @override
  String get sound => 'Som';

  @override
  String get haptic => 'Feedback tátil';

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
  String get genericLoadError => 'Não foi possível carregar o conteúdo.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get restartMatchTitle => 'Reiniciar partida?';

  @override
  String get restartMatchBody =>
      'A posição salva atual será substituída por uma nova partida.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get aiFoundationNotice =>
      'Os níveis mais altos calculam mais jogadas e cometem menos erros táticos.';

  @override
  String get saveFailedStayInMatch =>
      'A partida não pôde ser salva com segurança. Permaneça na partida e tente novamente.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Claras: $light  •  Escuras: $dark';
  }

  @override
  String get aiThinking => 'O computador está a pensar…';

  @override
  String get computerPlayer => 'Computador';

  @override
  String get you => 'Você';

  @override
  String moveCountLabel(int count) {
    return 'Jogada $count';
  }

  @override
  String boardPointLight(int number) {
    return 'Ponto $number, peça clara';
  }

  @override
  String boardPointDark(int number) {
    return 'Ponto $number, peça escura';
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
  String get inviteLinkReady => 'O link de convite está pronto.';

  @override
  String get ratings => 'Ratings';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get wins => 'Vitórias';

  @override
  String get losses => 'Derrotas';

  @override
  String get bestStreak => 'Melhor sequência';

  @override
  String get winRate => 'Taxa de vitória';

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
  String get onlineArena => 'Arena Online';

  @override
  String get onlineArenaSubtitle =>
      'Partidas rápidas, desafios de amigos e rankings em um só lugar.';

  @override
  String get quickMatch => 'Partida rápida';

  @override
  String get onlineBackendRequired =>
      'A base do cliente online está pronta. O matchmaking ranqueado permanece desativado até a implantação do Firebase Auth, Realtime Database e Cloud Functions.';

  @override
  String get challengeFriends => 'Desafiar amigos';

  @override
  String get viewRankings => 'Ver ranking';

  @override
  String tutorialProgress(int current, int total) {
    return 'Etapa $current de $total';
  }

  @override
  String get tutorialPlaceTitle => 'Coloque suas peças';

  @override
  String get tutorialPlaceBody =>
      'Na fase de colocação, toque em um ponto vazio. Crie planos e bloqueie o adversário.';

  @override
  String get tutorialMillTitle => 'Forme um moinho';

  @override
  String get tutorialMillBody =>
      'Três peças suas em uma linha válida formam um moinho.';

  @override
  String get tutorialCaptureTitle => 'Capture uma peça';

  @override
  String get tutorialCaptureBody =>
      'Após formar um moinho, escolha uma peça adversária destacada. Peças fora de moinhos devem ser capturadas primeiro.';

  @override
  String get tutorialMoveTitle => 'Mova pelas linhas';

  @override
  String get tutorialMoveBody =>
      'Depois de colocar todas as peças, mova para um ponto vazio adjacente. Também é possível pressionar e arrastar.';

  @override
  String get tutorialBlockTitle => 'Bloqueie o adversário';

  @override
  String get tutorialBlockBody =>
      'Controle cruzamentos e feche rotas. Sem jogada legal, perde-se no 9/12 peças.';

  @override
  String get tutorialFlyTitle => 'Voe com três peças';

  @override
  String get tutorialFlyBody =>
      'Com a regra de voo, ao ficar com três peças você pode ir para qualquer ponto vazio.';

  @override
  String get tutorialDoubleMillTitle => 'Crie ameaças repetidas';

  @override
  String get tutorialDoubleMillBody =>
      'O jogo avançado conecta moinhos, força capturas e mantém mobilidade.';

  @override
  String get previous => 'Anterior';

  @override
  String get finish => 'Concluir';

  @override
  String get next => 'Próximo';

  @override
  String get gameExperience => 'Experiência de jogo';

  @override
  String get reduceMotion => 'Reduzir movimento';

  @override
  String get reduceMotionSubtitle =>
      'Desativa pulsos e movimentos não essenciais.';

  @override
  String get showMoveHints => 'Mostrar dicas de jogada';

  @override
  String get showMoveHintsSubtitle =>
      'Destaca destinos legais e alvos capturáveis.';

  @override
  String get colorAssist => 'Assistência de cor';

  @override
  String get colorAssistSubtitle =>
      'Adiciona formas e bordas para não depender apenas da cor.';

  @override
  String get boardSurface => 'Superfície do tabuleiro';

  @override
  String get surfaceWood => 'Madeira';

  @override
  String get surfaceDarkStone => 'Pedra escura';

  @override
  String get surfaceMarble => 'Mármore';

  @override
  String get surfaceMinimal => 'Minimalista';

  @override
  String get pieceTheme => 'Estilo das peças';

  @override
  String get pieceClassic => 'Clássico';

  @override
  String get pieceMarble => 'Mármore';

  @override
  String get pieceObsidian => 'Obsidiana';

  @override
  String get progression => 'Progresso';

  @override
  String levelLabel(int level) {
    return 'Nível $level';
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
      'Este jogador já está na sua lista de amigos.';

  @override
  String friendAdded(String name) {
    return '$name foi adicionado aos seus amigos.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Desafio você para $game no Morris World! Abra ou instale o jogo aqui: $link';
  }

  @override
  String get resultVictoryPraise => 'Parabéns! Ótima partida. Quer revanche?';

  @override
  String get resultDefeatPraise => 'Boa luta! Pronto para a revanche?';

  @override
  String get resultDrawPraise => 'Ótima partida — terminou empatada. Mais uma?';

  @override
  String get resultLocalPraise => 'Ã“tima partida! Quer revanche?';

  @override
  String get rematch => 'Jogar revanche';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get playerName => 'Nome do jogador';

  @override
  String get countryCode => 'Código do país';

  @override
  String get saveProfile => 'Guardar perfil';

  @override
  String get profileSaved => 'Perfil guardado.';

  @override
  String get profileSaveFailed => 'Não foi possível guardar o perfil.';

  @override
  String get profileNameRequired => 'O nome do jogador não pode ficar vazio.';

  @override
  String get profileCountryCodeHint => 'ex. PT';

  @override
  String get profileCountryCodeInvalid =>
      'O código do país deve ter duas letras.';

  @override
  String get profileLocalSaveNote =>
      'Os dados do teu perfil são guardados com segurança neste dispositivo.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Morris World';

  @override
  String get home => 'Início';

  @override
  String get selectGameTitle => 'Escolha seu jogo';

  @override
  String get selectGameSubtitle =>
      'Três jogos clássicos de estratégia em um único espaço social e tranquilo.';

  @override
  String get game3Name => 'Moinho de 3';

  @override
  String get game3Description => 'Rápido, simples e tático.';

  @override
  String get game9Name => 'Moinho de 9';

  @override
  String get game9Description => 'O clássico principal.';

  @override
  String get game12Name => 'Moinho de 12';

  @override
  String get game12Description =>
      'Tabuleiro mais denso e estratégia mais profunda.';

  @override
  String selectModeTitle(String gameName) {
    return 'Como você quer jogar $gameName?';
  }

  @override
  String get online => 'Online';

  @override
  String get onlineSubtitle => 'Encontre um adversário real no mundo';

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
      'Não precisa de internet • escolha a dificuldade';

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
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Usar idioma do aparelho';

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
  String get darkPlayer => 'Escuro';

  @override
  String playerWon(String player) {
    return '$player venceu';
  }

  @override
  String get draw => 'Empate';

  @override
  String capturePrompt(String player) {
    return '$player: remova uma peça adversária';
  }

  @override
  String placePrompt(String player) {
    return '$player: coloque uma peça';
  }

  @override
  String movePrompt(String player) {
    return '$player: faça sua jogada';
  }

  @override
  String get quickGoodMove => 'Boa jogada!';

  @override
  String get quickCongrats => 'Parabéns!';

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
    return 'O desafio para $name está pronto.';
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
  String get easy => 'Fácil';

  @override
  String get medium => 'Médio';

  @override
  String get hard => 'Difícil';

  @override
  String get master => 'Mestre';

  @override
  String get sameDevice => 'Dois jogadores neste aparelho';

  @override
  String featureComingSoon(String feature) {
    return '$feature é o próximo passo de desenvolvimento.';
  }

  @override
  String get errorMatchFinished => 'Esta partida terminou.';

  @override
  String get errorCaptureRequired => 'Remova primeiro uma peça adversária.';

  @override
  String get errorPlacementFinished => 'A fase de colocação terminou.';

  @override
  String get errorPointOccupied => 'Este ponto está ocupado.';

  @override
  String get errorNotMovementPhase => 'As peças ainda não podem se mover.';

  @override
  String get errorNotYourPiece => 'Essa peça não é sua.';

  @override
  String get errorTargetOccupied => 'O destino está ocupado.';

  @override
  String get errorNotAdjacent =>
      'Mova por uma linha conectada até um ponto adjacente.';

  @override
  String get errorNoCaptureRight => 'Você não pode capturar agora.';

  @override
  String get errorOpponentPieceRequired => 'Escolha uma peça adversária.';

  @override
  String get errorProtectedMillPiece =>
      'Escolha primeiro uma peça fora de um moinho.';

  @override
  String get errorInvalidPoint => 'Ponto de tabuleiro inválido.';

  @override
  String get errorBoardMismatch =>
      'Esta partida usa um tabuleiro incompatível.';

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
      'Sua posição atual é salva automaticamente. O que você quer fazer?';

  @override
  String get matchLoadError => 'Não foi possível abrir a partida salva.';

  @override
  String get errorTitle => 'Algo deu errado';

  @override
  String get routeError => 'Não foi possível abrir esta tela com segurança.';

  @override
  String get backHome => 'Voltar ao início';

  @override
  String get noFriendsYet => 'Você ainda não tem amigos.';

  @override
  String get sound => 'Som';

  @override
  String get haptic => 'Feedback tátil';

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
  String get genericLoadError => 'Não foi possível carregar o conteúdo.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get restartMatchTitle => 'Reiniciar partida?';

  @override
  String get restartMatchBody =>
      'A posição salva atual será substituída por uma nova partida.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get aiFoundationNotice =>
      'Os níveis mais altos calculam mais jogadas e cometem menos erros táticos.';

  @override
  String get saveFailedStayInMatch =>
      'A partida não pôde ser salva com segurança. Permaneça na partida e tente novamente.';

  @override
  String piecesToPlaceStatus(int light, int dark) {
    return 'Claras: $light  •  Escuras: $dark';
  }

  @override
  String get aiThinking => 'O computador está pensando…';

  @override
  String get computerPlayer => 'Computador';

  @override
  String get you => 'Você';

  @override
  String moveCountLabel(int count) {
    return 'Jogada $count';
  }

  @override
  String boardPointLight(int number) {
    return 'Ponto $number, peça clara';
  }

  @override
  String boardPointDark(int number) {
    return 'Ponto $number, peça escura';
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
  String get inviteLinkReady => 'O link de convite está pronto.';

  @override
  String get ratings => 'Ratings';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get wins => 'Vitórias';

  @override
  String get losses => 'Derrotas';

  @override
  String get bestStreak => 'Melhor sequência';

  @override
  String get winRate => 'Taxa de vitória';

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
  String get onlineArena => 'Arena Online';

  @override
  String get onlineArenaSubtitle =>
      'Partidas rápidas, desafios de amigos e rankings em um só lugar.';

  @override
  String get quickMatch => 'Partida rápida';

  @override
  String get onlineBackendRequired =>
      'A base do cliente online está pronta. O matchmaking ranqueado permanece desativado até a implantação do Firebase Auth, Realtime Database e Cloud Functions.';

  @override
  String get challengeFriends => 'Desafiar amigos';

  @override
  String get viewRankings => 'Ver ranking';

  @override
  String tutorialProgress(int current, int total) {
    return 'Etapa $current de $total';
  }

  @override
  String get tutorialPlaceTitle => 'Coloque suas peças';

  @override
  String get tutorialPlaceBody =>
      'Na fase de colocação, toque em um ponto vazio. Crie planos e bloqueie o adversário.';

  @override
  String get tutorialMillTitle => 'Forme um moinho';

  @override
  String get tutorialMillBody =>
      'Três peças suas em uma linha válida formam um moinho.';

  @override
  String get tutorialCaptureTitle => 'Capture uma peça';

  @override
  String get tutorialCaptureBody =>
      'Após formar um moinho, escolha uma peça adversária destacada. Peças fora de moinhos devem ser capturadas primeiro.';

  @override
  String get tutorialMoveTitle => 'Mova pelas linhas';

  @override
  String get tutorialMoveBody =>
      'Depois de colocar todas as peças, mova para um ponto vazio adjacente. Também é possível pressionar e arrastar.';

  @override
  String get tutorialBlockTitle => 'Bloqueie o adversário';

  @override
  String get tutorialBlockBody =>
      'Controle cruzamentos e feche rotas. Sem jogada legal, perde-se no 9/12 peças.';

  @override
  String get tutorialFlyTitle => 'Voe com três peças';

  @override
  String get tutorialFlyBody =>
      'Com a regra de voo, ao ficar com três peças você pode ir para qualquer ponto vazio.';

  @override
  String get tutorialDoubleMillTitle => 'Crie ameaças repetidas';

  @override
  String get tutorialDoubleMillBody =>
      'O jogo avançado conecta moinhos, força capturas e mantém mobilidade.';

  @override
  String get previous => 'Anterior';

  @override
  String get finish => 'Concluir';

  @override
  String get next => 'Próximo';

  @override
  String get gameExperience => 'Experiência de jogo';

  @override
  String get reduceMotion => 'Reduzir movimento';

  @override
  String get reduceMotionSubtitle =>
      'Desativa pulsos e movimentos não essenciais.';

  @override
  String get showMoveHints => 'Mostrar dicas de jogada';

  @override
  String get showMoveHintsSubtitle =>
      'Destaca destinos legais e alvos capturáveis.';

  @override
  String get colorAssist => 'Assistência de cor';

  @override
  String get colorAssistSubtitle =>
      'Adiciona formas e bordas para não depender apenas da cor.';

  @override
  String get boardSurface => 'Superfície do tabuleiro';

  @override
  String get surfaceWood => 'Madeira';

  @override
  String get surfaceDarkStone => 'Pedra escura';

  @override
  String get surfaceMarble => 'Mármore';

  @override
  String get surfaceMinimal => 'Minimalista';

  @override
  String get pieceTheme => 'Estilo das peças';

  @override
  String get pieceClassic => 'Clássico';

  @override
  String get pieceMarble => 'Mármore';

  @override
  String get pieceObsidian => 'Obsidiana';

  @override
  String get progression => 'Progresso';

  @override
  String levelLabel(int level) {
    return 'Nível $level';
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
      'Este jogador já está na sua lista de amigos.';

  @override
  String friendAdded(String name) {
    return '$name foi adicionado aos seus amigos.';
  }

  @override
  String whatsappChallengeInvite(String game, String link) {
    return 'Desafio você para $game no Morris World! Abra ou instale o jogo aqui: $link';
  }

  @override
  String get resultVictoryPraise => 'Parabéns! Ótima partida. Quer revanche?';

  @override
  String get resultDefeatPraise => 'Boa disputa! Pronto para a revanche?';

  @override
  String get resultDrawPraise => 'Ótima partida — terminou empatada. Mais uma?';

  @override
  String get resultLocalPraise => 'Ã“tima partida! Quer revanche?';

  @override
  String get rematch => 'Jogar revanche';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get playerName => 'Nome do jogador';

  @override
  String get countryCode => 'Código do país';

  @override
  String get saveProfile => 'Salvar perfil';

  @override
  String get profileSaved => 'Perfil salvo.';

  @override
  String get profileSaveFailed => 'Não foi possível salvar o perfil.';

  @override
  String get profileNameRequired => 'O nome do jogador não pode ficar vazio.';

  @override
  String get profileCountryCodeHint => 'ex. BR';

  @override
  String get profileCountryCodeInvalid =>
      'O código do país deve ter duas letras.';

  @override
  String get profileLocalSaveNote =>
      'Os dados do seu perfil são salvos com segurança neste dispositivo.';
}
