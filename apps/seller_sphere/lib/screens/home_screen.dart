import 'package:flutter/material.dart';

import '../models/shopsphere_order.dart';
import '../widgets/daily_target_dialog.dart';
import '../widgets/daily_target_card.dart';
import '../widgets/pickup_summary.dart';
import '../widgets/hero_banner.dart';
import '../widgets/low_stock_warning.dart';
import '../widgets/shopsphere_weekly_order_chart.dart';
import '../widgets/main_actions.dart';

const Color darkBlueBackground = Color(0xFF0D1B2A);

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToInventory;
  final VoidCallback onNavigateToTransactions;
  final Function(String) onNavigateToChat;
  final VoidCallback onNavigateToSlides;

  const HomeScreen({
    super.key,
    required this.onNavigateToInventory,
    required this.onNavigateToTransactions,
    required this.onNavigateToChat,
    required this.onNavigateToSlides,
  });

  @override
  Widget build(BuildContext context) {
    // Using dummy data for display purposes
    final List<ShopsphereOrder> shopsphereOrders = _getDummyOrders();
    final List<String> lowStockList = ['Produk A', 'Produk B'];
    const double todaySalesTotal = 750000.0;
    const double todayTarget = 1000000.0;

    return Scaffold(
      backgroundColor: darkBlueBackground,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          HeroBanner(onNavigateToSlides: onNavigateToSlides),
          const SizedBox(height: 16),
          if (lowStockList.isNotEmpty)
            LowStockWarning(
              lowStockList: lowStockList,
              onNavigateToInventory: onNavigateToInventory,
            ),
          const SizedBox(height: 16),
          DailyTargetCard(
            todaySalesTotal: todaySalesTotal,
            todayTarget: todayTarget,
            onEditTarget: () {
              showDialog(
                context: context,
                builder: (context) => DailyTargetDialog(currentTarget: todayTarget),
              );
            },
          ),
          const SizedBox(height: 16),
          PickupSummary(orders: shopsphereOrders),
          const SizedBox(height: 16),
          ShopsphereWeeklyOrderChart(
            orders: shopsphereOrders,
            onNavigateToChat: onNavigateToChat,
          ),
          const SizedBox(height: 16),
          MainActions(
            onNavigateToTransactions: onNavigateToTransactions,
            onNavigateToInventory: onNavigateToInventory,
          ),
        ],
      ),
    );
  }

  List<ShopsphereOrder> _getDummyOrders() {
    return [
      ShopsphereOrder(id: "SS-240523-001", customerName: "Budi", productName: "Kopi Robusta 250g", quantity: 2, totalAmount: 150000, courierPhone: "081234567890", status: "Perlu Dipacking", dayIndex: 6, verificationCode: "123456"),
      ShopsphereOrder(id: "SS-240523-002", customerName: "Siti", productName: "Teh Hijau", quantity: 1, totalAmount: 75000, courierPhone: "081234567891", status: "Siap Diambil", dayIndex: 6, verificationCode: "654321"),
      ShopsphereOrder(id: "SS-240522-001", customerName: "Joko", productName: "Gula Aren 1kg", quantity: 1, totalAmount: 45000, courierPhone: "081234567892", status: "Selesai Diambil", dayIndex: 5, verificationCode: "112233"),
      ShopsphereOrder(id: "SS-240522-002", customerName: "Ani", productName: "Kopi Robusta 250g", quantity: 3, totalAmount: 225000, courierPhone: "081234567893", status: "Selesai Diambil", dayIndex: 5, verificationCode: "445566"),
      ShopsphereOrder(id: "SS-240521-001", customerName: "Euis", productName: "Jam Tangan", quantity: 1, totalAmount: 350000, courierPhone: "081234567894", status: "Selesai Diambil", dayIndex: 4, verificationCode: "567890"),
    ];
  }
}
