import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../models/shopsphere_order.dart';
import '../widgets/order_pickup_item.dart';

const Color warmOrange = Color(0xFFFFA726);
const Color softTeal = Color(0xFF4DB6AC);
const Color surfaceVariantColor = Color(0xFF1B263B);

class ShopsphereWeeklyOrderChart extends StatefulWidget {
  final List<ShopsphereOrder> orders;
  final Function(String) onNavigateToChat;

  const ShopsphereWeeklyOrderChart({
    super.key,
    required this.orders,
    required this.onNavigateToChat,
  });

  @override
  _ShopsphereWeeklyOrderChartState createState() =>
      _ShopsphereWeeklyOrderChartState();
}

class DayOrderStats {
  final int completed;
  final int awaiting;
  DayOrderStats(this.completed, this.awaiting);
  int get total => completed + awaiting;
}

class _ShopsphereWeeklyOrderChartState
    extends State<ShopsphereWeeklyOrderChart> {
  int _selectedIndex = 6; // Default to today
  late List<Triple<String, String, DayOrderStats>> _daysData;

  @override
  void initState() {
    super.initState();
    _daysData = _calculateDaysData(widget.orders);
  }

  @override
  void didUpdateWidget(covariant ShopsphereWeeklyOrderChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.orders != oldWidget.orders) {
      _daysData = _calculateDaysData(widget.orders);
    }
  }

  List<Triple<String, String, DayOrderStats>> _calculateDaysData(
    List<ShopsphereOrder> orders,
  ) {
    final sdfLabel = DateFormat('E', 'id_ID');
    final sdfDate = DateFormat('dd/MM');
    final list = <Triple<String, String, DayOrderStats>>[];

    for (int i = 0; i <= 6; i++) {
      final checkCalendar = DateTime.now().subtract(Duration(days: 6 - i));
      final dayLabel = sdfLabel.format(checkCalendar);
      final dateStr = sdfDate.format(checkCalendar);

      final dayOrders = orders.where((o) => o.dayIndex == i).toList();
      final completed = dayOrders
          .where((o) => o.status == "Selesai Diambil")
          .length;
      final awaiting = dayOrders.length - completed;
      list.add(Triple(dayLabel, dateStr, DayOrderStats(completed, awaiting)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final maxOrders = _daysData.map((d) => d.third.total).reduce(max);
    final selectedDayStats = _daysData[_selectedIndex].third;
    final selectedDayOrders = widget.orders
        .where((o) => o.dayIndex == _selectedIndex)
        .toList();

    return Card(
      color: surfaceVariantColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Statistik Pengambilan Pesanan Toko",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "Ketuk hari untuk detail paket masuk & pengambilan oleh pembeli",
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _LegendItem(color: softTeal, text: "Selesai Diambil"),
                    const SizedBox(width: 12),
                    _LegendItem(color: warmOrange, text: "Belum Diambil"),
                  ],
                ),
                Text(
                  "${selectedDayStats.total} Pesanan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTapUp: (details) {
                final box = context.findRenderObject() as RenderBox;
                final localPosition = box.globalToLocal(details.globalPosition);
                final colWidth = box.size.width / 7;
                final tappedCol = (localPosition.dx / colWidth).floor().clamp(
                  0,
                  6,
                );
                setState(() {
                  _selectedIndex = tappedCol;
                });
              },
              child: CustomPaint(
                painter: _WeeklyChartPainter(
                  daysData: _daysData,
                  maxOrders: maxOrders == 0 ? 5 : maxOrders,
                  selectedIndex: _selectedIndex,
                ),
                child: const SizedBox(height: 180, width: double.infinity),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final isSelected = i == _selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: SizedBox(
                    width: 42,
                    child: Column(
                      children: [
                        Text(
                          _daysData[i].first,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          _daysData[i].second,
                          style: TextStyle(
                            fontSize: 9,
                            color: isSelected
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.8)
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              "Daftar Paket Hari ${_daysData[_selectedIndex].first} (${_daysData[_selectedIndex].second})",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            if (selectedDayOrders.isEmpty)
              Card(
                color: const Color(0xFF0F172A).withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: Center(
                    child: Text(
                      "Tidak ada orderan masuk untuk tanggal ini.",
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ),
                ),
              )
            else
              ...selectedDayOrders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: OrderPickupItem(
                    order: order,
                    onNavigateToChat: widget.onNavigateToChat,
                    onUpdate: () => setState(() {
                      _daysData = _calculateDaysData(widget.orders);
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ],
    );
  }
}

class _WeeklyChartPainter extends CustomPainter {
  final List<Triple<String, String, DayOrderStats>> daysData;
  final int maxOrders;
  final int selectedIndex;

  _WeeklyChartPainter({
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
  bool shouldRepaint(covariant _WeeklyChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.daysData != daysData;
  }
}

// --- UTILITY ---
class Triple<T1, T2, T3> {
  final T1 first;
  final T2 second;
  final T3 third;
  Triple(this.first, this.second, this.third);
}
