import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shop_sphere/presentation/cart_screens/providers/cart_provider.dart'; // Untuk menggunakan CartItem


/// Enum untuk status pesanan.
enum OrderStatus {
  processing, // Diproses
  readyForPickup, // Silahkan Jemput
  completed, // Pesanan Selesai
}

/// Model untuk satu item dalam sebuah pesanan.
class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

/// Model untuk satu pesanan.
class Order {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final String verificationCode;
  final OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.paymentMethod,
    required this.verificationCode,
    this.status = OrderStatus.processing, // Status default
  });
}

/// Provider untuk mengelola riwayat pesanan.
class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  Order addOrder(List<CartItem> cartItems, double total, String paymentMethod) {
    // Menghasilkan kode verifikasi 6 digit acak.
    final verificationCode = (100000 + Random().nextInt(900000)).toString();

    final newOrder = Order(
      id: DateTime.now().toIso8601String(),
      items: cartItems
          .map((cartItem) => OrderItem(
                id: cartItem.productId,
                name: cartItem.name,
                quantity: cartItem.quantity,
                price: cartItem.price,
                imageUrl: cartItem.imageUrl,
              ))
          .toList(),
      totalAmount: total,
      orderDate: DateTime.now(),
      paymentMethod: paymentMethod,
      verificationCode: verificationCode,
      status: OrderStatus.processing, // Setiap pesanan baru akan berstatus "Diproses"
    );
    _orders.insert(0, newOrder); // Tambahkan ke awal daftar
    notifyListeners();
    return newOrder;
  }

  /// Mencari pesanan berdasarkan ID.
  /// Mengembalikan [Order] jika ditemukan, atau `null` jika tidak ada.
  Order? findById(String orderId) {
    // Menggunakan firstWhereOrNull dari package:collection akan lebih efisien,
    // namun untuk menghindari penambahan dependensi, kita bisa menggunakan try-catch.
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null; // Tidak ditemukan
    }
  }
}