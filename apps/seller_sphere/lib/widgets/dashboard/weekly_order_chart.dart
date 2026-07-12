import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/screens/dashboard_screen.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';
import 'package:seller_sphere/widgets/dashboard/order_pickup_item.dart';

class WeeklyOrderChart extends StatefulWidget {
  final List<ShopsphereOrder> orders;
  final void Function(String) onNavigateToChat;
  final AppViewModel viewModel;

  const WeeklyOrderChart(
      {super.key,
      required this.orders,
      required this.onNavigateToChat,
      required this.viewModel});

  @override
  State<WeeklyOrderChart> createState() => _WeeklyOrderChartState();
}

class _WeeklyOrderChartState extends State<WeeklyOrderChart> {
  int _selectedIndex = 6; // Default to today

  List<DayChartData> _getDaysData() {
    final sdfLabel = DateFormat('E', 'id_ID');
    final sdfDate = DateFormat('dd/MM');
    final list = <DayChartData>[];

    for (int i = 0; i <= 6; i++) {
      final checkCalendar = DateTime.now().subtract(Duration(days: 6 - i));
      final dateStr = sdfDate.format(checkCalendar);
      final dayLabel = sdfLabel.format(checkCalendar);

      final dayOrders = widget.orders.where((o) => o.dayIndex == i);
      final completed =
          dayOrders.where((o) => o.status == "Selesai Diambil").length;
      final awaiting = dayOrders.length - completed;

      list.add(DayChartData(
          dayLabel: dayLabel,
          dateLabel: dateStr,
          stats: DayOrderStats(completed, awaiting)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final daysData = _getDaysData();
    final maxOrders = daysData
        .map((d) => d.stats.total)
        .reduce((a, b) => a > b ? a : b)
        .clamp(5, 1000)
        .toDouble();
    final selectedDayStats = daysData[_selectedIndex].stats;

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),

            // Chart Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _LegendItem(
                        color: const Color(0xFF4CAF50), text: "Selesai Diambil"),
                    const SizedBox(width: 12),
                    _LegendItem(
                        color: const Color(0xFFFFA500), text: "Belum Diambil"),
                  ],
                ),
                Text(
                  "${selectedDayStats.total} Pesanan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),
            // Bar Chart
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  maxY: maxOrders,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) => null,
                    ),
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      if (event is FlTapUpEvent &&
                          barTouchResponse != null &&
                          barTouchResponse.spot != null) {
                        setState(() {
                          _selectedIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
                        });
                      }
                    },
                  ),
                  titlesData: const FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: List.generate(7, (i) {
                    final stats = daysData[i].stats;
                    final isSelected = i == _selectedIndex;
                    const barWidth = 16.0;
                    return BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                          toY: stats.total.toDouble(),
                          width: barWidth,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                          rodStackItems: [
                            BarChartRodStackItem(
                                0,
                                stats.completed.toDouble(),
                                isSelected
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFF4CAF50).withValues(alpha: 0.7)),
                            BarChartRodStackItem(
                                stats.completed.toDouble(),
                                stats.total.toDouble(),
                                isSelected
                                    ? const Color(0xFFFFA500)
                                    : const Color(0xFFFFA500).withValues(alpha: 0.7)),
                          ])
                    ]);
                  }),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Day Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final isSelected = i == _selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Column(
                    children: [
                      Text(
                        daysData[i].dayLabel,
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      Text(
                        daysData[i].dateLabel,
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).primaryColor.withValues(alpha: 0.8)
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.5),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),
            // Order List for Selected Day
            _DailyOrderList(
                dayIndex: _selectedIndex,
                dayName: daysData[_selectedIndex].dayLabel,
                dateStr: daysData[_selectedIndex].dateLabel,
                orders: widget.orders,
                onNavigateToChat: widget.onNavigateToChat,
                viewModel: widget.viewModel),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

class _DailyOrderList extends StatelessWidget {
  final int dayIndex;
  final String dayName;
  final String dateStr;
  final List<ShopsphereOrder> orders;
  final void Function(String) onNavigateToChat;
  final AppViewModel viewModel;

  const _DailyOrderList({
    required this.dayIndex,
    required this.dayName,
    required this.dateStr,
    required this.orders,
    required this.onNavigateToChat,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final dayOrders = orders.where((o) => o.dayIndex == dayIndex).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daftar Paket Hari $dayName ($dateStr)",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        if (dayOrders.isEmpty)
          Card(
            color: const Color(0xFF0F172A).withValues(alpha: 0.4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text("Tidak ada orderan masuk untuk tanggal ini.",
                    style: TextStyle(fontSize: 12)),
              ),
            ),
          )
        else
          ...dayOrders.map((order) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: OrderPickupItem(
                    order: order,
                    onNavigateToChat: onNavigateToChat,
                    viewModel: viewModel),
              )),
      ],
    );
  }
}
