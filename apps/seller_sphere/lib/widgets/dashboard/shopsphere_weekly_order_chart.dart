import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';
import 'package:seller_sphere/widgets/dashboard/order_pickup_item.dart';
import 'package:seller_sphere/widgets/dashboard/chart_painter.dart';

class ShopsphereWeeklyOrderChart extends StatefulWidget {
  final List<ShopsphereOrder> orders;
  final AppViewModel viewModel;
  final Function(String) onNavigateToChat;

  const ShopsphereWeeklyOrderChart(
      {super.key,
      required this.orders,
      required this.viewModel,
      required this.onNavigateToChat});

  @override
  _ShopsphereWeeklyOrderChartState createState() =>
      _ShopsphereWeeklyOrderChartState();
}

class _ShopsphereWeeklyOrderChartState
    extends State<ShopsphereWeeklyOrderChart> {
  int _selectedIndex = 6; // Default to today

  @override
  Widget build(BuildContext context) {
    final daysData = _calculateDaysData(widget.orders);
    final maxOrders = (daysData.map((d) => d.stats.total).reduce(max) == 0
            ? 5
            : daysData.map((d) => d.stats.total).reduce(max))
        .toDouble();
    final selectedDayStats = daysData[_selectedIndex].stats;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildLegendItem(const Color(0xFF4CAF50), "Selesai Diambil"),
                const SizedBox(width: 12),
                _buildLegendItem(const Color(0xFFFFA500), "Belum Diambil"),
              ],
            ),
            Text(
              "${selectedDayStats.total} Pesanan",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTapUp: (details) {
            final box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.globalPosition);
            final colWidth = box.size.width / 7;
            final tappedCol = (localPosition.dx / colWidth).floor().clamp(0, 6);
            setState(() {
              _selectedIndex = tappedCol;
            });
          },
          child: CustomPaint(
            size: const Size(double.infinity, 180),
            painter: ChartPainter(
                daysData: daysData,
                selectedIndex: _selectedIndex,
                maxOrders: maxOrders,
                theme: Theme.of(context)),
          ),
        ),
        const SizedBox(height: 8),
        _buildDayLabels(daysData),
        const SizedBox(height: 16),
        _buildOrderListForSelectedDay(daysData),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
            width: 10, height: 10, color: color, child: const SizedBox()),
        const SizedBox(width: 4),
        Text(text,
            style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildDayLabels(List<DayChartData> daysData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final isSelected = i == _selectedIndex;
        return GestureDetector(
          onTap: () => setState(() => _selectedIndex = i),
          child: SizedBox(
            width: 42,
            child: Column(
              children: [
                Text(daysData[i].dayLabel,
                    style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal)),
                Text(daysData[i].dateLabel,
                    style: TextStyle(
                        fontSize: 9,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                            : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5))),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOrderListForSelectedDay(List<DayChartData> daysData) {
    final selectedDayData = daysData[_selectedIndex];
    final dayOrders =
        widget.orders.where((o) => o.dayIndex == _selectedIndex).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            "Daftar Paket Hari ${selectedDayData.dayLabel} (${selectedDayData.dateLabel})",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        if (dayOrders.isEmpty)
          Card(
            color: const Color(0xFF0F172A).withValues(alpha: 0.4),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text("Tidak ada orderan masuk untuk tanggal ini.",
                    style: TextStyle(fontSize: 12)),
              ),
            ),
          )
        else
          ...dayOrders.map((order) => OrderPickupItem(
                order: order,
                viewModel: widget.viewModel,
                onNavigateToChat: widget.onNavigateToChat,
              )),
      ],
    );
  }

  List<DayChartData> _calculateDaysData(List<ShopsphereOrder> orders) {
    final sdfLabel = DateFormat("E", "in_ID");
    final sdfDate = DateFormat("dd/MM");
    return List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final dayOrders = orders.where((o) => o.dayIndex == i).toList();
      final completed =
          dayOrders.where((o) => o.status == "Selesai Diambil").length;
      final awaiting = dayOrders.length - completed;
      return DayChartData(
        dayLabel: sdfLabel.format(date),
        dateLabel: sdfDate.format(date),
        stats: DayOrderStats(completed, awaiting),
      );
    });
  }
}
