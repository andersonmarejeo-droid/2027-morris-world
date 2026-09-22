import 'package:flutter/animation.dart';

abstract final class MotionTokens {
  static const instant = Duration(milliseconds: 80);
  static const fast = Duration(milliseconds: 120);
  static const normal = Duration(milliseconds: 200);
  static const board = Duration(milliseconds: 240);
  static const slow = Duration(milliseconds: 320);
  static const celebration = Duration(milliseconds: 650);
  static const reservePulse = Duration(milliseconds: 760);
  static const curve = Curves.easeOutCubic;
  static const settleCurve = Curves.easeOutBack;
}
