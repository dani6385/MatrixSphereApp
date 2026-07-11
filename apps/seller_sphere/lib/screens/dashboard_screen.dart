import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../viewmodels/app_view_model.dart';
import 'package:shared_ui/shared_ui.dart';

// --- DASHBOARD SCREEN ---
class DashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToInventory;
  final VoidCallback onNavigateToTransactions;

  const DashboardScreen({
    super.key,
    required this.onNavigateToInventory,
    required this.onNavigateToTransactions,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final lowStockList = viewModel.lowStockProducts;
    final todaySalesTotal = viewModel.getTodaySalesTotal();
    final targetValue = viewModel.todayTarget?.targetAmount ?? 1000000.0;
    final targetProgress =
        targetValue > 0 ? (todaySalesTotal / targetValue).clamp(0.0, 1.0) : 1.0;
    final targetPercentage = (targetProgress * 100).toInt();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _HeroBanner(),
          const SizedBox(height: 16),
          if (lowStockList.isNotEmpty) ...[
            _LowStockWarningCard(
              lowStockCount: lowStockList.length,
              onTap: onNavigateToInventory,
            ),
            const SizedBox(height: 16),
          ],
          _DailyTargetCard(
            viewModel: viewModel,
            todaySalesTotal: todaySalesTotal,
            targetValue: targetValue,
            targetPercentage: targetPercentage,
          ),
          const SizedBox(height: 16),
          _PickupSummaryCards(orders: viewModel.shopsphereOrders),
          const SizedBox(height: 16),
          _ShopsphereWeeklyOrderChart(orders: viewModel.shopsphereOrders),
          const SizedBox(height: 16),
          _MainActionButtons(
            onNavigateToTransactions: onNavigateToTransactions,
            onNavigateToInventory: onNavigateToInventory,
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/img_hero_banner.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, const Color(0xCC090D1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.5, 1.0],
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
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
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
    );
  }
}

class _LowStockWarningCard extends StatelessWidget {
  final int lowStockCount;
  final VoidCallback onTap;

  const _LowStockWarningCard({
    required this.lowStockCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                Icons.warning,
                color: Theme.of(context).colorScheme.error,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Peringatan Stok Menipis! ($lowStockCount Produk)",
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
}

class _DailyTargetCard extends StatefulWidget {
  final AppViewModel viewModel;
  final double todaySalesTotal;
  final double targetValue;
  final int targetPercentage;

  const _DailyTargetCard({
    required this.viewModel,
    required this.todaySalesTotal,
    required this.targetValue,
    required this.targetPercentage,
  });

  @override
  __DailyTargetCardState createState() => __DailyTargetCardState();
}

class __DailyTargetCardState extends State<_DailyTargetCard> {
  void _showTargetDialog() {
    showDialog(
      context: context,
      builder: (context) => _TargetDialog(
        initialValue: widget.targetValue,
        onSave: (newTarget) {
          widget.viewModel.updateTodayTarget(newTarget);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String motivationText;
    if (widget.todaySalesTotal == 0.0) {
      motivationText =
          "Semangat! Mulai hari ini dengan menambahkan penjualan pertama Anda. Target Anda hari ini adalah ${widget.viewModel.formatRupiah(widget.targetValue)}.";
    } else if (widget.targetPercentage < 50) {
      motivationText =
          "Anda sudah mencapai ${widget.targetPercentage}% dari target hari ini. Terus maju, sisa ${widget.viewModel.formatRupiah(widget.targetValue - widget.todaySalesTotal)} lagi!";
    } else if (widget.targetPercentage < 100) {
      motivationText =
          "Hampir sampai! ${widget.targetPercentage}% target tercapai. Tambah beberapa transaksi lagi untuk mencapai sukses hari ini!";
    } else {
      motivationText =
          "Luar biasa! Target penjualan hari ini TELAH TERCAPAI (${widget.targetPercentage}%). Pertahankan kinerja hebat ini! 🎉";
    }

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.notifications_active,
                      color: kWarmOrange,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Target Penjualan Harian",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: _showTargetDialog,
                  child: Text(
                    "Ubah",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.0,
                end: (widget.todaySalesTotal / widget.targetValue).clamp(
                  0.0,
                  1.0,
                ),
              ),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) => LinearProgressIndicator(
                value: value,
                minHeight: 16,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: const Color(0xFF2E3E66),
                valueColor: const AlwaysStoppedAnimation<Color>(kWarmOrange),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.viewModel.formatRupiah(widget.todaySalesTotal)} / ${widget.viewModel.formatRupiah(widget.targetValue)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${widget.targetPercentage}%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.targetPercentage >= 100
                        ? kSoftTeal
                        : kWarmOrange,
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
}

class _TargetDialog extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onSave;

  const _TargetDialog({required this.initialValue, required this.onSave});

  @override
  __TargetDialogState createState() => __TargetDialogState();
}

class __TargetDialogState extends State<_TargetDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue.toInt().toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text(
        "Atur Target Penjualan Harian",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Target Rp",
          prefixText: "Rp ",
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Batal",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            final amount = double.tryParse(_controller.text) ?? 0.0;
            widget.onSave(amount);
            Navigator.of(context).pop();
          },
          child: const Text(
            "Simpan",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _PickupSummaryCards extends StatelessWidget {
  final List<ShopsphereOrder> orders;
  const _PickupSummaryCards({required this.orders});

  @override
  Widget build(BuildContext context) {
    final todayOrders = orders.where((it) => it.dayIndex == 6).toList();
    final awaitingPickupCount =
        todayOrders.where((it) => it.status != "Selesai Diambil").length;
    final pickedUpCount =
        todayOrders.where((it) => it.status == "Selesai Diambil").length;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: "Belum Diambil",
            value: "$awaitingPickupCount Paket",
            icon: Icons.warning,
            color: kWarmOrange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: "Selesai Diambil",
            value: "$pickedUpCount Paket",
            icon: Icons.check_circle,
            color: kSoftTeal,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopsphereWeeklyOrderChart extends StatefulWidget {
  final List<ShopsphereOrder> orders;

  const _ShopsphereWeeklyOrderChart({required this.orders});

  @override
  __ShopsphereWeeklyOrderChartState createState() =>
      __ShopsphereWeeklyOrderChartState();
}

class DayOrderStats {
  final int completed;
  final int awaiting;
  DayOrderStats(this.completed, this.awaiting);
  int get total => completed + awaiting;
}

class __ShopsphereWeeklyOrderChartState
    extends State<_ShopsphereWeeklyOrderChart> {
  int _selectedIndex = 6;
  late List<Triple<String, String, DayOrderStats>> daysData;

  @override
  void initState() {
    super.initState();
    _updateDaysData();
  }

  @override
  void didUpdateWidget(covariant _ShopsphereWeeklyOrderChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.orders != oldWidget.orders) {
      _updateDaysData();
    }
  }

  void _updateDaysData() {
    final sdfLabel = DateFormat("E", "id_ID");
    final sdfDate = DateFormat("dd/MM");
    final list = <Triple<String, String, DayOrderStats>>[];

    for (int i = 0; i <= 6; i++) {
      final checkCalendar = DateTime.now().subtract(Duration(days: 6 - i));
      final dateStr = sdfDate.format(checkCalendar);
      final dayLabel = sdfLabel.format(checkCalendar);

      final dayOrders = widget.orders.where((o) => o.dayIndex == i).toList();
      final completed =
          dayOrders.where((o) => o.status == "Selesai Diambil").length;
      final awaiting = dayOrders.length - completed;

      list.add(Triple(dayLabel, dateStr, DayOrderStats(completed, awaiting)));
    }
    daysData = list;
  }

  @override
  Widget build(BuildContext context) {
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
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            _ChartLegend(totalOrders: daysData[_selectedIndex].third.total),
            const SizedBox(height: 16),
            _Chart(
              daysData: daysData,
              selectedIndex: _selectedIndex,
              onBarTapped: (index) => setState(() => _selectedIndex = index),
            ),
            const SizedBox(height: 8),
            _ChartLabels(
              daysData: daysData,
              selectedIndex: _selectedIndex,
              onLabelTapped: (index) => setState(() => _selectedIndex = index),
            ),
            const SizedBox(height: 16),
            _OrderListForSelectedDay(
              dayName: daysData[_selectedIndex].first,
              dateStr: daysData[_selectedIndex].second,
              orders: widget.orders
                  .where((o) => o.dayIndex == _selectedIndex)
                  .toList(),
              viewModel: context.read<AppViewModel>(),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MAIN ACTION BUTTONS ---
class _MainActionButtons extends StatelessWidget {
  final VoidCallback onNavigateToTransactions;
  final VoidCallback onNavigateToInventory;

  const _MainActionButtons({
    required this.onNavigateToTransactions,
    required this.onNavigateToInventory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onNavigateToTransactions,
            icon: const Icon(Icons.add),
            label: const Text("Kasir (POS)"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// A simple Triple class, you can use a package like `tuple` as well
class Triple<A, B, C> {
  final A first;
  final B second;
  final C third;
  Triple(this.first, this.second, this.third);
}

// --- WIDGETS FOR THE CHART ---

class _ChartLegend extends StatelessWidget {
  final int totalOrders;
  const _ChartLegend({required this.totalOrders});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _LegendItem(color: kSoftTeal, label: "Selesai"),
            const SizedBox(width: 12),
            _LegendItem(color: kWarmOrange, label: "Belum"),
          ],
        ),
        Text(
          "$totalOrders Pesanan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
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
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  final List<Triple<String, String, DayOrderStats>> daysData;
  final int selectedIndex;
  final ValueChanged<int> onBarTapped;

  const _Chart({
    required this.daysData,
    required this.selectedIndex,
    required this.onBarTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final barWidth = box.size.width / 7;
        final index = (details.localPosition.dx / barWidth).floor().clamp(0, 6);
        onBarTapped(index);
      },
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: CustomPaint(
          painter: _WeeklyChartPainter(
            daysData.map((d) => d.third).toList(),
            selectedIndex,
          ),
        ),
      ),
    );
  }
}

class _WeeklyChartPainter extends CustomPainter {
  final List<DayOrderStats> stats;
  final int selectedIndex;
  _WeeklyChartPainter(this.stats, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final colWidth = size.width / 7;
    final maxOrders = stats.map((s) => s.total).reduce(max).clamp(5, 999);

    final gridPaint = Paint()
      ..color = const Color(0xFF2E3E66).withValues(alpha: 0.3)
      ..strokeWidth = 1;

    for (int i = 0; i <= 3; i++) {
      final y = size.height - (i / 3.0) * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (int i = 0; i < stats.length; i++) {
      final stat = stats[i];
      final totalHeight = (stat.total / maxOrders) * size.height;
      final completedHeight = (stat.completed / maxOrders) * size.height;
      final awaitingHeight = totalHeight - completedHeight;

      final barX = colWidth * i + (colWidth - 16) / 2;

      if (i == selectedIndex) {
        final selectedPaint = Paint()..color = Colors.white.withValues(alpha: 0.15);
        canvas.drawRect(
          Rect.fromLTWH(colWidth * i, 0, colWidth, size.height),
          selectedPaint,
        );
      }

      // Completed bar
      canvas.drawRect(
        Rect.fromLTWH(barX, size.height - completedHeight, 16, completedHeight),
        Paint()..color = i == selectedIndex ? kSoftTeal : kSoftTeal.withValues(alpha: 0.7),
      );

      // Awaiting bar
      canvas.drawRect(
        Rect.fromLTWH(barX, size.height - totalHeight, 16, awaitingHeight),
        Paint()
          ..color =
              i == selectedIndex ? kWarmOrange : kWarmOrange.withValues(alpha: 0.7),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ChartLabels extends StatelessWidget {
  final List<Triple<String, String, DayOrderStats>> daysData;
  final int selectedIndex;
  final ValueChanged<int> onLabelTapped;

  const _ChartLabels({
    required this.daysData,
    required this.selectedIndex,
    required this.onLabelTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final isSelected = i == selectedIndex;
        return InkWell(
          onTap: () => onLabelTapped(i),
          child: Column(
            children: [
              Text(
                daysData[i].first,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                daysData[i].second,
                style: TextStyle(
                  fontSize: 9,
                  color: isSelected
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.8)
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _OrderListForSelectedDay extends StatelessWidget {
  final String dayName;
  final String dateStr;
  final List<ShopsphereOrder> orders;
  final AppViewModel viewModel;

  const _OrderListForSelectedDay({
    required this.dayName,
    required this.dateStr,
    required this.orders,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daftar Paket Hari $dayName ($dateStr)",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        if (orders.isEmpty)
          Card(
            color: const Color(0xFF0F172A).withValues(alpha: 0.4),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "Tidak ada orderan masuk untuk tanggal ini.",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          )
        else
          ...orders.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: OrderPickupItem(order: order, viewModel: viewModel),
            ),
          ),
      ],
    );
  }
}

class OrderPickupItem extends StatelessWidget {
  final ShopsphereOrder order;
  final AppViewModel viewModel;

  const OrderPickupItem({super.key, required this.order, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isPickedUp = order.status == "Selesai Diambil";

    return Card(
      color: isPickedUp
          ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.id,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isPickedUp ? null : Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      "Pembeli: ${order.customerName}",
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                _StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${order.productName} x${order.quantity}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  viewModel.formatRupiah(order.totalAmount),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "No. HP Pembeli: ${order.courierPhone}",
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.8),
                ),
              ),
            ),
            if (!isPickedUp) ...[
              const SizedBox(height: 10),
              _ActionButtons(order: order, viewModel: viewModel),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case "Selesai Diambil":
        color = kSoftTeal;
        break;
      case "Siap Diambil":
        color = kNeonCyan;
        break;
      default:
        color = kWarmOrange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final ShopsphereOrder order;
  final AppViewModel viewModel;
  const _ActionButtons({required this.order, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (order.status == "Perlu Dipacking") {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => viewModel.finishPacking(order.id),
          icon: const Icon(Icons.check_circle, size: 16),
          label: const Text(
            "Barang Selesai, Silakan Ambil",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kNeonCyan,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }
    if (order.status == "Siap Diambil") {
      return Row(
        children: [
          Expanded(
            flex: 13,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call, size: 14),
              label: const Text("Hubungi", style: TextStyle(fontSize: 11)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 12,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.print, size: 14),
              label: const Text("Cetak", style: TextStyle(fontSize: 11)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 18,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => _OrderVerificationDialog(
                    order: order,
                    onVerifySuccess: () =>
                        viewModel.confirmOrderPickup(order.id),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle, size: 14),
              label: const Text(
                "Konfirmasi",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kSoftTeal,
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

class _OrderVerificationDialog extends StatelessWidget {
  final ShopsphereOrder order;
  final VoidCallback onVerifySuccess;
  const _OrderVerificationDialog({
    required this.order,
    required this.onVerifySuccess,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Verifikasi Pengambilan"),
      content: Text(
        "Arahkan kamera ke barcode pembeli atau masukkan kode: ${order.verificationCode}",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () {
            onVerifySuccess();
            Navigator.of(context).pop();
          },
          child: const Text("Verifikasi (Simulasi)"),
        ),
      ],
    );
  }
}
