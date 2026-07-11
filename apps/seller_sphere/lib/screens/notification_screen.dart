import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';
import '../viewmodels/app_view_model.dart'; // Assuming viewmodel is in this path

class NotificationScreen extends StatefulWidget {
  final VoidCallback onNavigateToInventory;

  const NotificationScreen({super.key, required this.onNavigateToInventory, required void Function() onNavigateBack});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _activeTab = 0; // 0: Semua, 1: Peringatan Stok, 2: Aktivitas Toko

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    final notifications = viewModel.notifications;
    final lowStockList = viewModel.lowStockProducts;

    final filteredGeneralNotifs = notifications.where((n) {
      if (_activeTab == 0) return true;
      if (_activeTab == 1) return n.title.contains("Stok");
      return !n.title.contains("Stok");
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pusat Notifikasi",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kNeonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (notifications.isNotEmpty && _activeTab != 1)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: kRadiantRose),
              onPressed: () =>
                  context.read<AppViewModel>().clearNotifications(),
              tooltip: "Bersihkan Semua",
            ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _TabSelector(
              activeTab: _activeTab,
              notificationCount: notifications.length,
              lowStockCount: lowStockList.length,
              onTabChanged: (index) => setState(() => _activeTab = index),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    final viewModel = context.watch<AppViewModel>();
    final notifications = viewModel.notifications;
    final lowStockList = viewModel.lowStockProducts;

    // Content for "Peringatan Stok"
    if (_activeTab == 1) {
      if (lowStockList.isEmpty) {
        return const NotificationEmptyState(
          message:
              "Stok barang Anda aman dan melimpah. Tidak ada barang di bawah ambang batas.",
          icon: Icons.notifications,
        );
      }
      return ListView.builder(
        itemCount: lowStockList.length,
        itemBuilder: (context, index) {
          final product = lowStockList[index];
          return _LowStockNotificationCard(
            product: product,
            onNavigateToInventory: widget.onNavigateToInventory,
          );
        },
      );
    }

    // Content for "Semua" and "Aktivitas"
    final generalNotifications = notifications.where((n) {
      if (_activeTab == 0) return true;
      return !n.title.toLowerCase().contains('stok');
    }).toList();

    final itemsToShow = _activeTab == 0
        ? [...lowStockList, ...generalNotifications]
        : generalNotifications;

    if (itemsToShow.isEmpty) {
      return const NotificationEmptyState(
        message:
            "Belum ada riwayat notifikasi baru. Semua aktivitas Anda tercatat di sini.",
        icon: Icons.notifications,
      );
    }

    return ListView.builder(
      itemCount: itemsToShow.length,
      itemBuilder: (context, index) {
        final item = itemsToShow[index];
        if (item is Product) {
          return _LowStockNotificationCard(
            product: item,
            onNavigateToInventory: widget.onNavigateToInventory,
          );
        } else if (item is NotificationItem) {
          return _GeneralNotificationCard(notification: item);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _TabSelector extends StatelessWidget {
  final int activeTab;
  final int notificationCount;
  final int lowStockCount;
  final Function(int) onTabChanged;

  const _TabSelector({
    required this.activeTab,
    required this.notificationCount,
    required this.lowStockCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activityCount = notificationCount - notificationCount;

    return Row(
      children: [
        _buildTab(
          context,
          title: "Semua",
          index: 0,
          count: notificationCount + lowStockCount,
        ),
        const SizedBox(width: 8),
        _buildTab(
          context,
          title: "Peringatan Stok",
          index: 1,
          count: lowStockCount,
          activeColor: kWarmOrange,
        ),
        const SizedBox(width: 8),
        _buildTab(context, title: "Aktivitas", index: 2, count: activityCount),
      ],
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required int index,
    required int count,
    Color? activeColor,
  }) {
    final isSelected = activeTab == index;
    final color = activeColor ?? kNeonCyan;

    return Expanded(
      child: InkWell(
        onTap: () => onTabChanged(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : Colors.transparent,
            border: Border.all(
              color: isSelected ? color : kSlateBorder.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : kSlateTextSecondary,
                ),
              ),
              if (count > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: color,
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LowStockNotificationCard extends StatelessWidget {
  final Product product;
  final VoidCallback onNavigateToInventory;

  const _LowStockNotificationCard({
    required this.product,
    required this.onNavigateToInventory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: kWarmOrange.withValues(alpha: 0.5)),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onNavigateToInventory,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: kWarmOrange.withValues(alpha: 0.15),
                child: const Icon(Icons.warning, color: kWarmOrange, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Stok Menipis!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWarmOrange,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Produk "${product.name}" tersisa ${product.stock} unit. Klik untuk mengelola stok.',
                      style: const TextStyle(fontSize: 12),
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

class _GeneralNotificationCard extends StatelessWidget {
  final NotificationItem notification;
  const _GeneralNotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final sdf = DateFormat("dd MMM, HH:mm", "id_ID");

    final iconInfo = _getIconInfo(notification.title);

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: kSlateBorder.withOpacity(0.3)),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconInfo.color.withValues(alpha: 0.12),
              child: Icon(iconInfo.icon, color: iconInfo.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        sdf.format(
                          DateTime.fromMillisecondsSinceEpoch(
                            notification.timestamp,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 10,
                          color: kSlateTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: kSlateTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 16),
              onPressed: () => context.read<AppViewModel>().deleteNotification(
                notification.id,
              ),
              tooltip: "Hapus",
            ),
          ],
        ),
      ),
    );
  }

  ({IconData icon, Color color}) _getIconInfo(String title) {
    if (title.contains("Cetak") || title.contains("Printer")) {
      return (icon: Icons.print, color: kSoftTeal);
    }
    if (title.contains("Transaksi") || title.contains("Bayar")) {
      return (icon: Icons.receipt, color: kNeonCyan);
    }
    if (title.contains("Sinkronisasi") || title.contains("Impor")) {
      return (icon: Icons.sync, color: kElectricBlue);
    }
    if (title.contains("Stok") || title.contains("Habis")) {
      return (icon: Icons.warning, color: kRadiantRose);
    }
    return (icon: Icons.info, color: kNeonCyan);
  }
}

class NotificationEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const NotificationEmptyState({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: kNeonCyan.withValues(alpha: 0.1),
              child: Icon(icon, size: 40, color: kNeonCyan),
            ),
            const SizedBox(height: 16),
            const Text(
              "Belum Ada Notifikasi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: kSlateTextSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
