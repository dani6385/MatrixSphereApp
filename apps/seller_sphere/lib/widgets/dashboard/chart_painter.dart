import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartPainter extends CustomPainter {
  final List<double> data;
  final int selectedIndex;

  ChartPainter({required this.data, required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.reduce(max) > 0 ? data.reduce(max) : 1;
    final barPaint = Paint();
    final selectedBarPaint = Paint()..color = const Color(0xFF00FFFF);
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;
    
    final double barWidth = 18.0;
    final double barSpacing = (size.width - (data.length * barWidth)) / (data.length);
    final double startX = barSpacing / 2;

    const double bottomPadding = 20.0;
    final double chartHeight = size.height - bottomPadding;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = chartHeight - (i / 4.0) * chartHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    
    for (int i = 0; i < data.length; i++) {
      final barHeight = data[i] / maxValue * chartHeight;
      final left = startX + i * (barWidth + barSpacing);
      
      final rect = Rect.fromLTWH(left, chartHeight - barHeight, barWidth, barHeight);
      
      if (i == selectedIndex) {
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(5)), selectedBarPaint);
      } else {
        barPaint.shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF334155),
            const Color(0xFF1E293B),
          ],
        ).createShader(rect);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(5)), barPaint);
      }
      
      // Draw day label
      final dayText = DateFormat('E', 'id_ID').format(DateTime.now().subtract(Duration(days: 6 - i)));
      final textSpan = TextSpan(
        text: dayText,
        style: TextStyle(
            color: i == selectedIndex ? Colors.white : Colors.grey,
            fontSize: 12),
      );
      final textPainter = TextPainter(
        text: textSpan,
              );
      textPainter.layout();
      textPainter.paint(canvas, Offset(rect.center.dx - textPainter.width / 2, size.height - textPainter.height));
    }
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.selectedIndex != selectedIndex;
  }
}
