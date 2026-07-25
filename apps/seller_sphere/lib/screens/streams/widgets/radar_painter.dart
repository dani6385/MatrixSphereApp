import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kNeonCyan.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.height * 0.4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
