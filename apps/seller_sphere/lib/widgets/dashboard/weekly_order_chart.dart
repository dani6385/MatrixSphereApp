import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';
import 'package:seller_sphere/widgets/dashboard/chart_painter.dart';
import 'package:seller_sphere/widgets/dashboard/order_pickup_item.dart';
import 'package:seller_sphere/widgets/dashboard/order_verification_dialog.dart';

class ShopsphereWeeklyOrderChart extends StatefulWidget {
  final List<ShopsphereOrder> orders;
  final AppViewModel viewModel;
  final Function(String) onNavigateToChat;

  const ShopsphereWeeklyOrderChart({
    super.key,
    required this.orders,
    required this.viewModel,
    required this.onNavigateToChat,
  });

  @override
  State<ShopsphereWeeklyOrderChart> createState() =>
      _ShopsphereWeeklyOrderChartState();
}

class _ShopsphereWeeklyOrderChartState extends State<ShopsphereWeeklyOrderChart> {
  int selectedIndex = 6; // Default to today

  @override
  Widget build(BuildContext context) {
    final weeklyData = _calculateWeeklyData();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pesanan Seminggu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTapDown: (details) => _handleChartTap(details, weeklyData),
              child: CustomPaint(
                painter: ChartPainter(
                  data: weeklyData,
                  selectedIndex: selectedIndex,
                ),
                size: const Size(double.infinity, 150),
              ),
            ),
            const SizedBox(height: 16),
            _buildSelectedDayDetails(weeklyData[selectedIndex]),
          ],
        ),
      ),
    );
  }

  List<double> _calculateWeeklyData() {
    List<double> data = List.filled(7, 0.0);
    for (var order in widget.orders) {
      if (order.dayIndex >= 0 && order.dayIndex < 7) {
        data[order.dayIndex] += order.totalAmount;
      }
    }
    return data;
  }

  void _handleChartTap(TapDownDetails details, List<double> weeklyData) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final barWidth = renderBox.size.width / weeklyData.length;
    final index = (localPosition.dx / barWidth).floor();
    if (index >= 0 && index < weeklyData.length) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  Widget _buildSelectedDayDetails(double total) {
    final dayOrders = widget.orders
        .where((order) => order.dayIndex == selectedIndex)
        .toList();
    final dayOfWeek = DateFormat('EEEE', 'id_ID')
        .format(DateTime.now().subtract(Duration(days: 6 - selectedIndex)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Pesanan Hari $dayOfWeek: ${NumberFormat.compactCurrency(locale: 'id_ID', symbol: 'Rp').format(total)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          '${dayOrders.length} pesanan perlu diurus',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        if (dayOrders.isNotEmpty)
          TextButton(
            onPressed: () => _showOrderDetails(context, dayOrders),
            child: const Text('Lihat Rincian & Lakukan Aksi',
                style: TextStyle(color: Color(0xFF00FFFF))),
          ),
      ],
    );
  }

  void _showOrderDetails(BuildContext context, List<ShopsphereOrder> dayOrders) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("Rincian Pesanan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: dayOrders.length,
                  itemBuilder: (context, index) {
                    final order = dayOrders[index];
                    return OrderPickupItem(
                      order: order,
                      onAction: () {
                        if (order.status == 'Perlu Dipacking') {
                          widget.viewModel.finishPacking(order.id);
                          Navigator.of(context).pop(); // Close the modal
                        } else if (order.status == 'Siap Diambil') {
                          _showVerificationDialog(context, order);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVerificationDialog(BuildContext context, ShopsphereOrder order) {
    showDialog(
      context: context,
      builder: (_) => OrderVerificationDialog(
        order: order,
        onVerifySuccess: () {
          widget.viewModel.confirmOrderPickup(order.id);
          Navigator.of(context).pop(); // Close the verification dialog
          Navigator.of(context).pop(); // Close the order details modal
        },
      ),
    );
  }
}
