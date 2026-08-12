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
  final String id; // ID unik dari Firebase (push key)
  final String shopId;
  final String buyerId;
  // Ubah nama 'orderId' menjadi 'displayId' agar lebih jelas
  final String orderId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime orderDate;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final String paymentMethod;

  Order({
    required this.id,
    required this.shopId,
    required this.buyerId,
    required this.orderId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
  });

  /// Factory constructor untuk membuat instance Order dari Map (data RTDB).
  factory Order.fromMap(Map<String, dynamic> data, String id) {
    // Fungsi helper untuk parsing tanggal yang aman
    DateTime parseOrderDate(dynamic dateValue) {
      if (dateValue is int) {
        // Handle timestamp (epoch in milliseconds)
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      } else if (dateValue is String) {
        // Handle ISO 8601 string
        return DateTime.tryParse(dateValue) ?? DateTime.now();
      }
      // Default jika format tidak dikenali
      return DateTime.now();
    }

    return Order(
      id: id, // Simpan Firebase push key sebagai 'id'
      // Gunakan parsing yang aman dengan nilai default
      shopId: data['shopId'] as String? ?? 'unknown_shop',
      buyerId: data['buyerId'] as String? ?? 'unknown_buyer',
      orderId: data['orderId'] as String? ?? id.substring(0, 8), // Baca 'orderId' dari data
      customerName: data['customerName'] as String? ?? 'Tanpa Nama',
      customerEmail: data['customerEmail'] as String? ?? '-',
      customerPhone: data['customerPhone'] as String? ?? '-',
      orderDate: parseOrderDate(data['orderDate'] ?? data['createdAt']),
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.fromString(data['status'] as String? ?? 'pending'),
      paymentMethod: data['paymentMethod'] as String? ?? 'N/A',
    );
  }

  /// Mengonversi instance Order menjadi Map untuk disimpan di RTDB.
  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'buyerId': buyerId,
      'orderId': orderId, // <-- PENTING: Tambahkan ini ke map
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'orderDate':
          orderDate.toIso8601String(), // Menyimpan tanggal sebagai string
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'paymentMethod': paymentMethod,
    };
  }
}
