// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => '3-9-12 Morris';

  @override
  String get ageAudienceTitle => 'Quem vai jogar?';

  @override
  String get ageAudienceBody =>
      'Escolha uma faixa etária para manter a experiência adequada para todos.';

  @override
  String get ageAudienceChild => 'Menos de 18 anos ou prefiro não informar';

  @override
  String get ageAudienceAdult => '18 anos ou mais';

  @override
  String get ageAudiencePrivacy =>
      'Não pedimos a data de nascimento. Esta escolha fica apenas neste dispositivo. Os anúncios não são personalizados e as salas online ficam indisponíveis para menores de 18 anos e para quem não quiser responder. Os anúncios são adequados para famílias e têm classificação máxima G.';

  @override
  String get ageAudienceOnlineRestricted =>
      'As salas online estão disponíveis apenas para quem indica ter 18 anos ou mais. Pessoas mais novas e quem preferir não responder podem jogar contra o computador ou no mesmo dispositivo.';

  @override
  String get ageAudienceGotIt => 'Entendi';

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
  String get onlineSubtitle =>
      'Procure um adversário online; se não houver, jogue contra o computador';

  @override
  String get createPrivateRoom => 'Criar sala privada';

  @override
  String get joinPrivateRoom => 'Entrar com código da sala';

  @override
  String get roomCode => 'Código da sala';

  @override
  String get roomCodeHint => 'Digite o código compartilhado pelo seu amigo';

  @override
  String get waitingForOpponent => 'A partida começa quando seu amigo entrar.';

  @override
  String get copyRoomCode => 'Copiar código';

  @override
  String get roomCodeCopied => 'Código da sala copiado.';

  @override
  String get sparkPrivateRoomNotice =>
      'As crianças devem jogar online com um adulto responsável. Compartilhe o código apenas com pessoas conhecidas. Não há ranking, busca pública nem chat.';

  @override
  String get onlineOpponent => 'Adversário';

  @override
  String get onlineWaitingTurn => 'Aguardando a jogada do adversário.';

  @override
  String get onlineMoveFailed =>
      'Não foi possível enviar a jogada. Verifique a conexão e tente novamente.';

  @override
  String get onlineRoomUnavailable =>
      'Sala não encontrada ou cheia. Confira o código.';

  @override
  String get closeOnlineRoom => 'Fechar sala';

  @override
  String get exitMatch => 'Sair da partida';

  @override
  String get exitMatchConfirm =>
      'A partida ainda está em andamento. Se sair, seu adversário será declarado vencedor. Sair?';

  @override
  String get opponentLeft => 'Seu adversário saiu da partida; você venceu.';

  @override
  String get opponentTimedOut =>
      'Seu adversário não fez uma jogada por dois minutos; você venceu.';

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
  String get rankingsUnavailable =>
      'Os rankings mundial, nacional e de amigos ainda não estão conectados a dados reais de jogadores. Eles aparecerão aqui quando o serviço estiver disponível.';

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
    return 'Classificação $rating';
  }

  @override
  String get inviteLinkReady => 'O link de convite está pronto.';

  @override
  String get ratings => 'Classificações';

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
      'As salas privadas estão indisponíveis no momento. Verifique sua conexão e tente novamente.';

  @override
  String get challengeInviteOpenedWithoutRoom =>
      'O convite do WhatsApp está pronto. Não foi possível criar uma sala online, então nenhum código foi incluído.';

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
    return 'Vamos jogar $game juntos no 3-9-12 Morris! Baixe o aplicativo aqui: $link';
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

  @override
  String get accountAndLegal => 'Conta e informações legais';

  @override
  String get termsOfUse => 'Termos de uso';

  @override
  String get termsSummary =>
      '3-9-12 Tas oferece os jogos clássicos de 3, 9 e 12 peças. Use o aplicativo de acordo com a lei. O perfil e as partidas salvas ficam neste dispositivo; não há compras no aplicativo.\n\nQuando as salas online estiverem ativadas, serviços de terceiros como o Firebase poderão ser usados. Compartilhe códigos de sala apenas com pessoas conhecidas. Aplicativos externos de compartilhamento têm seus próprios termos.\n\nEste texto é uma informação geral sobre o produto, não um contrato vinculativo. O endereço oficial do publicador e os termos jurídicos específicos de cada país ainda não foram verificados.';

  @override
  String get legalInformation => 'Informações legais';

  @override
  String get legalInformationBody =>
      'Publicador: Mustafa Polat · ZP GAMES\nContato: andersonmarejeo@gmail.com\n\nO endereço oficial para notificações e o nome empresarial registrado ainda não foram verificados. Use o e-mail de contato para avisos legais.';

  @override
  String get onlineSignOut => 'Sair da sessão online';

  @override
  String get onlineSignOutDone =>
      'Você saiu da sessão online. As partidas salvas neste dispositivo foram mantidas.';

  @override
  String get onlineSessionMissing =>
      'Não há uma sessão online ativa neste dispositivo.';

  @override
  String get deleteLocalData => 'Excluir dados deste dispositivo';

  @override
  String get deleteLocalDataTitle => 'Excluir os dados deste dispositivo?';

  @override
  String get deleteLocalDataBody =>
      'Isso exclui permanentemente deste dispositivo seu perfil, amigos adicionados e partidas salvas. Não exclui dados de salas Firebase nem uma conta remota. Esta ação não pode ser desfeita.';

  @override
  String get deleteLocalDataDone =>
      'O perfil, a lista de amigos e as partidas salvas deste dispositivo foram excluídos.';

  @override
  String get deleteAction => 'Excluir dados';

  @override
  String get gameOptions => 'Opções da partida';

  @override
  String get drawRuleNotice =>
      'A partida termina empatada se a mesma posição, incluindo quem joga, se repetir 5 vezes ou após 100 jogadas consecutivas sem captura.';

  @override
  String get offerDraw => 'Propor empate';

  @override
  String get drawOfferPrompt =>
      'Quer propor empate? A partida só termina empatada se o adversário aceitar.';

  @override
  String get drawOfferReceived => 'Proposta de empate';

  @override
  String get drawOfferReceivedBody => 'O adversário propôs empate. Aceita?';

  @override
  String get acceptDraw => 'Aceitar empate';

  @override
  String get declineDraw => 'Recusar';

  @override
  String get drawOfferDeclined => 'A proposta de empate foi recusada.';

  @override
  String get computerDrawOfferAccepted =>
      'O computador aceitou a proposta de empate.';

  @override
  String get computerDrawOfferDeclined =>
      'O computador recusou a proposta de empate.';

  @override
  String get resignMatch => 'Desistir';

  @override
  String get resignConfirm =>
      'Tem certeza de que deseja desistir? Seu oponente vencerá.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => '3-9-12 Morris';

  @override
  String get ageAudienceTitle => 'Quem vai jogar?';

  @override
  String get ageAudienceBody =>
      'Escolha uma faixa etária para manter a experiência adequada para todos.';

  @override
  String get ageAudienceChild => 'Menos de 18 anos ou prefiro não informar';

  @override
  String get ageAudienceAdult => '18 anos ou mais';

  @override
  String get ageAudiencePrivacy =>
      'Não pedimos a data de nascimento. Esta escolha fica apenas neste dispositivo. Os anúncios não são personalizados e as salas on-line ficam indisponíveis para menores de 18 anos e para quem não quiser responder. Os anúncios são adequados para famílias e têm classificação máxima G.';

  @override
  String get ageAudienceOnlineRestricted =>
      'As salas on-line estão disponíveis apenas para quem indica ter 18 anos ou mais. Pessoas mais novas e quem preferir não responder podem jogar contra o computador ou no mesmo dispositivo.';

  @override
  String get ageAudienceGotIt => 'Entendi';

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
  String get onlineSubtitle =>
      'Procure um adversário online; se não houver, jogue contra o computador';

  @override
  String get createPrivateRoom => 'Criar sala privada';

  @override
  String get joinPrivateRoom => 'Entrar com código da sala';

  @override
  String get roomCode => 'Código da sala';

  @override
  String get roomCodeHint => 'Digite o código compartilhado pelo seu amigo';

  @override
  String get waitingForOpponent => 'A partida começa quando seu amigo entrar.';

  @override
  String get copyRoomCode => 'Copiar código';

  @override
  String get roomCodeCopied => 'Código da sala copiado.';

  @override
  String get sparkPrivateRoomNotice =>
      'Crianças devem jogar on-line com um responsável. Compartilhe o código somente com pessoas conhecidas. Não há ranking, busca pública nem chat.';

  @override
  String get onlineOpponent => 'Adversário';

  @override
  String get onlineWaitingTurn => 'Aguardando a jogada do adversário.';

  @override
  String get onlineMoveFailed =>
      'Não foi possível enviar a jogada. Verifique sua conexão e tente novamente.';

  @override
  String get onlineRoomUnavailable =>
      'Sala não encontrada ou cheia. Confira o código.';

  @override
  String get closeOnlineRoom => 'Fechar sala';

  @override
  String get exitMatch => 'Sair da partida';

  @override
  String get exitMatchConfirm =>
      'A partida ainda está em andamento. Se você sair, seu adversário será declarado vencedor. Sair?';

  @override
  String get opponentLeft => 'Seu adversário saiu da partida; você venceu.';

  @override
  String get opponentTimedOut =>
      'Seu adversário não fez uma jogada por dois minutos; você venceu.';

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
  String get rankingsUnavailable =>
      'Os rankings mundial, nacional e de amigos ainda não estão conectados a dados reais de jogadores. Eles aparecerão aqui quando o serviço estiver disponível.';

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
    return 'Classificação $rating';
  }

  @override
  String get inviteLinkReady => 'O link de convite está pronto.';

  @override
  String get ratings => 'Classificações';

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
      'As salas privadas estão indisponíveis no momento. Verifique sua conexão e tente novamente.';

  @override
  String get challengeInviteOpenedWithoutRoom =>
      'O convite do WhatsApp está pronto. Não foi possível criar uma sala online, então nenhum código foi incluído.';

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
    return 'Vamos jogar $game juntos no 3-9-12 Morris! Baixe o aplicativo aqui: $link';
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

  @override
  String get accountAndLegal => 'Conta e informações legais';

  @override
  String get termsOfUse => 'Termos de uso';

  @override
  String get termsSummary =>
      '3-9-12 Tas oferece os jogos clássicos de 3, 9 e 12 peças. Use o aplicativo conforme a lei. O perfil e as partidas salvas ficam neste dispositivo; não há compras no app.\n\nQuando as salas online estiverem ativadas, serviços de terceiros como o Firebase poderão ser usados. Compartilhe códigos de sala somente com pessoas conhecidas. Aplicativos externos de compartilhamento têm seus próprios termos.\n\nEste texto é uma informação geral sobre o produto, não um contrato vinculativo. O endereço oficial do publicador e os termos jurídicos específicos de cada país ainda não foram verificados.';

  @override
  String get legalInformation => 'Informações legais';

  @override
  String get legalInformationBody =>
      'Publicador: Mustafa Polat · ZP GAMES\nContato: andersonmarejeo@gmail.com\n\nO endereço oficial para notificações e o nome empresarial registrado ainda não foram verificados. Use o e-mail de contato para avisos legais.';

  @override
  String get onlineSignOut => 'Sair da sessão online';

  @override
  String get onlineSignOutDone =>
      'Você saiu da sessão online. As partidas salvas neste dispositivo foram mantidas.';

  @override
  String get onlineSessionMissing =>
      'Não há uma sessão online ativa neste dispositivo.';

  @override
  String get deleteLocalData => 'Excluir dados deste dispositivo';

  @override
  String get deleteLocalDataTitle => 'Excluir os dados deste dispositivo?';

  @override
  String get deleteLocalDataBody =>
      'Isso exclui permanentemente deste dispositivo seu perfil, amigos adicionados e partidas salvas. Não exclui dados de salas Firebase nem uma conta remota. Esta ação não pode ser desfeita.';

  @override
  String get deleteLocalDataDone =>
      'O perfil, a lista de amigos e as partidas salvas deste dispositivo foram excluídos.';

  @override
  String get deleteAction => 'Excluir dados';

  @override
  String get gameOptions => 'Opções da partida';

  @override
  String get drawRuleNotice =>
      'A partida termina empatada se a mesma posição, incluindo quem joga, se repetir 5 vezes ou após 100 jogadas consecutivas sem captura.';

  @override
  String get offerDraw => 'Oferecer empate';

  @override
  String get drawOfferPrompt =>
      'Quer oferecer empate? A partida só termina empatada se o adversário aceitar.';

  @override
  String get drawOfferReceived => 'Oferta de empate';

  @override
  String get drawOfferReceivedBody =>
      'Seu adversário ofereceu empate. Você aceita?';

  @override
  String get acceptDraw => 'Aceitar empate';

  @override
  String get declineDraw => 'Recusar';

  @override
  String get drawOfferDeclined => 'A oferta de empate foi recusada.';

  @override
  String get computerDrawOfferAccepted =>
      'O computador aceitou a oferta de empate.';

  @override
  String get computerDrawOfferDeclined =>
      'O computador recusou a oferta de empate.';

  @override
  String get resignMatch => 'Desistir';

  @override
  String get resignConfirm =>
      'Tem certeza de que deseja desistir? Seu oponente vencerá.';
}
