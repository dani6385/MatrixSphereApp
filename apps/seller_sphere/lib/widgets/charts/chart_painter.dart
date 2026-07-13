
import 'package:flutter/material.dart';
import '../../models/day_order_stats.dart';
import '../../utils/triple.dart';

const Color warmOrange = Color(0xFFFFA726);
const Color softTeal = Color(0xFF4DB6AC);

class WeeklyChartPainter extends CustomPainter {
  final List<Triple<String, String, DayOrderStats>> daysData;
  final int maxOrders;
  final int selectedIndex;

  WeeklyChartPainter({
    required this.daysData,
    required this.maxOrders,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final colWidth = size.width / 7;
    const topPadding = 20.0;
    const bottomPadding = 20.0;
    final chartHeight = size.height - topPadding - bottomPadding;
    final barWidth = 16.0;

    final gridPaint = Paint()
      ..color = const Color(0xFF2E3E66).withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 3; i++) {
      final y = topPadding + (i / 3.0) * chartHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (int i = 0; i < 7; i++) {
      final x = colWidth * i + colWidth / 2;
      final stats = daysData[i].third;
      final isSelected = i == selectedIndex;

      if (isSelected) {
        final selectPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.15);
        canvas.drawRect(
          Rect.fromLTWH(
            colWidth * i + 2,
            topPadding - 10,
            colWidth - 4,
            chartHeight + 20,
          ),
          selectPaint,
        );
      }

      if (stats.total > 0) {
        final compHeight = (stats.completed / maxOrders) * chartHeight;
        final awatHeight = (stats.awaiting / maxOrders) * chartHeight;

        final compPaint = Paint()
          ..color = isSelected ? softTeal : softTeal.withValues(alpha: 0.7);
        final awatPaint = Paint()
          ..color = isSelected ? warmOrange : warmOrange.withValues(alpha: 0.7);

        // Completed bar
        final compRect = Rect.fromLTWH(
          x - barWidth / 2,
          size.height - bottomPadding - compHeight,
          barWidth,
          compHeight,
        );
        canvas.drawRect(compRect, compPaint);

        // Awaiting bar
        final awatRect = Rect.fromLTWH(
          x - barWidth / 2,
          size.height - bottomPadding - compHeight - awatHeight,
          barWidth,
          awatHeight,
        );
        canvas.drawRect(awatRect, awatPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant WeeklyChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.daysData != daysData;
  }
}
