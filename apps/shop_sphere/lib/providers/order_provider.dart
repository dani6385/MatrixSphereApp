import 'package:flutter/foundation.dart';
import 'package:shop_sphere/providers/cart_provider.dart'; // Untuk menggunakan CartItem


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
  final OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.paymentMethod,
    this.status = OrderStatus.processing, // Status default
  });
}

/// Provider untuk mengelola riwayat pesanan.
class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder(List<CartItem> cartItems, double total, String paymentMethod) {
    final newOrder = Order(
      id: DateTime.now().toIso8601String(),
      items: cartItems
          .map((cartItem) => OrderItem(
                id: cartItem.id,
                name: cartItem.name,
                quantity: cartItem.quantity,
                price: cartItem.price,
                imageUrl: cartItem.imageUrl,
              ))
          .toList(),
      totalAmount: total,
      orderDate: DateTime.now(),
      paymentMethod: paymentMethod,
      status: OrderStatus.processing, // Setiap pesanan baru akan berstatus "Diproses"
    );
    _orders.insert(0, newOrder); // Tambahkan ke awal daftar
    notifyListeners();
  }
}