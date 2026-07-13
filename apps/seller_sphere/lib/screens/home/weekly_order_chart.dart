import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../models/shopsphere_order.dart';
import '../../models/day_order_stats.dart';
import '../../utils/triple.dart';
import '../../widgets/order_pickup_item.dart';
import '../../widgets/charts/chart_painter.dart';
import '../../widgets/charts/legend_item.dart';

class WeeklyOrderChart extends StatefulWidget {
  final List<ShopsphereOrder> orders;
  final Function(String) onNavigateToChat;

  const WeeklyOrderChart({
    super.key,
    required this.orders,
    required this.onNavigateToChat,
  });

  @override
  WeeklyOrderChartState createState() => WeeklyOrderChartState();
}

class WeeklyOrderChartState extends State<WeeklyOrderChart> {
  int _selectedIndex = 6; // Default to today
  late List<Triple<String, String, DayOrderStats>> _daysData;

  @override
  void initState() {
    super.initState();
    _daysData = _calculateDaysData(widget.orders);
  }

  @override
  void didUpdateWidget(covariant WeeklyOrderChart oldWidget) {
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

  void _handleChartTap(TapUpDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final colWidth = box.size.width / 7;
    final tappedCol = (localPosition.dx / colWidth).floor().clamp(0, 6);
    setState(() {
      _selectedIndex = tappedCol;
    });
  }

  void _selectDay(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleOrderUpdate() {
    setState(() {
      _daysData = _calculateDaysData(widget.orders);
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxOrders = _daysData.map((d) => d.third.total).reduce(max);
    final selectedDayData = _daysData[_selectedIndex];
    final selectedDayOrders = widget.orders
        .where((o) => o.dayIndex == _selectedIndex)
        .toList();

    return Card(
      color: kSlateSurfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ChartHeader(),
            const SizedBox(height: 16),
            ChartLegend(totalOrders: selectedDayData.third.total),
            const SizedBox(height: 16),
            GestureDetector(
              onTapUp: _handleChartTap,
              child: CustomPaint(
                painter: WeeklyChartPainter(
                  daysData: _daysData,
                  maxOrders: maxOrders == 0 ? 5 : maxOrders,
                  selectedIndex: _selectedIndex,
                ),
                child: const SizedBox(height: 180, width: double.infinity),
              ),
            ),
            const SizedBox(height: 8),
            DaySelector(
              daysData: _daysData,
              selectedIndex: _selectedIndex,
              onDaySelected: _selectDay,
            ),
            const SizedBox(height: 16),
            OrderListHeader(dayData: selectedDayData),
            const SizedBox(height: 4),
            OrderList(
              orders: selectedDayOrders,
              onNavigateToChat: widget.onNavigateToChat,
              onUpdate: _handleOrderUpdate,
            ),
          ],
        ),
      ),
    );
  }
}

class ChartHeader extends StatelessWidget {
  const ChartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}

class ChartLegend extends StatelessWidget {
  final int totalOrders;

  const ChartLegend({super.key, required this.totalOrders});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            LegendItem(color: kSoftTeal, text: "Selesai Diambil"),
            SizedBox(width: 12),
            LegendItem(color: kWarmOrange, text: "Belum Diambil"),
          ],
        ),
        Text(
          "$totalOrders Pesanan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class DaySelector extends StatelessWidget {
  final List<Triple<String, String, DayOrderStats>> daysData;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  const DaySelector({
    super.key,
    required this.daysData,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final isSelected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onDaySelected(i),
          child: SizedBox(
            width: 42,
            child: Column(
              children: [
                Text(
                  daysData[i].first,
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
                  daysData[i].second,
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
    );
  }
}

class OrderListHeader extends StatelessWidget {
  final Triple<String, String, DayOrderStats> dayData;

  const OrderListHeader({super.key, required this.dayData});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Daftar Paket Hari ${dayData.first} (${dayData.second})",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final List<ShopsphereOrder> orders;
  final Function(String) onNavigateToChat;
  final VoidCallback onUpdate;

  const OrderList({
    super.key,
    required this.orders,
    required this.onNavigateToChat,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Card(
        color: kDarkBackground.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      );
    }

    return Column(
      children: orders
          .map(
            (order) => Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: OrderPickupItem(
                order: order,
                onNavigateToChat: onNavigateToChat,
                onUpdate: onUpdate,
              ),
            ),
          )
          .toList(),
    );
  }
}
