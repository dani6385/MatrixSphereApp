import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';
import 'package:seller_sphere/widgets/dashboard/daily_target_card.dart';
import 'package:seller_sphere/widgets/dashboard/daily_target_dialog.dart';
import 'package:seller_sphere/widgets/dashboard/pickup_summary.dart';
import 'package:seller_sphere/widgets/dashboard/weekly_order_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dummy data - replace with actual data from your view model
  final double _todaySalesTotal = 830000;
  final double _dailyTarget = 1000000;
  final List<ShopsphereOrder> _orders = _getDummyOrders();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);

    final targetPercentage = (_todaySalesTotal / _dailyTarget * 100).toInt();
    final targetProgress = (_todaySalesTotal / _dailyTarget).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Sphere Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DailyTargetCard(
              viewModel: viewModel,
              todaySalesTotal: _todaySalesTotal,
              targetValue: _dailyTarget,
              targetPercentage: targetPercentage,
              targetProgress: targetProgress,
              onEdit: () => _showEditTargetDialog(viewModel),
            ),
            const SizedBox(height: 16),
            const Text("Ringkasan Pengambilan Hari Ini", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            PickupSummary(orders: _orders),
            const SizedBox(height: 24),
            ShopsphereWeeklyOrderChart(
              orders: _orders,
              viewModel: viewModel,
              onNavigateToChat: _navigateToChat,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTargetDialog(AppViewModel viewModel) {
    showDialog(
      context: context,
      builder: (_) => DailyTargetDialog(
        viewModel: viewModel,
        currentTarget: _dailyTarget,
      ),
    ).then((_) {
      // For demo purposes, we'll just update the state here
      // In a real app, the viewModel would update and notify listeners
      setState(() {
        // This is where you might update _dailyTarget from the viewModel
      });
    });
  }

  void _navigateToChat(String customerName) {
    // In a real app, you would navigate to the chat screen for this customer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Navigating to chat with $customerName...")),
    );
  }

  // Helper to create dummy data
  static List<ShopsphereOrder> _getDummyOrders() {
    return [
      ShopsphereOrder(id: "SS-240523-001", customerName: "Budi", productName: "T-Shirt Keren", quantity: 1, totalAmount: 120000, courierPhone: "081234567890", status: "Selesai Diambil", dayIndex: 6, verificationCode: "123456"),
      ShopsphereOrder(id: "SS-240523-002", customerName: "Ani", productName: "Sepatu Lari", quantity: 1, totalAmount: 450000, courierPhone: "081234567891", status: "Siap Diambil", dayIndex: 6, verificationCode: "234567"),
      ShopsphereOrder(id: "SS-240523-003", customerName: "Cici", productName: "Tas Ransel", quantity: 2, totalAmount: 260000, courierPhone: "081234567892", status: "Perlu Dipacking", dayIndex: 6, verificationCode: "345678"),
      ShopsphereOrder(id: "SS-240522-001", customerName: "Dedi", productName: "Topi", quantity: 1, totalAmount: 75000, courierPhone: "081234567893", status: "Selesai Diambil", dayIndex: 5, verificationCode: "456789"),
      ShopsphereOrder(id: "SS-240521-001", customerName: "Euis", productName: "Jam Tangan", quantity: 1, totalAmount: 350000, courierPhone: "081234567894", status: "Selesai Diambil", dayIndex: 4, verificationCode: "567890"),
      ShopsphereOrder(id: "SS-240521-002", customerName: "Fafa", productName: "Kacamata", quantity: 1, totalAmount: 150000, courierPhone: "081234567895", status: "Selesai Diambil", dayIndex: 4, verificationCode: "678901"),
    ];
  }
}
