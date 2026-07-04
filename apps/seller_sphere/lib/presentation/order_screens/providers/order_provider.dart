import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Definisikan provider di sini
final orderProvider = ChangeNotifierProvider((ref) => OrderProvider());

/// Enum untuk status pesanan.
enum OrderStatus {
  processing, // Diproses
  readyForPickup, // Siap Diambil
  completed, // Pesanan Selesai
}

/// Model untuk satu item dalam sebuah pesanan.
class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });
}

/// Model untuk satu pesanan.
class Order {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  OrderStatus status;
  final String customerName;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.paymentMethod,
    required this.status,
    required this.customerName,
  });
}

/// Provider untuk mengelola riwayat pesanan dari sisi penjual.
class OrderProvider with ChangeNotifier {
  // Data dummy untuk pesanan yang masuk
  final List<Order> _orders = [
    Order(
      id: 'order1',
      customerName: 'Budi Santoso',
      items: [
        OrderItem(id: '1', name: 'Wireless Headphone Alpha', quantity: 1, price: 1500000),
        OrderItem(id: '3', name: 'Gaming Mouse X10', quantity: 1, price: 550000),
      ],
      totalAmount: 2050000,
      orderDate: DateTime.now().subtract(const Duration(hours: 1)),
      paymentMethod: 'E-Wallet (GoPay, OVO)',
      status: OrderStatus.processing,
    ),
    Order(
      id: 'order2',
      customerName: 'Citra Lestari',
      items: [
        OrderItem(id: '4', name: 'Mechanical Keyboard Z', quantity: 1, price: 1800000),
      ],
      totalAmount: 1800000,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      paymentMethod: 'Transfer Bank',
      status: OrderStatus.readyForPickup,
    ),
  ];

  List<Order> get orders => [..._orders];

  Order findById(String id) {
    return _orders.firstWhere((order) => order.id == id);
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final order = findById(orderId);
    order.status = newStatus;
    notifyListeners();
  }
}