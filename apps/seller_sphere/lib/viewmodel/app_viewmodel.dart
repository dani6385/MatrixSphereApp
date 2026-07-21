import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seller_sphere/models/product.dart';

class AppViewModel with ChangeNotifier {
  // BehaviorSubject untuk menampung daftar produk
  final _products = BehaviorSubject<List<Product>>.seeded([]);

  // Stream getter untuk produk
  Stream<List<Product>> get products => _products.stream;

  AppViewModel() {
    // Inisialisasi data produk mock
    _loadMockProducts();
  }

  void _loadMockProducts() {
    _products.add([
      Product(
        id: 'p1',
        name: 'Kemeja Pria Lengan Panjang',
        description: 'Kemeja formal dan kasual, bahan katun premium.',
        price: 120000,
        imageUrl: 'https://images.unsplash.com/photo-1618763351220-f203521655ad?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        stock: 50,
      ),
      Product(
        id: 'p2',
        name: 'Celana Jeans Wanita High-Waist',
        description: 'Celana jeans modern dengan potongan high-waist, nyaman dipakai.',
        price: 180000,
        imageUrl: 'https://images.unsplash.com/photo-1541099644-47ae7e96077c?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        stock: 30,
      ),
      Product(
        id: 'p3',
        name: 'Sepatu Sneakers Unisex// TODO Implement this library.',
        description: 'Sepatu sneakers ringan dan stylish untuk pria dan wanita.',
        price: 250000,
        imageUrl: 'https://images.unsplash.com/photo-1514989940723-ad4750b5a659?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        stock: 20,
      ),
      Product(
        id: 'p4',
        name: 'Tas Selempang Kulit Sintetis',
        description: 'Tas selempang elegan dengan bahan kulit sintetis berkualitas tinggi.',
        price: 95000,
        imageUrl: 'https://images.unsplash.com/photo-1566150911716-ad573010b91d?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        stock: 40,
      ),
      Product(
        id: 'p5',
        name: 'Jam Tangan Digital Sporty',
        description: 'Jam tangan digital multifungsi, tahan air, cocok untuk aktivitas outdoor.',
        price: 150000,
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1999&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        stock: 35,
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _products.close();
  }
}