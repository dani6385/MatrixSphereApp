import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/presentation/order_screens/providers/order_provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shop_sphere/presentation/cart_screens/providers/cart_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        backgroundColor: AppColors.surface,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.orders.isEmpty) {
            return const Center(
              child: Text('Anda belum memiliki riwayat pesanan.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderProvider.orders.length,
            itemBuilder: (context, index) {
              final order = orderProvider.orders[index];
              return OrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          'Pesanan: ${DateFormat('dd MMM yyyy').format(order.orderDate)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Total: Rp ${order.totalAmount.toStringAsFixed(0)}',
          style: const TextStyle(color: AppColors.primary),
        ),
        trailing: Chip(
          label: Text(
            _getStatusText(order.status),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: _getStatusColor(order.status),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                ...order.items.map((item) => _buildOrderItem(item)),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.storefront, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Expanded(child: Text('Pesanan ini diambil langsung di toko.', style: TextStyle(fontStyle: FontStyle.italic))),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Metode Pembayaran'), Text(order.paymentMethod, style: const TextStyle(fontWeight: FontWeight.bold))],
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Rp ${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                if (order.status == OrderStatus.completed) ...[
                  const SizedBox(height: 16),
                  _buildReorderButton(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReorderButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.replay),
        label: const Text('Pesan Lagi'),
        onPressed: () {
          final cart = Provider.of<CartProvider>(context, listen: false);
          for (var item in order.items) {
            cart.addItem(
              productId: item.id, // Pastikan OrderItem.id sesuai dengan Product.id
              name: item.name,
              price: item.price,
              imageUrl: item.imageUrl,
              quantity: item.quantity,
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Semua item dari pesanan telah ditambahkan kembali ke keranjang.'),
            duration: Duration(seconds: 3),
          ));
          // Arahkan pengguna ke halaman keranjang untuk melihat item yang baru ditambahkan
          context.go('/cart');
        },
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('${item.name} (x${item.quantity})')),
          Text('Rp ${(item.price * item.quantity).toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'Diproses';
      case OrderStatus.readyForPickup:
        return 'Siap Diambil';
      case OrderStatus.completed:
        return 'Selesai';
      }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Colors.orange.shade700;
      case OrderStatus.readyForPickup:
        return Colors.blue.shade700;
      case OrderStatus.completed:
        return Colors.green.shade700;
      }
  }
}