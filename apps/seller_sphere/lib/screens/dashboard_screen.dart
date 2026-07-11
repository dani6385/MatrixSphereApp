import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_extraor.dart';


class DashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToInventory;
  final VoidCallback onNavigateToTransactions;
  final void Function(String) onNavigateToChat;
  final VoidCallback onNavigateToSlides;
  final VoidCallback onNavigateToLive;

  const DashboardScreen({
    super.key,
    required this.onNavigateToInventory,
    required this.onNavigateToTransactions,
    required this.onNavigateToChat,
    required this.onNavigateToSlides,
    required this.onNavigateToLive,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final lowStockList = viewModel.lowStockProducts;
    final shopsphereOrders = viewModel.shopsphereOrders;

    final todaySalesTotal = viewModel.getTodaySalesTotal();
    final targetValue = viewModel.todayTarget?.targetAmount ?? 1000000.0;
    final targetProgress =
        targetValue > 0 ? (todaySalesTotal / targetValue).clamp(0.0, 1.0) : 1.0;
    final targetPercentage = (targetProgress * 100).toInt();

    final todayOrders = shopsphereOrders.where((o) => o.dayIndex == 6).toList();
    final awaitingPickupCount =
        todayOrders.where((o) => o.status != "Selesai Diambil").length;
    final pickedUpCount = todayOrders.length - awaitingPickupCount;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          HeroBanner(onNavigateToSlides: onNavigateToSlides),
          const SizedBox(height: 16),
          if (lowStockList.isNotEmpty) ...[
            LowStockWarning(
              lowStockList: lowStockList,
              onNavigateToInventory: onNavigateToInventory,
            ),
            const SizedBox(height: 16),
          ],
          DailyTargetCard(
            viewModel: viewModel,
            todaySalesTotal: todaySalesTotal,
            targetValue: targetValue,
            targetProgress: targetProgress,
            targetPercentage: targetPercentage,
          ),
          const SizedBox(height: 16),
          PickupSummary(
            awaitingPickupCount: awaitingPickupCount,
            pickedUpCount: pickedUpCount,
          ),
          const SizedBox(height: 16),
          WeeklyOrderChart(
            orders: shopsphereOrders,
            onNavigateToChat: onNavigateToChat,
          ),
          const SizedBox(height: 24),
          ActionButtons(
            onNavigateToTransactions: onNavigateToTransactions,
            onNavigateToInventory: onNavigateToInventory,
            onNavigateToLive: onNavigateToLive,
          ),
        ],
      ),
    );
  }
}
