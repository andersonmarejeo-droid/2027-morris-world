import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_services_scope.dart';

class BrandIntroGate extends StatefulWidget {
  const BrandIntroGate({super.key, required this.child});

  final Widget child;

  @override
  State<BrandIntroGate> createState() => _BrandIntroGateState();
}

class _BrandIntroGateState extends State<BrandIntroGate>
    with SingleTickerProviderStateMixin {
  static const _introDuration = Duration(milliseconds: 3150);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _introDuration,
  );

  bool _showIntro = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.forward().whenComplete(() {
        if (mounted) setState(() => _showIntro = false);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations == true ||
        AppServicesScope.of(context).settings.state.reduceMotion;

    if (!_showIntro || reduceMotion) {
      return widget.child;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_showIntro)
          Positioned.fill(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Semantics(
                label: '9 Taş',
                child: AbsorbPointer(
                  child: ExcludeSemantics(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder:
                          (context, _) =>
                              _BrandIntroScene(progress: _controller.value),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BrandIntroScene extends StatelessWidget {
  const _BrandIntroScene({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final fadeOut =
        progress <= 0.84
            ? 1.0
            : (1 - ((progress - 0.84) / 0.16)).clamp(0.0, 1.0);
    final boardIn = Curves.easeOutCubic.transform(
      (progress / 0.22).clamp(0.0, 1.0),
    );
    final brandIn = Curves.easeOutCubic.transform(
      ((progress - 0.25) / 0.36).clamp(0.0, 1.0),
    );

    return Opacity(
      opacity: fadeOut,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFDFEFE), AppColors.brandSoft],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final boardSize =
                  math.min(width * 0.70, height * 0.42).toDouble();
              final boardLeft = (width - boardSize) / 2;
              final boardTop = height * 0.24;
              final boardRect = Rect.fromLTWH(
                boardLeft,
                boardTop,
                boardSize,
                boardSize,
              );

              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0, -0.08),
                            radius: 0.72,
                            colors: [
                              Colors.white.withValues(alpha: 0.78),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.94 + (0.06 * boardIn),
                    child: Opacity(
                      opacity: boardIn,
                      child: CustomPaint(
                        painter: _MorrisBoardPainter(boardRect: boardRect),
                      ),
                    ),
                  ),
                  ..._stones.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stone = entry.value;
                    final start = 0.10 + (index * 0.047);
                    final end = math.min(0.70, start + 0.34).toDouble();
                    final fall = Curves.easeOutBack.transform(
                      _interval(progress, start, end),
                    );
                    final target = _boardPoint(boardRect, stone.pointIndex);
                    final startX = target.dx + (stone.startShift * boardSize);
                    final startY = -boardSize * (0.18 + stone.startHeight);
                    final x = _lerp(startX, target.dx, fall);
                    final y = _lerp(startY, target.dy, fall);
                    final radius = boardSize * 0.037;
                    final trailOpacity = (1 - fall).clamp(0.0, 0.42).toDouble();

                    return Positioned(
                      left: x - radius,
                      top: y - radius - (radius * 3.2),
                      width: radius * 2,
                      height: radius * 5.2,
                      child: Column(
                        children: [
                          Expanded(
                            child: Opacity(
                              opacity: trailOpacity,
                              child: Container(
                                width: radius * 0.48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      stone.isDark
                                          ? Colors.black.withValues(alpha: 0.18)
                                          : Colors.black.withValues(
                                            alpha: 0.09,
                                          ),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(radius),
                                ),
                              ),
                            ),
                          ),
                          _StoneDisc(radius: radius, isDark: stone.isDark),
                        ],
                      ),
                    );
                  }),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: height * 0.12,
                    child: Center(
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: brandIn,
                          child: const _BrandWordmark(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static double _interval(double value, double start, double end) {
    if (value <= start) return 0;
    if (value >= end) return 1;
    return (value - start) / (end - start);
  }

  static double _lerp(double a, double b, double t) => a + ((b - a) * t);
}

class _BrandWordmark extends StatelessWidget {
  const _BrandWordmark();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '3-9-12',
            style: TextStyle(
              color: AppColors.brandTop,
              fontSize: 36,
              height: 0.9,
              fontWeight: FontWeight.w900,
              letterSpacing: 4.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 20, height: 2, color: AppColors.zpOrange),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 9),
                child: Text(
                  'TAŞ',
                  style: TextStyle(
                    color: AppColors.zpOrange,
                    fontSize: 13,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.7,
                  ),
                ),
              ),
              Container(width: 20, height: 2, color: AppColors.zpOrange),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'ZP GAMES',
            style: TextStyle(
              color: AppColors.inkMuted,
              fontSize: 10,
              height: 1,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoneDisc extends StatelessWidget {
  const _StoneDisc({required this.radius, required this.isDark});

  final double radius;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final light = isDark ? const Color(0xFF353535) : const Color(0xFFFFFFFF);
    final dark = isDark ? const Color(0xFF050505) : const Color(0xFFD8D6D1);
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.45),
          radius: 0.92,
          colors: [light, dark],
        ),
        border: Border.all(
          color: isDark ? Colors.black54 : const Color(0xFFE7E5E0),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: radius * 0.52,
            offset: Offset(0, radius * 0.30),
          ),
        ],
      ),
    );
  }
}

class _MorrisBoardPainter extends CustomPainter {
  const _MorrisBoardPainter({required this.boardRect});

  final Rect boardRect;

  @override
  void paint(Canvas canvas, Size size) {
    final line =
        Paint()
          ..color = AppColors.brandTop
          ..strokeWidth = math.max(2.2, boardRect.width * 0.007).toDouble()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final dot =
        Paint()
          ..color = AppColors.brandDeep
          ..style = PaintingStyle.fill;

    final inset1 = boardRect.width * 0.18;
    final inset2 = boardRect.width * 0.36;
    final squares = [
      boardRect,
      boardRect.deflate(inset1),
      boardRect.deflate(inset2),
    ];

    for (final square in squares) {
      canvas.drawRect(square, line);
    }

    final c = boardRect.center;
    final left = boardRect.left;
    final right = boardRect.right;
    final top = boardRect.top;
    final bottom = boardRect.bottom;
    final inner = squares[2];

    canvas.drawLine(Offset(c.dx, top), Offset(c.dx, inner.top), line);
    canvas.drawLine(Offset(c.dx, inner.bottom), Offset(c.dx, bottom), line);
    canvas.drawLine(Offset(left, c.dy), Offset(inner.left, c.dy), line);
    canvas.drawLine(Offset(inner.right, c.dy), Offset(right, c.dy), line);

    final radius = boardRect.width * 0.017;
    for (var i = 0; i < 24; i++) {
      canvas.drawCircle(_boardPoint(boardRect, i), radius, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _MorrisBoardPainter oldDelegate) =>
      oldDelegate.boardRect != boardRect;
}

class _IntroStone {
  const _IntroStone({
    required this.pointIndex,
    required this.isDark,
    required this.startShift,
    required this.startHeight,
  });

  final int pointIndex;
  final bool isDark;
  final double startShift;
  final double startHeight;
}

const _stones = <_IntroStone>[
  _IntroStone(
    pointIndex: 0,
    isDark: false,
    startShift: -0.18,
    startHeight: 0.10,
  ),
  _IntroStone(
    pointIndex: 1,
    isDark: true,
    startShift: -0.04,
    startHeight: 0.24,
  ),
  _IntroStone(
    pointIndex: 9,
    isDark: false,
    startShift: 0.11,
    startHeight: 0.14,
  ),
  _IntroStone(
    pointIndex: 14,
    isDark: true,
    startShift: 0.18,
    startHeight: 0.28,
  ),
  _IntroStone(
    pointIndex: 3,
    isDark: true,
    startShift: -0.12,
    startHeight: 0.18,
  ),
  _IntroStone(
    pointIndex: 5,
    isDark: false,
    startShift: 0.15,
    startHeight: 0.08,
  ),
  _IntroStone(
    pointIndex: 17,
    isDark: true,
    startShift: -0.08,
    startHeight: 0.30,
  ),
  _IntroStone(
    pointIndex: 20,
    isDark: false,
    startShift: 0.08,
    startHeight: 0.20,
  ),
];

Offset _boardPoint(Rect rect, int index) {
  final x0 = rect.left;
  final x1 = rect.left + rect.width * 0.18;
  final x2 = rect.left + rect.width * 0.36;
  final x3 = rect.center.dx;
  final x4 = rect.right - rect.width * 0.36;
  final x5 = rect.right - rect.width * 0.18;
  final x6 = rect.right;
  final y0 = rect.top;
  final y1 = rect.top + rect.height * 0.18;
  final y2 = rect.top + rect.height * 0.36;
  final y3 = rect.center.dy;
  final y4 = rect.bottom - rect.height * 0.36;
  final y5 = rect.bottom - rect.height * 0.18;
  final y6 = rect.bottom;

  const points = <List<int>>[
    [0, 0],
    [3, 0],
    [6, 0],
    [0, 3],
    [6, 3],
    [0, 6],
    [3, 6],
    [6, 6],
    [1, 1],
    [3, 1],
    [5, 1],
    [1, 3],
    [5, 3],
    [1, 5],
    [3, 5],
    [5, 5],
    [2, 2],
    [3, 2],
    [4, 2],
    [2, 3],
    [4, 3],
    [2, 4],
    [3, 4],
    [4, 4],
  ];
  final xs = [x0, x1, x2, x3, x4, x5, x6];
  final ys = [y0, y1, y2, y3, y4, y5, y6];
  final p = points[index];
  return Offset(xs[p[0]], ys[p[1]]);
}
