import 'dart:math';

import 'package:flutter/material.dart';

/// Paints a shadow animating to a target position
class BackShadowPainter extends CustomPainter {
  /// The progress of the animation
  final double progress;

  /// The position that this painter will be animating to
  final Rect target;

  /// The color for the shadow
  final Color shadowColor;

  /// The opacity for the shadow
  final double shadowOpactiy;

  /// Creates a new [BackShadowPainter]
  BackShadowPainter({
    required this.progress,
    required this.target,
    this.shadowColor = Colors.black,
    this.shadowOpactiy = 0.8,
  }) : assert(shadowOpactiy >= 0 && shadowOpactiy <= 1);

  static Path _drawRRectHole(
    Size canvasSize,
    double x,
    double y,
    double w,
    double h,
    double radius,
  ) {
    final diameter = radius * 2;

    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, y + radius)
      ..arcTo(
        Rect.fromLTWH(x, y, diameter, diameter),
        pi,
        pi / 2,
        false,
      )
      ..arcTo(
        Rect.fromLTWH(x + w - diameter, y, diameter, diameter),
        3 * pi / 2,
        pi / 2,
        false,
      )
      ..arcTo(
        Rect.fromLTWH(x + w - diameter, y + h - diameter, diameter, diameter),
        0,
        pi / 2,
        false,
      )
      ..arcTo(
        Rect.fromLTWH(x, y + h - diameter, diameter, diameter),
        pi / 2,
        pi / 2,
        false,
      )
      ..lineTo(x, y + radius)
      ..lineTo(0, y + radius)
      ..lineTo(0, canvasSize.height)
      ..lineTo(canvasSize.width, canvasSize.height)
      ..lineTo(canvasSize.width, 0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (target.center == Offset.zero) return;

    var maxSize = max(size.width, size.height);

    final xCenter = target.center.dx + target.size.width / 2;
    final yCenter = target.center.dy + target.size.height / 2;

    final x = -maxSize / 2 * (1 - progress) + xCenter;

    final y = -maxSize / 2 * (1 - progress) + yCenter;

    final w = maxSize * (1 - progress);

    final h = maxSize * (1 - progress);

    canvas.drawPath(
      _drawRRectHole(size, x, y, w, h, 10.0),
      Paint()
        ..style = PaintingStyle.fill
        ..color = shadowColor.withOpacity(shadowOpactiy),
    );
  }

  @override
  bool shouldRepaint(BackShadowPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
