import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

/// Model untuk merepresentasikan satu item di dalam keranjang.
class CartItem {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

/// Notifier untuk mengelola logika keranjang belanja.
class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Getter untuk menghitung total item unik di keranjang
  int get totalItems => _items.length;

  // Getter untuk menghitung total kuantitas semua item
  int get totalQuantity {
    return _items.fold(0, (total, current) => total + current.quantity);
  }

  // Getter untuk menghitung total harga
  double get totalPrice {
    return _items.fold(0.0, (total, current) => total + (current.price * current.quantity));
  }

  void addItem({
    required String productId,
    required String name,
    required double price,
    required String imageUrl,
    int quantity = 1, // Tambahkan parameter kuantitas opsional
  }) {
    final existingItem = _items.firstWhereOrNull((item) => item.productId == productId);

    if (existingItem != null) {
      // Jika item sudah ada, tambah kuantitasnya sesuai input
      existingItem.quantity += quantity;
    } else {
      // Jika item baru, tambahkan ke list
      final newItem = CartItem(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity, // Atur kuantitas awal
      );
      _items.add(newItem);
    }
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final item = _items.firstWhereOrNull((item) => item.productId == productId);
    if (item != null) {
      item.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    final item = _items.firstWhereOrNull((item) => item.productId == productId);
    if (item != null) {
      if (item.quantity > 1) {
        item.quantity--;
        notifyListeners();
      } else {
        // Jika kuantitas 1, hapus item
        removeItem(productId);
      }
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void clearCart() {
    _items = [];
    notifyListeners();
  }
}