
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/data/local/app_database.dart';
import 'package:seller_sphere/models/day_order_stats.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/viewmodel/app_view_model.dart';

final lowStockProductsProvider = StreamProvider<List<Product>>((ref) {
  final viewModel = ref.watch(appViewModelProvider);
  return viewModel.lowStockProducts;
});

// Definisikan warna kustom yang digunakan di halaman ini
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    super.key,
    required this.onNavigateToInventory,
    required this.onNavigateToTransactions,
  });

  final VoidCallback onNavigateToInventory;
  final VoidCallback onNavigateToTransactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(appViewModelProvider);
    final lowStockList = ref.watch(lowStockProductsProvider);
    final todayTarget = viewModel.todayTarget;
    final todaySalesTotal = viewModel.getTodaySalesTotalSync();

    final targetValue = todayTarget?.targetAmount ?? 1000000;
    final targetProgress =
        (targetValue > 0) ? (todaySalesTotal / targetValue) : 1.0;
    final targetPercentage = (targetProgress * 100).toInt();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildHeroBanner(context),
        const SizedBox(height: 16),
        if (lowStockList.asData != null && lowStockList.asData!.value.isNotEmpty) ...[
            _buildLowStockWarning(context, lowStockList.asData!.value),
            const SizedBox(height: 16),
        ],
        _buildDailyTargetCard(context, viewModel, todaySalesTotal, targetValue, targetProgress, targetPercentage),
        const SizedBox(height: 16),
        _buildOrderPickupSummary(context, viewModel),
        const SizedBox(height: 16),
        _buildWeeklyOrderChartCard(context, viewModel),
        const SizedBox(height: 16),
        _buildMainActions(context),
      ],
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/img_hero_banner.jpg', // Pastikan path ini benar
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 160,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Center(child: Text("Gagal memuat banner")),
            ),
          ),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xCC090D1A).withAlpha(8),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SS Seller Sphere",
                  style: theme.textTheme.titleLarge!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Real-time Store Intelligence Pro",
                  style: theme.textTheme.bodySmall!
                      .copyWith(color: Colors.white.withAlpha(8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockWarning(BuildContext context, List<Product> lowStockList) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.errorContainer.withAlpha(9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onNavigateToInventory,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(Icons.warning, color: theme.colorScheme.error, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Peringatan Stok Menipis! (${lowStockList.length} Produk)",
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Ketuk untuk melihat detail barang di inventaris.",
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.onErrorContainer.withAlpha(8),
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
      double targetProgress,
      int targetPercentage) {
    final theme = Theme.of(context);
    final motivationText = getMotivationText(todaySalesTotal, targetValue, targetPercentage, viewModel);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_active, color: kWarmOrange, size: 20),
                    const SizedBox(width: 8),
                    Text("Target Penjualan Harian", style: theme.textTheme.titleMedium),
                  ],
                ),
                GestureDetector(
                  onTap: () => _showEditTargetDialog(context, viewModel, targetValue),
                  child: Text("Ubah", style: theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.primary)),
                )
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: targetProgress),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 16,
                  backgroundColor: const Color(0xFF2E3E66),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${viewModel.formatRupiah(todaySalesTotal)} / ${viewModel.formatRupiah(targetValue)}",
                    style: theme.textTheme.labelLarge),
                Text(
                  "$targetPercentage%",
                  style: theme.textTheme.labelLarge!.copyWith(
                      color: targetPercentage >= 100
                          ? kSoftTeal
                          : kWarmOrange),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              motivationText,
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: theme.colorScheme.onSurfaceVariant.withAlpha(9)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderPickupSummary(BuildContext context, AppViewModel viewModel) {
    final theme = Theme.of(context);
    final todayOrders = viewModel.shopsphereOrders.where((it) => it.dayIndex == 6);
    final awaitingPickupCount = todayOrders.where((it) => it.status != "Selesai Dijemput").length;
    final pickedUpCount = todayOrders.length - awaitingPickupCount;

    return Row(
      children: [
        Expanded(
          child: Card(
            color: theme.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: kWarmOrange.withAlpha(15),
                        child: const Icon(Icons.local_shipping, size: 18, color: kWarmOrange),
                      ),
                      const SizedBox(width: 8),
                      Text("Menunggu Pickup", style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("$awaitingPickupCount Paket", style: theme.textTheme.titleLarge!.copyWith(color: kWarmOrange)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: theme.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       CircleAvatar(
                        radius: 16,
                        backgroundColor: kSoftTeal.withAlpha(15),
                        child: const Icon(Icons.check_circle, size: 18, color: kSoftTeal),
                      ),
                      const SizedBox(width: 8),
                      Text("Selesai Pickup", style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("$pickedUpCount Paket", style: theme.textTheme.titleLarge!.copyWith(color: kSoftTeal)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyOrderChartCard(BuildContext context, AppViewModel viewModel) {
     final theme = Theme.of(context);
    return Card(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Statistik Penjemputan Pesanan SS", style: theme.textTheme.titleMedium),
              Text(
                "Ketuk hari untuk detail paket masuk & penjemputan Shopsphere",
                style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurfaceVariant.withAlpha(7)),
              ),
              const SizedBox(height: 16),
              ShopsphereWeeklyOrderChart(orders: viewModel.shopsphereOrders, viewModel: viewModel),
            ],
          ),
        ));
  }

  Widget _buildMainActions(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onNavigateToTransactions,
            icon: const Icon(Icons.add),
            label: const Text("Kasir (POS)"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 48),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              minimumSize: const Size(0, 48),
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  String getMotivationText(double todaySales, double target, int percentage, AppViewModel vm) {
    if (todaySales == 0) return "Semangat! Mulai hari ini dengan menambahkan penjualan pertama Anda. Target Anda hari ini adalah ${vm.formatRupiah(target)}.";
    if (percentage < 50) return "Anda sudah mencapai $percentage% dari target hari ini. Terus maju, sisa ${vm.formatRupiah(target - todaySales)} lagi!";
    if (percentage < 100) return "Hampir sampai! $percentage% target tercapai. Tambah beberapa transaksi lagi untuk mencapai sukses hari ini!";
    return "Luar biasa! Target penjualan hari ini TELAH TERCAPAI ($percentage%). Pertahankan kinerja hebat ini! 🎉";
  }

  void _showEditTargetDialog(BuildContext context, AppViewModel viewModel, double currentTarget) {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: currentTarget.toInt().toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: theme.colorScheme.surface,
        title: Text("Atur Target Penjualan Harian", style: theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.primary)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Target Rp",
            prefixText: "Rp ",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Batal", style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(6))),
          ),
          TextButton(
            onPressed: () {
              final amt = double.tryParse(controller.text) ?? 0;
              viewModel.updateTodayTarget(amt);
              Navigator.of(context).pop();
            },
            child: Text("Simpan", style: TextStyle(color: theme.colorScheme.primary)),
          ),
        ],
      ),
    );
  }
}

class ShopsphereWeeklyOrderChart extends ConsumerStatefulWidget {
  const ShopsphereWeeklyOrderChart({
    super.key,
    required this.orders,
    required this.viewModel,
  });

  final List<ShopsphereOrder> orders;
  final AppViewModel viewModel;

  @override
  ConsumerState<ShopsphereWeeklyOrderChart> createState() => _ShopsphereWeeklyOrderChartState();
}

class _ShopsphereWeeklyOrderChartState extends ConsumerState<ShopsphereWeeklyOrderChart> {
  int _selectedIndex = 6;
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

  List<Triple<String, String, DayOrderStats>> _calculateDaysData(List<ShopsphereOrder> orders) {
    final sdfLabel = DateFormat("E", "in_ID");
    final sdfDate = DateFormat("dd/MM");
    final list = <Triple<String, String, DayOrderStats>>[];

    for (int i = 0; i <= 6; i++) {
      final checkCalendar = DateTime.now().subtract(Duration(days: 6 - i));
      final dateStr = sdfDate.format(checkCalendar);
      final dayLabel = sdfLabel.format(checkCalendar);

      final dayOrders = orders.where((it) => it.dayIndex == i);
      final completed = dayOrders.where((it) => it.status == "Selesai Dijemput").length;
      final awaiting = dayOrders.length - completed;

      list.add(Triple(dayLabel, dateStr, DayOrderStats(completed, awaiting)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxOrders = _daysData.map((e) => e.third.total).reduce(max);
    final selectedDayStats = _daysData[_selectedIndex].third;
    final selectedDayOrders = widget.orders.where((it) => it.dayIndex == _selectedIndex).toList();


    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildLegendItem(context, kSoftTeal, "Selesai Dijemput"),
                const SizedBox(width: 12),
                _buildLegendItem(context, kWarmOrange, "Menunggu Pickup"),
              ],
            ),
            Text(
              "${selectedDayStats.total} Pesanan",
              style: theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTapUp: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final colWidth = box.size.width / 7;
            final tappedCol = (details.localPosition.dx / colWidth).floor().clamp(0, 6);
            setState(() {
              _selectedIndex = tappedCol;
            });
          },
          child: CustomPaint(
            size: const Size(double.infinity, 180),
            painter: _ChartPainter(
              daysData: _daysData,
              selectedIndex: _selectedIndex,
              maxOrders: maxOrders,
              theme: theme,
            ),
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
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Text(
                      _daysData[i].second,
                      style: theme.textTheme.bodySmall!.copyWith(
                         fontSize: 9,
                         color: isSelected ? theme.colorScheme.primary.withAlpha(8) : theme.colorScheme.onSurfaceVariant.withAlpha(5),
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
            style: theme.textTheme.titleSmall
        ),
        const SizedBox(height: 8),

        if (selectedDayOrders.isEmpty)
            Card(
                 color: const Color(0xFF0F172A).withAlpha(4),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 child: const SizedBox(
                   width: double.infinity,
                   height: 80,
                   child: Center(child: Text("Tidak ada orderan masuk untuk tanggal ini.")),
                 ),
            )
        else
            ...selectedDayOrders.map((order) => OrderPickupItem(order: order, viewModel: widget.viewModel)),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String text) {
    final theme = Theme.of(context);
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
        Text(text, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class OrderPickupItem extends StatelessWidget {
  const OrderPickupItem({
    super.key,
    required this.order,
    required this.viewModel,
  });

  final ShopsphereOrder order;
  final AppViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPickedUp = order.status == "Selesai Dijemput";

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isPickedUp ? const Color(0xFF0F172A).withAlpha(4) : const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.id,
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: isPickedUp ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      "Pembeli: ${order.customerName}",
                      style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                _StatusBadge(status: order.status)
              ],
            ),
            const SizedBox(height: 8),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                    Text("${order.productName} x${order.quantity}", style: theme.textTheme.bodyMedium),
                    Text(viewModel.formatRupiah(order.totalAmount), style: theme.textTheme.labelLarge),
                ]
            ),
            const SizedBox(height: 6),
            Text(
                "Kurir: ${order.courierName}",
                style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurfaceVariant.withAlpha(8)),
            ),
             if (!isPickedUp) ...[
                const SizedBox(height: 10),
                Row(
                    children: [
                        Expanded(
                            flex: 2,
                            child: _ActionButton(icon: Icons.call, text: "Hubungi", onTap: ()=>viewModel.callCourier(order.id))
                        ),
                        const SizedBox(width: 8),
                         Expanded(
                            flex: 3,
                            child: _ActionButton(icon: Icons.print, text: "Cetak Resi", onTap: ()=>viewModel.printOrderLabel(order.id))
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            flex: 4,
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.check_circle, size: 14, color: Colors.black),
                                label: Text("Konfirmasi Pickup", style: theme.textTheme.bodySmall!.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                                onPressed: ()=> viewModel.confirmOrderPickup(order.id),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kSoftTeal,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 36)
                                )
                            ),
                        ),
                    ]
                )
             ]
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
    final IconData icon;
    final String text;
    final VoidCallback onTap;

    const _ActionButton({required this.icon, required this.text, required this.onTap});
    
    @override
    Widget build(BuildContext context){
        final theme = Theme.of(context);
        return ElevatedButton.icon(
            icon: Icon(icon, size: 14),
            label: Text(text, style: theme.textTheme.bodySmall),
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                foregroundColor: theme.colorScheme.onSurfaceVariant,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36)
            )
        );
    }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Map<String, Color> statusColors = {
      "Selesai Dijemput": kSoftTeal,
      "Kurir Menuju Lokasi": kInfoColor,
      "Menunggu Kurir": kWarmOrange,
    };
    final color = statusColors[status] ?? kWarmOrange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: theme.textTheme.bodySmall!.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}


class _ChartPainter extends CustomPainter {
  final List<Triple<String, String, DayOrderStats>> daysData;
  final int selectedIndex;
  final int maxOrders;
  final ThemeData theme;

  _ChartPainter({
    required this.daysData,
    required this.selectedIndex,
    required this.maxOrders,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final colWidth = size.width / 7;
    final topPadding = 20;
    final bottomPadding = 20;
    final chartHeight = size.height - topPadding - bottomPadding;
    final barWidth = 16.0;

    final gridLinePaint = Paint()
      ..color = const Color(0xFF2E3E66).withAlpha(3)
      ..strokeWidth = 1;

    for (int i = 0; i <= 3; i++) {
      final y = topPadding + (i / 3) * chartHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridLinePaint);
    }

    for (int i = 0; i < daysData.length; i++) {
      final stats = daysData[i].third;
      final x = colWidth * i + colWidth / 2;
      final isSelected = i == selectedIndex;

      if (stats.total > 0) {
        final compHeight = (stats.completed / maxOrders) * chartHeight;
        final awatHeight = (stats.awaiting / maxOrders) * chartHeight;

        final compTopY = size.height - bottomPadding - compHeight;
        final compRect = Rect.fromLTWH(x - barWidth / 2, compTopY, barWidth, compHeight);
        final compPaint = Paint()..color = isSelected ? kSoftTeal : kSoftTeal.withAlpha(7);
        canvas.drawRect(compRect, compPaint);

        final awatTopY = compTopY - awatHeight;
        final awatRect = Rect.fromLTWH(x - barWidth / 2, awatTopY, barWidth, awatHeight);
        final awatPaint = Paint()..color = isSelected ? kWarmOrange : kWarmOrange.withAlpha(7);
        canvas.drawRect(awatRect, awatPaint);
      }

      if (isSelected) {
        final selectionPaint = Paint()
          ..color = Colors.white.withAlpha(15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        final selectionRect = Rect.fromLTWH(colWidth * i + 2, topPadding - 10, colWidth - 4, chartHeight + 20);
        canvas.drawRect(selectionRect, selectionPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex || oldDelegate.daysData != daysData;
  }
}

class Triple<A, B, C> {
  final A first;
  final B second;
  final C third;
  Triple(this.first, this.second, this.third);
}
