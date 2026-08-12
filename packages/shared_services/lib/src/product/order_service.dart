// lib/services/order_service.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_services/shared_services.dart';

/// Layanan untuk mengelola pesanan dan transaksi stok.
class OrderService {
  final DatabaseReference _productsRef =
      FirebaseDatabase.instance.ref().child('products');

  /// Membuat pesanan baru ke database Firebase pada node 'orders'[cite: 9]
  Future<String?> createOrder(Order order) async {
    try {
      final DatabaseReference ordersRef =
          FirebaseDatabase.instance.ref().child('orders');

      final newOrderRef = ordersRef.push();
      final String newOrderId = newOrderRef.key ?? '';

      final orderWithId = Order(
        buyerId: '',
        id: '',
        customerEmail: order.customerEmail,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        items: order.items,
        orderDate: order.orderDate,
        orderId: newOrderId,
        paymentMethod: order.paymentMethod,
        shopId: '',
        status: order.status,
        totalAmount: order.totalAmount,
      );

      await newOrderRef.set(orderWithId.toMap());

      return newOrderId;
    } catch (e) {
      print('Gagal membuat order: $e');
      return null;
    }
  }

  /// Memperbarui stok produk berdasarkan item yang dibeli di keranjang[cite: 9]
  Future<bool> updateStockForOrder(List<CartItem> cartItems) async {
    try {
      for (var cartItem in cartItems) {
        final productId = cartItem.product.id;
        final int currentStock = cartItem.product.stock;
        final int purchasedQty = cartItem.quantity;

        final int updatedStock = currentStock - purchasedQty;

        await _productsRef.child(productId).update({
          'stock': updatedStock >= 0 ? updatedStock : 0,
        });
      }
      return true;
    } catch (e) {
      print('Gagal memperbarui stok: $e');
      return false;
    }
  }
}
