import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/utils/formatting.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';
import 'package:seller_sphere/widgets/dashboard/daily_target_dialog.dart';
import 'package:seller_sphere/widgets/dashboard/shopsphere_weekly_order_chart.dart';

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

class DashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToInventory;
  final VoidCallback onNavigateToTransactions;
  final Function(String) onNavigateToChat;
  final VoidCallback onNavigateToSlides;

  const DashboardScreen({
    super.key,
    required this.onNavigateToInventory,
    required this.onNavigateToTransactions,
    required this.onNavigateToChat,
    required this.onNavigateToSlides,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final lowStockList = viewModel.lowStockProducts;
    final todaySalesTotal = viewModel.getTodaySalesTotal();
    final targetValue = viewModel.todayTarget?.targetAmount ?? 1000000.0;
    final targetProgress =
        (targetValue > 0) ? (todaySalesTotal / targetValue).clamp(0.0, 1.0) : 1.0;
    final targetPercentage = (targetProgress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          if (viewModel.isDebugMode)
            IconButton(
              icon: const Icon(Icons.bug_report),
              onPressed: () => Navigator.pushNamed(context, '/debug'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeroBanner(context),
          const SizedBox(height: 16),
          if (lowStockList.isNotEmpty) ...[
            _buildLowStockWarning(context, lowStockList),
            const SizedBox(height: 16),
          ],
          _buildDailyTargetCard(context, viewModel, todaySalesTotal, targetValue,
              targetPercentage, targetProgress),
          const SizedBox(height: 16),
          _buildOrderSummary(context, viewModel.shopsphereOrders),
          const SizedBox(height: 16),
          _buildWeeklyOrderChart(context, viewModel),
          const SizedBox(height: 16),
          _buildMainActions(context),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return GestureDetector(
      onTap: onNavigateToSlides,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.asset(
              'assets/images/img_hero_banner.jpg',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, const Color(0xCC090D1A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "SS Seller Sphere",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Real-time Store Intelligence Pro",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockWarning(
      BuildContext context, List<Product> lowStockList) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onNavigateToInventory,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(Icons.warning,
                  color: Theme.of(context).colorScheme.error, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Peringatan Stok Menipis! (${lowStockList.length} Produk)",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Ketuk untuk melihat detail barang di inventaris.",
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onErrorContainer
                            .withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyTargetCard(
    BuildContext context,
    AppViewModel viewModel,
    double todaySalesTotal,
    double targetValue,
    int targetPercentage,
    double targetProgress,
  ) {
    final motivationText = switch (todaySalesTotal) {
      0.0 =>
        "Semangat! Mulai hari ini dengan menambahkan penjualan pertama Anda. Target Anda hari ini adalah ${formatRupiah(targetValue)}.",
      _ when targetPercentage < 50 =>
        "Anda sudah mencapai $targetPercentage% dari target hari ini. Terus maju, sisa ${formatRupiah(targetValue - todaySalesTotal)} lagi!",
      _ when targetPercentage < 100 =>
        "Hampir sampai! $targetPercentage% target tercapai. Tambah beberapa transaksi lagi untuk mencapai sukses hari ini!",
      _ =>
        "Luar biasa! Target penjualan hari ini TELAH TERCAPAI ($targetPercentage%). Pertahankan kinerja hebat ini! ???",
    };

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notifications_active,
                        color: Color(0xFFFFA500), size: 20),
                    SizedBox(width: 8),
                    Text("Target Penjualan Harian",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _showTargetDialog(context, viewModel, targetValue);
                  },
                  child: Text(
                    "Ubah",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: targetProgress),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 16,
                  backgroundColor: const Color(0xFF2E3E66),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFFA500),
                  ),
                  // TODO: Add gradient later if needed
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${formatRupiah(todaySalesTotal)} / ${formatRupiah(targetValue)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "$targetPercentage%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: targetPercentage >= 100
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFFFA500),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              motivationText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTargetDialog(
      BuildContext context, AppViewModel viewModel, double currentTarget) {
    showDialog(
      context: context,
      builder: (context) =>
          DailyTargetDialog(viewModel: viewModel, currentTarget: currentTarget),
    );
  }

  Widget _buildOrderSummary(
      BuildContext context, List<ShopsphereOrder> orders) {
    final todayOrders = orders.where((it) => it.dayIndex == 6).toList();
    final awaitingPickupCount =
        todayOrders.where((it) => it.status != "Selesai Diambil").length;
    final pickedUpCount =
        todayOrders.where((it) => it.status == "Selesai Diambil").length;

    return Row(
      children: [
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA500).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.warning,
                            color: Color(0xFFFFA500), size: 18),
                      ),
                      const SizedBox(width: 8),
                      Text("Belum Diambil",
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.8))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("$awaitingPickupCount Paket",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFFFFA500))),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle,
                            color: Color(0xFF4CAF50), size: 18),
                      ),
                      const SizedBox(width: 8),
                      Text("Selesai Diambil",
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.8))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("$pickedUpCount Paket",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF4CAF50))),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildWeeklyOrderChart(BuildContext context, AppViewModel viewModel) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Statistik Pengambilan Pesanan Toko",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
              "Ketuk hari untuk detail paket masuk & pengambilan oleh pembeli",
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 16),
            ShopsphereWeeklyOrderChart(
                orders: viewModel.shopsphereOrders,
                viewModel: viewModel,
                onNavigateToChat: onNavigateToChat),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onNavigateToTransactions,
            icon: const Icon(Icons.add),
            label: const Text("Kasir (POS)"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onNavigateToInventory,
            icon: const Icon(Icons.show_chart),
            label: const Text("Kelola Barang"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
