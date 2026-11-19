import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A brief, lightweight confetti burst for a winning result.
class MatchConfetti extends StatefulWidget {
  const MatchConfetti({super.key});

  @override
  State<MatchConfetti> createState() => _MatchConfettiState();
}

class _MatchConfettiState extends State<MatchConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder:
            (context, _) => CustomPaint(
              painter: _MatchConfettiPainter(progress: _controller.value),
              size: Size.infinite,
            ),
      ),
    ),
  );
}

class _MatchConfettiPainter extends CustomPainter {
  const _MatchConfettiPainter({required this.progress});

  final double progress;

  static const _colors = <Color>[
    Color(0xFFE64A3B),
    Color(0xFF1976D2),
    Color(0xFFFFC247),
    Color(0xFF159A83),
    Color(0xFF7149C6),
    Color(0xFFFFF5DF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final paint = Paint()..style = PaintingStyle.fill;

    for (var index = 0; index < 54; index++) {
      final startDelay = (index % 9) * 0.018;
      if (progress < startDelay) continue;
      final travel = ((progress - startDelay) / (1 - startDelay)).clamp(
        0.0,
        1.0,
      );
      final startX = _unit(index + 7) * size.width;
      final drift = math.sin((travel * 2.8) + index) * size.width * 0.028;
      final x = startX + drift;
      final y = -size.height * 0.12 + travel * size.height * 1.25;
      if (y > size.height + 18) continue;

      final width = 4.5 + (_unit(index + 61) * 3.5);
      final height = 7 + (_unit(index + 113) * 5);
      final rotation = (travel * 7.5) + (index * 0.81);
      final opacity = (1 - (travel * 0.42)).clamp(0.0, 1.0);
      paint.color = _colors[index % _colors.length].withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: width, height: height),
          const Radius.circular(1.8),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  double _unit(int seed) {
    final value = math.sin(seed * 78.233) * 43758.5453;
    return value - value.floorToDouble();
  }

  @override
  bool shouldRepaint(_MatchConfettiPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
