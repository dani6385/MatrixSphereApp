import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Enum untuk status pesanan.
enum OrderStatus {
  pending('Pending', kWarmOrange),
  processing('Diproses', kBlueSecondary),
  completed('Selesai', kSoftTeal),
  cancelled('Dibatalkan', kAlertRed),
  refunded('Dikembalikan', kPurple);

  final String displayName;
  final Color color;

  const OrderStatus(this.displayName, this.color);

  factory OrderStatus.fromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => OrderStatus.pending, // Default value if not found
    );
  }
}

/// Model untuk item dalam pesanan.
class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
    };
  }
}

/// Model untuk pesanan.
class Order {
  final String orderId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime orderDate;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;

  Order({
    required this.orderId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    required this.status,
    required String id,
    required String paymentMethod,
  });

  /// Factory constructor untuk membuat instance Order dari Map (data RTDB).
  factory Order.fromMap(Map<String, dynamic> data, String orderId) {
    return Order(
      orderId: orderId,
      customerName: data['customerName'] as String,
      customerEmail: data['customerEmail'] as String,
      customerPhone: data['customerPhone'] as String,
      // Mengonversi string ISO 8601 dari RTDB menjadi DateTime
      orderDate: DateTime.parse(data['orderDate'] as String),
      items: (data['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (data['totalAmount'] as num).toDouble(),
      status: OrderStatus.fromString(data['status'] as String), id: '',
      paymentMethod: '',
    );
  }

  String get paymentMethod => '';

  /// Mengonversi instance Order menjadi Map untuk disimpan di RTDB.
  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'orderDate':
          orderDate.toIso8601String(), // Menyimpan tanggal sebagai string
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
    };
  }
}
