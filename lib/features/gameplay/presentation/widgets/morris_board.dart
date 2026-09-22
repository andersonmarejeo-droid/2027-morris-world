import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_tokens.dart';
import '../../../../core/diagnostics/runtime_trace.dart';
import '../../../../core/feedback/motion_tokens.dart';
import '../../../../core/game/game_definition.dart';
import '../../../../core/game/game_models.dart';
import '../../../../core/settings/app_settings_models.dart';

/// High-performance Morris board renderer.
///
/// The complete board remains one CustomPainter. Move animation is driven by a
/// single TweenAnimationBuilder keyed by move sequence; there are no per-point
/// tickers, drag targets, or perpetual board animations in the critical path.
class MorrisBoard extends StatelessWidget {
  const MorrisBoard({
    super.key,
    required this.definition,
    required this.board,
    required this.onPointTap,
    this.onMoveDrop,
    this.selectedPoint,
    this.legalTargets = const <int>{},
    this.capturablePoints = const <int>{},
    this.activeMillPoints = const <int>{},
    this.lastMoveFrom,
    this.lastMoveTo,
    this.lastMoveActor,
    this.lastCapturedPoint,
    this.capturedLight = 0,
    this.capturedDark = 0,
    this.moveSequence = 0,
    this.moveDuration = MotionTokens.board,
    this.interactive = true,
    this.reduceMotion = false,
    this.showHints = true,
    this.colorAssist = true,
    this.surface = BoardSurface.wood,
    this.viewStyle = BoardViewStyle.realistic,
    this.pieceTheme = PieceTheme.classic,
    this.semanticLabelBuilder,
  });

  final MorrisGameDefinition definition;
  final Board board;
  final ValueChanged<int> onPointTap;

  /// Kept for API compatibility. Drag is intentionally disabled in the safe
  /// renderer; tap -> tap is faster and fully functional on every device.
  final void Function(int from, int to)? onMoveDrop;
  final int? selectedPoint;
  final Set<int> legalTargets;
  final Set<int> capturablePoints;
  final Set<int> activeMillPoints;
  final int? lastMoveFrom;
  final int? lastMoveTo;
  final PlayerSide? lastMoveActor;
  final int? lastCapturedPoint;
  final int capturedLight;
  final int capturedDark;
  final int moveSequence;
  final Duration moveDuration;
  final bool interactive;
  final bool reduceMotion;
  final bool showHints;
  final bool colorAssist;
  final BoardSurface surface;
  final BoardViewStyle viewStyle;
  final PieceTheme pieceTheme;
  final String Function(int point, PlayerSide? piece)? semanticLabelBuilder;

  @override
  Widget build(BuildContext context) {
    RuntimeTrace.mark(
      'board.build',
      data: <String, Object?>{
        'game': definition.id.name,
        'points': definition.board.pointCount,
        'interactive': interactive,
        'legal_targets': legalTargets.length,
        'capturable': capturablePoints.length,
        'surface': surface.name,
        'view': viewStyle.name,
        'move_sequence': moveSequence,
      },
    );
    final palette = _BoardPalette.forSurface(surface);
    final motionKey = ValueKey<String>(
      '$moveSequence:${lastMoveActor?.name}:${lastMoveFrom ?? -1}:${lastMoveTo ?? -1}:${lastCapturedPoint ?? -1}:$capturedLight:$capturedDark',
    );

    Widget boardWidget = RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.large),
          gradient: palette.background,
          border: Border.all(color: palette.border),
          boxShadow:
              viewStyle == BoardViewStyle.flat2d
                  ? const <BoxShadow>[]
                  : [
                    BoxShadow(
                      blurRadius:
                          viewStyle == BoardViewStyle.perspective3d ? 22 : 16,
                      color: Colors.black.withValues(alpha: 0.18),
                      offset: Offset(
                        0,
                        viewStyle == BoardViewStyle.perspective3d ? 10 : 7,
                      ),
                    ),
                  ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.large),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest.shortestSide;
              return Semantics(
                container: true,
                label:
                    semanticLabelBuilder == null
                        ? null
                        : _boardSemanticSummary(),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp:
                      interactive
                          ? (details) {
                            final point = _nearestPoint(
                              details.localPosition,
                              size,
                            );
                            if (point != null) {
                              onPointTap(point);
                            }
                          }
                          : null,
                  child: TweenAnimationBuilder<double>(
                    key: motionKey,
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: reduceMotion ? Duration.zero : moveDuration,
                    curve: MotionTokens.curve,
                    builder:
                        (context, progress, _) => CustomPaint(
                          size: Size.square(size),
                          painter: _MorrisBoardPainter(
                            definition: definition,
                            board: board,
                            selectedPoint: selectedPoint,
                            legalTargets:
                                showHints ? legalTargets : const <int>{},
                            capturablePoints: capturablePoints,
                            activeMillPoints: activeMillPoints,
                            lastMoveFrom: lastMoveFrom,
                            lastMoveTo: lastMoveTo,
                            lastMoveActor: lastMoveActor,
                            lastCapturedPoint: lastCapturedPoint,
                            capturedLight: capturedLight,
                            capturedDark: capturedDark,
                            motionProgress: progress,
                            colorAssist: colorAssist,
                            pieceTheme: pieceTheme,
                            surface: surface,
                            palette: palette,
                          ),
                        ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    if (viewStyle == BoardViewStyle.perspective3d) {
      boardWidget = Transform(
        alignment: Alignment.center,
        transform:
            Matrix4.identity()
              ..setEntry(3, 2, 0.0008)
              ..rotateX(-0.035),
        child: boardWidget,
      );
    }

    return AspectRatio(aspectRatio: 1, child: boardWidget);
  }

  int? _nearestPoint(Offset tap, double size) {
    if (size <= 0) {
      return null;
    }
    const paddingFactor = _MorrisBoardPainter.boardPaddingFactor;
    final usable = size * (1 - paddingFactor * 2);
    final threshold =
        math.max(AppConstraints.minTapTarget / 2, size * 0.07).toDouble();

    var bestIndex = -1;
    var bestDistance = double.infinity;
    for (var i = 0; i < definition.board.pointCount; i++) {
      final normalized = definition.board.normalizedPoints[i];
      final center = Offset(
        size * paddingFactor + usable * normalized.dx / 6,
        size * paddingFactor + usable * normalized.dy / 6,
      );
      final distance = (tap - center).distance;
      if (distance < bestDistance) {
        bestDistance = distance;
        bestIndex = i;
      }
    }
    return bestDistance <= threshold ? bestIndex : null;
  }

  String _boardSemanticSummary() {
    final builder = semanticLabelBuilder;
    if (builder == null) {
      return '';
    }
    final parts = <String>[];
    for (var i = 0; i < definition.board.pointCount; i++) {
      parts.add(builder(i, board[i]));
    }
    return parts.join(', ');
  }
}

class _MorrisBoardPainter extends CustomPainter {
  const _MorrisBoardPainter({
    required this.definition,
    required this.board,
    required this.selectedPoint,
    required this.legalTargets,
    required this.capturablePoints,
    required this.activeMillPoints,
    required this.lastMoveFrom,
    required this.lastMoveTo,
    required this.lastMoveActor,
    required this.lastCapturedPoint,
    required this.capturedLight,
    required this.capturedDark,
    required this.motionProgress,
    required this.colorAssist,
    required this.pieceTheme,
    required this.surface,
    required this.palette,
  });

  static const boardPaddingFactor = 0.09;

  final MorrisGameDefinition definition;
  final Board board;
  final int? selectedPoint;
  final Set<int> legalTargets;
  final Set<int> capturablePoints;
  final Set<int> activeMillPoints;
  final int? lastMoveFrom;
  final int? lastMoveTo;
  final PlayerSide? lastMoveActor;
  final int? lastCapturedPoint;
  final int capturedLight;
  final int capturedDark;
  final double motionProgress;
  final bool colorAssist;
  final PieceTheme pieceTheme;
  final BoardSurface surface;
  final _BoardPalette palette;

  bool get _motionActive =>
      lastCapturedPoint == null &&
      lastMoveTo != null &&
      lastMoveActor != null &&
      motionProgress < 0.999;

  bool get _captureMotionActive =>
      lastCapturedPoint != null &&
      lastMoveActor != null &&
      motionProgress < 0.999;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    if (side <= 0) {
      return;
    }

    final centers = List<Offset>.generate(
      definition.board.pointCount,
      (index) => _point(index, side),
      growable: false,
    );

    _drawMaterialDetail(canvas, side);
    _drawLines(canvas, side, centers);
    _drawNodes(canvas, side, centers);
    _drawHints(canvas, side, centers);
    _drawCapturedTrays(canvas, side);
    _drawPieces(canvas, side, centers);
    _drawMovingPiece(canvas, side, centers);
    _drawCapturedPieceMotion(canvas, side, centers);
  }

  Offset _point(int index, double side) {
    final normalized = definition.board.normalizedPoints[index];
    final pad = side * boardPaddingFactor;
    final usable = side - pad * 2;
    return Offset(
      pad + usable * normalized.dx / 6,
      pad + usable * normalized.dy / 6,
    );
  }

  void _drawMaterialDetail(Canvas canvas, double side) {
    if (surface == BoardSurface.wood) {
      final grain =
          Paint()
            ..color = const Color(0xFF5F3B28).withValues(alpha: 0.11)
            ..strokeWidth = math.max(0.7, side * 0.0025).toDouble()
            ..strokeCap = StrokeCap.round;
      for (var i = 0; i < 9; i++) {
        final y = side * (0.10 + i * 0.095);
        final wobble = math.sin(i * 1.7) * side * 0.012;
        final path =
            Path()
              ..moveTo(side * 0.04, y)
              ..cubicTo(
                side * 0.28,
                y + wobble,
                side * 0.63,
                y - wobble * 0.7,
                side * 0.96,
                y + wobble * 0.25,
              );
        canvas.drawPath(path, grain);
      }
    } else if (surface == BoardSurface.marble) {
      final vein =
          Paint()
            ..color = const Color(0xFF8F8A80).withValues(alpha: 0.10)
            ..strokeWidth = math.max(0.6, side * 0.002).toDouble()
            ..style = PaintingStyle.stroke;
      for (var i = 0; i < 5; i++) {
        final offset = side * (0.08 + i * 0.18);
        final path =
            Path()
              ..moveTo(0, offset)
              ..quadraticBezierTo(
                side * 0.42,
                offset + side * 0.08,
                side,
                offset - side * 0.025,
              );
        canvas.drawPath(path, vein);
      }
    }
  }

  void _drawCapturedTrays(Canvas canvas, double side) {
    final lightOnTray =
        math
            .max(
              0,
              capturedLight -
                  (_captureMotionActive && lastMoveActor == PlayerSide.dark
                      ? 1
                      : 0),
            )
            .toInt();
    final darkOnTray =
        math
            .max(
              0,
              capturedDark -
                  (_captureMotionActive && lastMoveActor == PlayerSide.light
                      ? 1
                      : 0),
            )
            .toInt();
    _drawCapturedStack(
      canvas,
      side: side,
      pieceSide: PlayerSide.light,
      count: lightOnTray,
      left: true,
    );
    _drawCapturedStack(
      canvas,
      side: side,
      pieceSide: PlayerSide.dark,
      count: darkOnTray,
      left: false,
    );
  }

  void _drawCapturedStack(
    Canvas canvas, {
    required double side,
    required PlayerSide pieceSide,
    required int count,
    required bool left,
  }) {
    if (count <= 0) {
      return;
    }
    final radius = side * 0.021;
    final x = left ? side * 0.031 : side * 0.969;
    final baseY = side * 0.35;
    final step = radius * 1.05;
    for (var i = 0; i < count; i++) {
      final center = Offset(x, baseY + i * step);
      _drawPiece(
        canvas,
        center: center,
        radius: radius,
        side: pieceSide,
        selected: false,
        tray: true,
      );
    }
  }

  void _drawLines(Canvas canvas, double side, List<Offset> centers) {
    final paint =
        Paint()
          ..color = palette.line
          ..strokeWidth = side * 0.0105
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final drawn = <int>{};
    for (final entry in definition.board.adjacency.entries) {
      for (final target in entry.value) {
        final a = math.min(entry.key, target);
        final b = math.max(entry.key, target);
        final key = a * 100 + b;
        if (drawn.add(key)) {
          canvas.drawLine(centers[a], centers[b], paint);
        }
      }
    }
  }

  void _drawNodes(Canvas canvas, double side, List<Offset> centers) {
    final paint =
        Paint()
          ..color = palette.node
          ..style = PaintingStyle.fill;
    final radius = math.max(1.8, side * 0.0085).toDouble();
    for (final center in centers) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  void _drawHints(Canvas canvas, double side, List<Offset> centers) {
    final pieceRadius = side * 0.044;

    for (final index in legalTargets) {
      if (index < 0 || index >= centers.length) {
        continue;
      }
      final center = centers[index];
      final fill =
          Paint()
            ..color = AppColors.target.withValues(alpha: 0.14)
            ..style = PaintingStyle.fill;
      final stroke =
          Paint()
            ..color = AppColors.target.withValues(alpha: 0.82)
            ..style = PaintingStyle.stroke
            ..strokeWidth = math.max(1.8, side * 0.006).toDouble();
      canvas.drawCircle(center, pieceRadius * 0.78, fill);
      canvas.drawCircle(center, pieceRadius * 0.78, stroke);
    }

    for (final index in capturablePoints) {
      if (index < 0 || index >= centers.length) {
        continue;
      }
      final stroke =
          Paint()
            ..color = AppColors.danger.withValues(alpha: 0.88)
            ..style = PaintingStyle.stroke
            ..strokeWidth = math.max(2.0, side * 0.007).toDouble();
      canvas.drawCircle(centers[index], pieceRadius * 1.18, stroke);
    }

    for (final index in activeMillPoints) {
      if (index < 0 || index >= centers.length) {
        continue;
      }
      final stroke =
          Paint()
            ..color = AppColors.selection.withValues(alpha: 0.72)
            ..style = PaintingStyle.stroke
            ..strokeWidth = math.max(1.8, side * 0.006).toDouble();
      canvas.drawCircle(centers[index], pieceRadius * 1.25, stroke);
    }

    final fromIndex = lastMoveFrom;
    if (fromIndex != null && fromIndex >= 0 && fromIndex < centers.length) {
      final stroke =
          Paint()
            ..color = AppColors.brandDeep.withValues(alpha: 0.35)
            ..style = PaintingStyle.stroke
            ..strokeWidth = math.max(1.2, side * 0.004).toDouble();
      canvas.drawCircle(centers[fromIndex], pieceRadius * 0.72, stroke);
    }

    final toIndex = lastMoveTo;
    if (toIndex != null && toIndex >= 0 && toIndex < centers.length) {
      final stroke =
          Paint()
            ..color = AppColors.brandDeep.withValues(alpha: 0.70)
            ..style = PaintingStyle.stroke
            ..strokeWidth = math.max(1.8, side * 0.006).toDouble();
      canvas.drawCircle(centers[toIndex], pieceRadius * 1.22, stroke);
    }

    final capturedIndex = lastCapturedPoint;
    if (capturedIndex != null &&
        capturedIndex >= 0 &&
        capturedIndex < centers.length &&
        board[capturedIndex] == null) {
      final paint =
          Paint()
            ..color = AppColors.danger.withValues(alpha: 0.52)
            ..strokeWidth = math.max(1.8, side * 0.006).toDouble()
            ..strokeCap = StrokeCap.round;
      final center = centers[capturedIndex];
      final r = pieceRadius * 0.38;
      canvas.drawLine(center + Offset(-r, -r), center + Offset(r, r), paint);
      canvas.drawLine(center + Offset(r, -r), center + Offset(-r, r), paint);
    }
  }

  void _drawPieces(Canvas canvas, double side, List<Offset> centers) {
    final pieceRadius = side * 0.044;
    for (var i = 0; i < board.length; i++) {
      final piece = board[i];
      if (piece == null) {
        continue;
      }
      if (_motionActive && i == lastMoveTo && piece == lastMoveActor) {
        continue;
      }
      _drawPiece(
        canvas,
        center: centers[i],
        radius: pieceRadius,
        side: piece,
        selected: selectedPoint == i,
      );
    }
  }

  void _drawMovingPiece(Canvas canvas, double side, List<Offset> centers) {
    if (!_motionActive) {
      return;
    }
    final actor = lastMoveActor!;
    final to = lastMoveTo!;
    if (to < 0 || to >= centers.length) {
      return;
    }

    final pieceRadius = side * 0.044;
    final end = centers[to];
    final from = lastMoveFrom;
    final start =
        from != null && from >= 0 && from < centers.length
            ? centers[from]
            : actor == PlayerSide.dark
            ? Offset(side / 2, -pieceRadius * 1.8)
            : Offset(side / 2, side + pieceRadius * 1.8);

    final eased = Curves.easeInOutCubic.transform(motionProgress);
    final center = Offset.lerp(start, end, eased)!;
    const scale = 1.0;

    final shadow =
        Paint()
          ..color = Colors.black.withValues(
            alpha: 0.14 * (1 - motionProgress * 0.4),
          )
          ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, pieceRadius * 0.38),
        width: pieceRadius * 1.5,
        height: pieceRadius * 0.52,
      ),
      shadow,
    );

    _drawPiece(
      canvas,
      center: center,
      radius: pieceRadius * scale,
      side: actor,
      selected: false,
      lifted: true,
    );
  }

  void _drawCapturedPieceMotion(
    Canvas canvas,
    double side,
    List<Offset> centers,
  ) {
    if (!_captureMotionActive) {
      return;
    }
    final capturedPoint = lastCapturedPoint!;
    if (capturedPoint < 0 || capturedPoint >= centers.length) {
      return;
    }
    final capturedSide = lastMoveActor!.opponent;
    final finalCount =
        capturedSide == PlayerSide.light ? capturedLight : capturedDark;
    final radius = side * 0.040;
    final start = centers[capturedPoint];
    final left = capturedSide == PlayerSide.light;
    final trayRadius = side * 0.021;
    final end = Offset(
      left ? side * 0.031 : side * 0.969,
      side * 0.35 + math.max(0, finalCount - 1).toDouble() * trayRadius * 1.05,
    );
    final eased = Curves.easeInOutCubic.transform(motionProgress);
    final straight = Offset.lerp(start, end, eased)!;
    final lift = math.sin(math.pi * eased) * side * 0.035;
    final center = Offset(straight.dx, straight.dy - lift);
    _drawPiece(
      canvas,
      center: center,
      radius: radius * (1 - eased * 0.22),
      side: capturedSide,
      selected: false,
      lifted: true,
    );
  }

  void _drawPiece(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required PlayerSide side,
    required bool selected,
    bool lifted = false,
    bool tray = false,
  }) {
    if (selected || lifted) {
      final halo =
          Paint()
            ..color = (selected ? AppColors.selection : AppColors.brandDeep)
                .withValues(alpha: selected ? 0.42 : 0.16)
            ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius * (selected ? 1.30 : 1.18), halo);
    }

    final shadow =
        Paint()
          ..color = Colors.black.withValues(alpha: tray ? 0.10 : 0.22)
          ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, radius * (tray ? 0.18 : 0.30)),
        width: radius * 1.72,
        height: radius * (tray ? 0.58 : 0.70),
      ),
      shadow,
    );

    final rect = Rect.fromCircle(center: center, radius: radius);
    final colors = _pieceColors(side, pieceTheme);
    final fill =
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.38, -0.46),
            radius: 0.98,
            colors: colors,
            stops:
                colors.length == 3 ? const [0.0, 0.58, 1.0] : const [0.0, 1.0],
          ).createShader(rect)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fill);

    final rim =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.1, radius * 0.13).toDouble()
          ..color =
              side == PlayerSide.light
                  ? const Color(0xFF8D887E).withValues(alpha: 0.62)
                  : const Color(0xFF000000).withValues(alpha: 0.78);
    canvas.drawCircle(center, radius * 0.88, rim);

    final highlight =
        Paint()
          ..color = Colors.white.withValues(
            alpha: side == PlayerSide.light ? 0.62 : 0.24,
          )
          ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(-radius * 0.28, -radius * 0.32),
        width: radius * 0.52,
        height: radius * 0.24,
      ),
      highlight,
    );

    final border =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 3.0 : 1.2
          ..color =
              selected
                  ? AppColors.selection
                  : colorAssist
                  ? (side == PlayerSide.light
                      ? const Color(0xFF706C65)
                      : const Color(0xFFECEAE3))
                  : Colors.black.withValues(alpha: 0.20);
    canvas.drawCircle(center, radius, border);
  }

  List<Color> _pieceColors(PlayerSide side, PieceTheme theme) {
    return switch ((side, theme)) {
      (PlayerSide.light, PieceTheme.classic) => const [
        Color(0xFFFFFFFF),
        Color(0xFFC8C5BF),
      ],
      (PlayerSide.dark, PieceTheme.classic) => const [
        Color(0xFF55524E),
        Color(0xFF090909),
      ],
      (PlayerSide.light, PieceTheme.marble) => const [
        Color(0xFFFFFEFB),
        Color(0xFFD9D3C7),
        Color(0xFFF4F0E9),
      ],
      (PlayerSide.dark, PieceTheme.marble) => const [
        Color(0xFF4F5559),
        Color(0xFF1B2023),
        Color(0xFF363B3E),
      ],
      (PlayerSide.light, PieceTheme.obsidian) => const [
        Color(0xFFF5F8FA),
        Color(0xFFBFC8CE),
      ],
      (PlayerSide.dark, PieceTheme.obsidian) => const [
        Color(0xFF303339),
        Color(0xFF030405),
      ],
    };
  }

  @override
  bool shouldRepaint(covariant _MorrisBoardPainter oldDelegate) {
    return oldDelegate.board != board ||
        oldDelegate.selectedPoint != selectedPoint ||
        oldDelegate.legalTargets != legalTargets ||
        oldDelegate.capturablePoints != capturablePoints ||
        oldDelegate.activeMillPoints != activeMillPoints ||
        oldDelegate.lastMoveFrom != lastMoveFrom ||
        oldDelegate.lastMoveTo != lastMoveTo ||
        oldDelegate.lastMoveActor != lastMoveActor ||
        oldDelegate.lastCapturedPoint != lastCapturedPoint ||
        oldDelegate.capturedLight != capturedLight ||
        oldDelegate.capturedDark != capturedDark ||
        oldDelegate.motionProgress != motionProgress ||
        oldDelegate.colorAssist != colorAssist ||
        oldDelegate.pieceTheme != pieceTheme ||
        oldDelegate.surface != surface ||
        oldDelegate.palette != palette;
  }
}

class _BoardPalette {
  const _BoardPalette({
    required this.background,
    required this.border,
    required this.line,
    required this.node,
  });

  final Gradient background;
  final Color border;
  final Color line;
  final Color node;

  static const _wood = _BoardPalette(
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.woodLight, AppColors.wood, AppColors.woodDark],
    ),
    border: Color(0xFF6F482F),
    line: Color(0xFF4A2E1F),
    node: Color(0xFF332016),
  );

  static const _stone = _BoardPalette(
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4C5357), AppColors.stoneDark],
    ),
    border: Color(0xFF202427),
    line: Color(0xFFD8DCDE),
    node: Color(0xFFF1F3F4),
  );

  static const _marble = _BoardPalette(
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF8F5EC), AppColors.marble, Color(0xFFDAD5CA)],
    ),
    border: Color(0xFFC9C3B8),
    line: Color(0xFF5B5852),
    node: Color(0xFF393733),
  );

  static const _minimal = _BoardPalette(
    background: LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFF4F6F7)]),
    border: AppColors.line,
    line: AppColors.ink,
    node: AppColors.ink,
  );

  static _BoardPalette forSurface(BoardSurface surface) => switch (surface) {
    BoardSurface.wood => _wood,
    BoardSurface.darkStone => _stone,
    BoardSurface.marble => _marble,
    BoardSurface.minimal => _minimal,
  };
}
