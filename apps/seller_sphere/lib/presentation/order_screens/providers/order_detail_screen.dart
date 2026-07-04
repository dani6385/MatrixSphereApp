import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/presentation/order_screens/providers/order_provider.dart';
import 'package:shared_ui/shared_ui.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.findById(orderId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan #${order.id}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: 'Informasi Pelanggan',
            child: Card(
              child: ListTile(
                title: Text(order.customerName),
                leading: const Icon(Icons.person),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Item Pesanan',
            child: Card(
              child: Column(
                children: order.items
                    .map((item) => ListTile(
                          title: Text(item.name),
                          subtitle: Text('x${item.quantity}'),
                          trailing: Text('Rp ${item.price.toStringAsFixed(0)}'),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Ringkasan Pembayaran',
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Metode Pembayaran'),
                    trailing: Text(order.paymentMethod, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    title: const Text('Total Pesanan'),
                    trailing: Text('Rp ${order.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Ubah Status Pesanan',
            child: SegmentedButton<OrderStatus>(
              segments: const [
                ButtonSegment(value: OrderStatus.processing, label: Text('Diproses'), icon: Icon(Icons.hourglass_top)),
                ButtonSegment(value: OrderStatus.readyForPickup, label: Text('Siap Diambil'), icon: Icon(Icons.inventory_2)),
                ButtonSegment(value: OrderStatus.completed, label: Text('Selesai'), icon: Icon(Icons.check_circle)),
              ],
              selected: {order.status},
              onSelectionChanged: (newSelection) {
                orderProvider.updateOrderStatus(orderId, newSelection.first);
              },
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: AppColors.primary.withAlpha(2),
                selectedForegroundColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}