import 'package:intl/intl.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/screens/dashboard_screen.dart';

List<DayChartData> buildChartData(List<ShopsphereOrder> allOrders) {
  final List<DayChartData> daysData = [];
  final now = DateTime.now();

  for (int i = 0; i < 7; i++) {
    final date = now.subtract(Duration(days: 6 - i));
    final dayLabel = DateFormat('E').format(date).substring(0, 1);
    final dateLabel = DateFormat('d').format(date);

    final ordersForDay = allOrders.where((order) {
      // Assuming dayIndex 0 is 6 days ago, and 6 is today.
      return order.dayIndex == i;
    }).toList();

    final completed =
        ordersForDay.where((o) => o.status == 'Selesai Diambil').length;
    final awaiting = ordersForDay.length - completed;

    daysData.add(DayChartData(
      dayLabel: dayLabel,
      dateLabel: dateLabel,
      stats: DayOrderStats(completed, awaiting),
    ));
  }
  return daysData;
}
