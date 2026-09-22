import 'package:flutter/widgets.dart';

class AppSettingsState {
  const AppSettingsState({
    this.locale,
    this.soundEnabled = true,
    this.hapticEnabled = true,
    this.reduceMotion = false,
    this.showMoveHints = true,
    this.colorAssist = true,
    this.boardView = BoardViewStyle.realistic,
    this.boardSurface = BoardSurface.wood,
    this.pieceTheme = PieceTheme.classic,
  });

  final Locale? locale;
  final bool soundEnabled;
  final bool hapticEnabled;
  final bool reduceMotion;
  final bool showMoveHints;
  final bool colorAssist;
  final BoardViewStyle boardView;
  final BoardSurface boardSurface;
  final PieceTheme pieceTheme;

  AppSettingsState copyWith({
    Locale? locale,
    bool clearLocale = false,
    bool? soundEnabled,
    bool? hapticEnabled,
    bool? reduceMotion,
    bool? showMoveHints,
    bool? colorAssist,
    BoardViewStyle? boardView,
    BoardSurface? boardSurface,
    PieceTheme? pieceTheme,
  }) {
    return AppSettingsState(
      locale: clearLocale ? null : (locale ?? this.locale),
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      showMoveHints: showMoveHints ?? this.showMoveHints,
      colorAssist: colorAssist ?? this.colorAssist,
      boardView: boardView ?? this.boardView,
      boardSurface: boardSurface ?? this.boardSurface,
      pieceTheme: pieceTheme ?? this.pieceTheme,
    );
  }
}

enum BoardViewStyle { flat2d, realistic, perspective3d }
enum BoardSurface { wood, darkStone, marble, minimal }
enum PieceTheme { classic, marble, obsidian }
