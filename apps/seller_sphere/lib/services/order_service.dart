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
    final orderRef = _dbRef.child('orders');
    final controller = StreamController<List<Order>>();

    orderRef.onValue.listen((event) {
      final data = event.snapshot.value;
      final List<Order> orders = [];

      if (data != null && data is Map) {
        final ordersMap = Map<String, dynamic>.from(data);

        ordersMap.forEach((key, value) {
          final orderData = Map<String, dynamic>.from(value as Map);

          if (orderData['shopId'] == shopId) {
            orders.add(Order.fromMap(orderData, key));
          }
        });
      }
      controller.add(orders);
    }, onError: (error) {
      // Handle error, maybe log it or add an error state to the stream
      controller.addError(error);
    });

    return controller.stream;
  }
}
