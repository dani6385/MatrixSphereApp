import 'package:flutter/material.dart';

class DayOrderStats {
  final int completed;
  final int awaiting;
  int get total => completed + awaiting;
  DayOrderStats(this.completed, this.awaiting);
}

class DayChartData {
  final String dayLabel;
  final String dateLabel;
  final DayOrderStats stats;
  DayChartData(
      {required this.dayLabel, required this.dateLabel, required this.stats});
}

class ChartPainter extends CustomPainter {
  final List<DayChartData> daysData;
  final int selectedIndex;
  final double maxOrders;
  final ThemeData theme;

  ChartPainter(
      {required this.daysData,
      required this.selectedIndex,
      required this.maxOrders,
      required this.theme});

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

    for (int i = 0; i < daysData.length; i++) {
      final stats = daysData[i].stats;
      final x = colWidth * i + colWidth / 2;
      final isSelected = i == selectedIndex;

      if (stats.total > 0) {
        final compHeight = (stats.completed / maxOrders) * chartHeight;
        final awatHeight = (stats.awaiting / maxOrders) * chartHeight;

        final compTopY = size.height - bottomPadding - compHeight;
        final compRect =
            Rect.fromLTWH(x - barWidth / 2, compTopY, barWidth, compHeight);
        final compPaint = Paint()
          ..color = isSelected
              ? const Color(0xFF4CAF50)
              : const Color(0xFF4CAF50).withValues(alpha: 0.7);
        canvas.drawRect(compRect, compPaint);

        final awatTopY = compTopY - awatHeight;
        final awatRect =
            Rect.fromLTWH(x - barWidth / 2, awatTopY, barWidth, awatHeight);
        final awatPaint = Paint()
          ..color = isSelected
              ? const Color(0xFFFFA500)
              : const Color(0xFFFFA500).withValues(alpha: 0.7);
        canvas.drawRect(awatRect, awatPaint);
      }
      if (isSelected) {
        final selectionPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        final selectionRect = Rect.fromLTWH(colWidth * i + 2.0,
            topPadding - 10, colWidth - 4.0, chartHeight + 20);
        canvas.drawRect(selectionRect, selectionPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.daysData != daysData;
  }
}
