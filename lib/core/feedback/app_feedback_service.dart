import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import '../../app/app_settings_controller.dart';
import '../settings/app_settings_models.dart';

abstract interface class GameFeedback {
  Future<void> buttonPressed();
  Future<void> pieceSelected();
  Future<void> piecePlaced();
  Future<void> pieceMoved();
  Future<void> millFormed();
  Future<void> pieceCaptured();
  Future<void> success();
}

/// Central production feedback gateway. Feature widgets never talk directly to
/// platform haptics or audio players, which keeps motion/audio behavior
/// consistent across every game variant.
class AppFeedbackService implements GameFeedback {
  AppFeedbackService(this._settings);

  final AppSettingsController _settings;
  final AudioPlayer _primary = AudioPlayer(playerId: 'morris-primary');
  final AudioPlayer _accent = AudioPlayer(playerId: 'morris-accent');

  @override
  Future<void> buttonPressed() => _emit(
    asset: 'audio/button.wav',
    volume: 0.42,
    haptic: HapticFeedback.selectionClick,
  );

  @override
  Future<void> pieceSelected() => _emit(
    asset: 'audio/piece_pick.wav',
    volume: 0.50,
    haptic: HapticFeedback.selectionClick,
  );

  /// The settle/drop sound uses the accent player so it can follow a slide
  /// without cutting that slide sample short.
  @override
  Future<void> piecePlaced() => _emit(
    asset: 'audio/piece_drop.wav',
    volume: 0.72,
    haptic: HapticFeedback.lightImpact,
    accent: true,
  );

  @override
  Future<void> pieceMoved() => _emit(
    asset: switch (_settings.state.boardSurface) {
      BoardSurface.wood => 'audio/slide_wood.wav',
      BoardSurface.marble => 'audio/slide_marble.wav',
      BoardSurface.darkStone => 'audio/slide_stone.wav',
      BoardSurface.minimal => 'audio/slide_wood.wav',
    },
    volume: 0.64,
    haptic: HapticFeedback.selectionClick,
  );

  @override
  Future<void> millFormed() => _emit(
    asset: 'audio/mill.wav',
    volume: 0.70,
    haptic: HapticFeedback.mediumImpact,
    accent: true,
  );

  @override
  Future<void> pieceCaptured() => _emit(
    asset: 'audio/capture.wav',
    volume: 0.68,
    haptic: HapticFeedback.lightImpact,
    accent: true,
  );

  @override
  Future<void> success() => _emit(
    asset: 'audio/success.wav',
    volume: 0.72,
    haptic: HapticFeedback.mediumImpact,
    accent: true,
  );

  Future<void> _emit({
    required String asset,
    required double volume,
    Future<void> Function()? haptic,
    bool accent = false,
  }) async {
    if (_settings.state.soundEnabled) {
      final player = accent ? _accent : _primary;
      unawaited(
        player.play(
          AssetSource(asset),
          volume: volume,
          mode: PlayerMode.lowLatency,
        ),
      );
    }
    if (_settings.state.hapticEnabled && haptic != null) {
      await haptic();
    }
  }
}
