import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import '../../app/app_settings_controller.dart';

abstract interface class GameFeedback {
  Future<void> buttonPressed();
  Future<void> pieceSelected();
  Future<void> piecePlaced();
  Future<void> pieceMoved();
  Future<void> millFormed();
  Future<void> pieceCaptured();
  Future<void> success();
}

/// Optional match-level audio lifecycle used by match presentation surfaces.
///
/// Keeping this separate from [GameFeedback] lets controller-only tests and
/// alternate feedback implementations stay lightweight.
abstract interface class MatchLifecycleFeedback {
  Future<void> matchStarting();
  Future<void> matchReady();
  Future<void> matchFinished();
  Future<void> matchClosed();
}

/// Separate match-win sound without forcing lightweight test feedbacks to add
/// match-presentation behavior.
abstract interface class MatchWinFeedback {
  Future<void> matchWon();
}

/// Central production feedback gateway. Feature widgets never talk directly to
/// platform haptics or audio players, which keeps motion/audio behavior
/// consistent across every game variant.
class AppFeedbackService
    implements GameFeedback, MatchLifecycleFeedback, MatchWinFeedback {
  AppFeedbackService(this._settings);

  final AppSettingsController _settings;
  final AudioPlayer _primary = AudioPlayer(playerId: 'morris-primary');
  final AudioPlayer _accent = AudioPlayer(playerId: 'morris-accent');
  final AudioPlayer _matchIntro = AudioPlayer(playerId: 'morris-match-intro');
  final AudioPlayer _matchGong = AudioPlayer(playerId: 'morris-match-gong');
  final AudioPlayer _matchResult = AudioPlayer(playerId: 'morris-match-result');

  @override
  Future<void> matchStarting() async {
    await _stopStartSounds();
    try {
      await _matchResult.stop();
    } catch (_) {
      // A result player that has not started yet has nothing to stop.
    }
    if (!_settings.state.soundEnabled) return;
    try {
      await _matchIntro.play(
        AssetSource('audio/match_start.mp3'),
        volume: 0.54,
        mode: PlayerMode.mediaPlayer,
      );
    } catch (_) {
      // Missing/unsupported audio must not prevent a match from starting.
    }
  }

  @override
  Future<void> matchReady() async {
    try {
      await _matchIntro.stop();
    } catch (_) {
      // A player that has not started yet has nothing to stop.
    }
    if (!_settings.state.soundEnabled) return;
    try {
      await _matchGong.play(
        AssetSource('audio/match_gong.wav'),
        volume: 0.38,
        mode: PlayerMode.lowLatency,
      );
    } catch (_) {
      // The gong is an accent; it must never block the match.
    }
  }

  @override
  Future<void> matchFinished() async {
    await _stopStartSounds();
    if (!_settings.state.soundEnabled) return;
    try {
      await _matchResult.stop();
      await _matchResult.play(
        AssetSource('audio/match_congratulations.mp3'),
        volume: 0.82,
        mode: PlayerMode.mediaPlayer,
      );
    } catch (_) {
      // Result UI remains available if this device cannot play the audio.
    }
  }

  @override
  Future<void> matchWon() async {
    await _stopStartSounds();
    if (!_settings.state.soundEnabled) return;
    try {
      await _matchResult.stop();
      await _matchResult.play(
        AssetSource('audio/match_win.mp3'),
        volume: 0.82,
        mode: PlayerMode.mediaPlayer,
      );
    } catch (_) {
      // Match result remains visible if this device cannot play the audio.
    }
  }

  @override
  Future<void> matchClosed() => _stopStartSounds();

  Future<void> _stopStartSounds() async {
    try {
      await _matchIntro.stop();
    } catch (_) {
      // A player that has not started yet has nothing to stop.
    }
    try {
      await _matchGong.stop();
    } catch (_) {
      // A gong that has not started yet has nothing to stop.
    }
  }

  @override
  Future<void> buttonPressed() => _emit(
    asset: 'audio/button.wav',
    volume: 0.42,
    haptic: HapticFeedback.selectionClick,
  );

  @override
  Future<void> pieceSelected() async {
    if (_settings.state.hapticEnabled) {
      await HapticFeedback.selectionClick();
    }
  }

  /// The settle/drop sound uses the accent player so it can follow a slide
  /// without cutting that slide sample short.
  @override
  Future<void> piecePlaced() => _emit(
    asset: 'audio/stone_place.mp3',
    volume: 0.58,
    haptic: HapticFeedback.lightImpact,
    accent: true,
  );

  @override
  Future<void> pieceMoved() => _emit(
    asset: 'audio/piece_move_swoosh.mp3',
    volume: 0.40,
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
