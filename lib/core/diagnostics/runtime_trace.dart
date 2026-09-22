import 'dart:async';
import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

abstract final class RuntimeTrace {
  static final Stopwatch _clock = Stopwatch()..start();
  static Timer? _heartbeat;
  static bool _installed = false;
  static Duration _lastHeartbeat = Duration.zero;
  static String _phase = 'bootstrap';
  static int _frameCount = 0;
  static int _scenarioId = 0;

  static void install() {
    if (_installed) return;
    _installed = true;
    _lastHeartbeat = _clock.elapsed;
    mark('trace.install');

    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);
    _heartbeat = Timer.periodic(const Duration(milliseconds: 250), (_) {
      final now = _clock.elapsed;
      final gap = now - _lastHeartbeat;
      _lastHeartbeat = now;
      if (gap >= const Duration(milliseconds: 900)) {
        mark(
          'ui_stall.recovered',
          data: <String, Object?>{
            'gap_ms': gap.inMilliseconds,
            'phase': _phase,
            'scenario': _scenarioId,
          },
        );
      }
    });
  }

  static void setPhase(String value) {
    _phase = value;
    mark('phase', data: <String, Object?>{'value': value});
  }

  static void startScenario(
    String name, {
    Map<String, Object?> data = const {},
  }) {
    _scenarioId++;
    _frameCount = 0;
    _phase = name;
    mark(
      'scenario.start',
      data: <String, Object?>{'name': name, 'scenario': _scenarioId, ...data},
    );
  }

  static void mark(String event, {Map<String, Object?> data = const {}}) {
    final payload = <String, Object?>{
      't_ms': _clock.elapsedMilliseconds,
      'event': event,
      'phase': _phase,
      'scenario': _scenarioId,
      ...data,
    };
    // Deliberately use print rather than debugPrint: this diagnostic build must
    // keep the markers visible in Android logcat in profile mode.
    // ignore: avoid_print
    print('MWTRACE ${jsonEncode(payload)}');
  }

  static T measureSync<T>(String name, T Function() action) {
    final sw = Stopwatch()..start();
    try {
      return action();
    } finally {
      sw.stop();
      mark(
        'sync.measure',
        data: <String, Object?>{
          'name': name,
          'duration_ms': sw.elapsedMilliseconds,
        },
      );
    }
  }

  static Future<T> measureAsync<T>(
    String name,
    Future<T> Function() action,
  ) async {
    final sw = Stopwatch()..start();
    try {
      return await action();
    } finally {
      sw.stop();
      mark(
        'async.measure',
        data: <String, Object?>{
          'name': name,
          'duration_ms': sw.elapsedMilliseconds,
        },
      );
    }
  }

  static void firstFrame(String label) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mark('post_frame', data: <String, Object?>{'label': label});
    });
  }

  static void _onFrameTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      _frameCount++;
      final buildMs = timing.buildDuration.inMicroseconds / 1000.0;
      final rasterMs = timing.rasterDuration.inMicroseconds / 1000.0;
      final totalMs = timing.totalSpan.inMicroseconds / 1000.0;
      if (_frameCount <= 12 ||
          totalMs >= 50 ||
          buildMs >= 24 ||
          rasterMs >= 24) {
        mark(
          'frame.timing',
          data: <String, Object?>{
            'frame': _frameCount,
            'build_ms': buildMs.toStringAsFixed(1),
            'raster_ms': rasterMs.toStringAsFixed(1),
            'total_ms': totalMs.toStringAsFixed(1),
          },
        );
      }
    }
  }

  static void disposeForTests() {
    _heartbeat?.cancel();
    _heartbeat = null;
  }
}
