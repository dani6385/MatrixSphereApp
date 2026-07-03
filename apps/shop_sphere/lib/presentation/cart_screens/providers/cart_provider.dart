import 'package:flutter/material.dart';
import 'dart:collection';

// Model untuk item di keranjang. Sebaiknya berada di file sendiri.
class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  // Menggunakan Map untuk kemudahan mengelola item berdasarkan ID produk.
  final Map<String, CartItem> _items = {
    // Data dummy dipindahkan ke sini dari CartScreen.
    'p1': CartItem(
      id: 'p1',
      name: 'Wireless Headphone Alpha',
      imageUrl: 'assets/images/product1.jpg',
      price: 1500000,
      quantity: 1,
    ),
    'p2': CartItem(
      id: 'p2',
      name: 'Smart Watch Series 5',
      imageUrl: 'assets/images/product2.jpg',
      price: 2200000,
      quantity: 2,
    ),
    'p4': CartItem(
      id: 'p4',
      name: 'Mechanical Keyboard Z',
      imageUrl: 'assets/images/product4.jpg',
      price: 1800000,
      quantity: 1,
    ),
  };

  // Getter untuk mendapatkan daftar item tanpa bisa memodifikasinya secara langsung.
  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items.values.toList());

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId) && _items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
      notifyListeners();
    } else if (_items.containsKey(productId) && _items[productId]!.quantity == 1) {
      // Jika kuantitas 1 dan dikurangi, hapus item dari keranjang.
      removeItem(productId);
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}