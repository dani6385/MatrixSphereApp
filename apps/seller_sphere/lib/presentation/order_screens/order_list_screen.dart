import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
// Impor provider dari lokasi yang benar
import 'package:seller_sphere/presentation/order_screens/providers/order_provider.dart';

class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Gunakan ref.watch untuk mendapatkan state dari provider
    final ordersAsync = ref.watch(filteredOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan'),
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Terjadi kesalahan: $err')),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('Tidak ada pesanan.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text('Pesanan #${order.id} - ${order.customerName}'),
                  subtitle: Text(
                    '${order.items.length} item • Rp ${order.totalAmount.toStringAsFixed(0)}\n${DateFormat('dd MMM yyyy, HH:mm').format(order.orderDate)}',
                  ),
                  trailing: Chip(
                    label: Text(
                      _getStatusText(order.status),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: _getStatusColor(order.status),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  isThreeLine: true,
                  onTap: () {
                    context.push('/orders/${order.id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getStatusText(PickupStatus status) {
    switch (status) {
      case PickupStatus.newOrder:
        return 'Baru';
      case PickupStatus.preparing:
        return 'Disiapkan';
      case PickupStatus.readyForPickup:
        return 'Siap Diambil';
      case PickupStatus.completed:
        return 'Selesai';
      case PickupStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  Color _getStatusColor(PickupStatus status) {
    switch (status) {
      case PickupStatus.newOrder:
        return Colors.blue.shade700;
      case PickupStatus.preparing:
        return Colors.orange.shade700;
      case PickupStatus.readyForPickup:
        return Colors.purple.shade700;
      case PickupStatus.completed:
        return Colors.green.shade700;
      case PickupStatus.cancelled:
        return Colors.grey.shade700;
    }
  }
}
