import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_services/models/order_model.dart';
import 'package:shared_ui/shared_ui.dart'; // Menggunakan AppSpacing dari shared_ui
import '../widgets/order_detail_screen.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

class OrderListView extends StatefulWidget {
  // Hapus parameter `orders` yang tidak digunakan.
  // Jadikan `shopId` sebagai parameter utama untuk widget ini.
  const OrderListView(
      {super.key, required this.shopId, required List<Order> orders});

  final String shopId;

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  // Query akan diinisialisasi di initState untuk menggunakan `widget.shopId`
  late final Query _ordersQuery;

  @override
  void initState() {
    super.initState();
    // Buat query yang memfilter pesanan berdasarkan 'shopId' dari widget.
    _ordersQuery = FirebaseDatabase.instance
        .ref('orders')
        .orderByChild('shopId')
        .equalTo(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hapus AppBar dari sini agar tidak duplikat jika widget ini
      // digunakan di dalam screen yang sudah punya AppBar.
      // Jika ini adalah screen mandiri, biarkan AppBar-nya.
      // appBar: AppBar(
      //   title: const Text('Daftar Pesanan'),
      // ),
      body: FirebaseAnimatedList(
        query:
            _ordersQuery, // HANYA gunakan query yang sudah difilter berdasarkan shopId
        reverse: true, // Tampilkan pesanan terbaru di atas
        padding: const EdgeInsets.all(AppSpacing.md),
        itemBuilder: (context, snapshot, animation, index) {
          // Gunakan model `Order` untuk parsing yang lebih aman dan bersih
          if (!snapshot.exists || snapshot.value == null) {
            return const SizedBox.shrink();
          }

          // Konversi data snapshot ke Map dan buat objek Order
          final orderDataMap = Map<String, dynamic>.from(snapshot.value as Map);
          final order =
              Order.fromMap(orderDataMap, snapshot.key!);

          // Gunakan FadeTransition untuk animasi yang bagus saat item muncul
          return SizeTransition(
            sizeFactor: animation,
            child: buildOrderItemCard(context, order),
          );
        },
        // Widget yang ditampilkan jika query tidak menghasilkan data
        defaultChild: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 80, color: Colors.grey[400]),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Belum Ada Pesanan',
                style: AppStyles.titleMedium.copyWith(color: Colors.grey[600]),
              ),
              const Text(
                'Pesanan baru untuk toko ini akan muncul di sini.',
                style: AppStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderItemCard(BuildContext context, Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 2,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        title: Text(
          order.customerName,
          style: AppStyles.titleMedium,
        ),
        subtitle: Text(
          'ID: ${order.orderId}\n${DateFormat.yMMMd('id_ID').add_jm().format(order.orderDate)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              NumberFormat.currency(
                      locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
                  .format(order.totalAmount),
              style: AppStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: order.status.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                order.status.displayName,
                style: AppStyles.bodySmall.copyWith(
                  color: order.status.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          _logger.i('Menu Promotions diklik!');
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: order),
            ),
          );
        },
      ),
    );
  }
}
