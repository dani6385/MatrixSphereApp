
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_services/models/order_model.dart';
import 'package:shared_services/models/cart_item_model.dart';

// Kelas ini bertanggung jawab untuk berinteraksi dengan Firebase Realtime Database
// untuk semua yang berhubungan dengan pesanan (orders).
class OrderService {
  // Membuat referensi ke root database Firebase Anda.
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Mengambil stream (aliran data) pesanan untuk sebuah toko spesifik.
  ///
  /// Menggunakan [Stream] berarti setiap kali ada data baru atau perubahan data
  /// di Firebase, UI akan otomatis diperbarui.
  ///
  /// [shopId] adalah ID dari toko yang sedang login (contoh: "toko_agan").
  Stream<List<Order>> getOrdersStream(String shopId) {
    // Referensi ke 'orders' di database.
    final orderRef = _dbRef.child('orders');
    final controller = StreamController<List<Order>>();

    // .onValue adalah listener yang akan terus-menerus mendengarkan perubahan
    // pada path 'orders'.
    orderRef.onValue.listen((event) {
      final data = event.snapshot.value;
      final List<Order> orders = [];

      if (data != null && data is Map) {
        final ordersMap = Map<String, dynamic>.from(data);

        // Iterasi melalui setiap data pesanan yang ada di Firebase.
        ordersMap.forEach((key, value) {
          final orderData = Map<String, dynamic>.from(value);

          // SANGAT PENTING: Filter pesanan hanya untuk toko yang relevan.
          if (orderData['shopId'] == shopId) {
            
            // Konversi `Map` items dari Firebase menjadi `List<CartItem>`.
            final itemsMap = Map<String, dynamic>.from(orderData['items'] ?? {});
            final List<CartItem> items = [];
            itemsMap.forEach((productName, price) {
              items.add(CartItem(
                productId: productName, // Asumsi ID produk = nama produk
                productName: productName,
                quantity: 1, // Asumsi kuantitas 1 karena tidak ada datanya
                sellingPrice: (price as num).toDouble(), product: null,
              ));
            });
            
            // Membuat objek Order dari data.
            orders.add(Order.fromMap(
                'orderId': key,
                'buyerId': orderData['buyerId'],
                'shopId': orderData['shopId'],
                'items': items, // Menggunakan list yang sudah dikonversi
                'totalAmount': (orderData['totalAmount'] as num).toDouble(),
                'status': orderData['status'] ?? 'processing',
                // Anda harus menyimpan tanggal dalam format timestamp di Firebase,
                // untuk saat ini kita gunakan waktu sekarang sebagai placeholder.
                'orderDate': DateTime.now().toIso8601String(),
                'customerName': orderData['buyerId'] ?? 'Unknown',
            ),
            );
          }
        });
      }
      // Kirim daftar pesanan yang sudah diproses ke stream.
      controller.add(orders);
    });

    return controller.stream;
  }
}
