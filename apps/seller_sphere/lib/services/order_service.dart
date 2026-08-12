
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_services/models/order_model.dart';

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
            // Konversi `List<Map>` items dari Firebase menjadi `List<OrderItem>`.
            final List<OrderItem> items = [];
            final firebaseItems = orderData['items'];

            if (firebaseItems != null && firebaseItems is List) {
              for (var itemData in firebaseItems) {
                if (itemData is Map) {
                  final itemMap = Map<String, dynamic>.from(itemData);
                  items.add(OrderItem(
                    productId: itemMap['productId']?.toString() ?? '',
                    productName: itemMap['productName']?.toString() ?? '',
                    quantity: (itemMap['quantity'] as num?)?.toInt() ?? 0,
                    price: (itemMap['price'] as num?)?.toDouble() ?? 0.0,
                  ));
                }
              }
            }
          }
        });
      }
      // Kirim daftar pesanan yang sudah diproses ke stream.
      controller.add(orders);
    });
    return controller.stream;
  }
}
