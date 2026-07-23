//import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

/// Model untuk merepresentasikan sebuah produk di dalam inventaris.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int stock;
  final String sku;
  final double purchasePrice;
  final double sellingPrice;
  final String category;
  final int minStockThreshold;
  final List<String> imageUrls;
  final int ageRating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
    required this.sku,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.category,
    required this.minStockThreshold,
    required this.imageUrls,
    required this.ageRating,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? stock,
    String? sku,
    double? purchasePrice,
    double? sellingPrice,
    String? category,
    int? minStockThreshold,
    List<String>? imageUrls,
    int? ageRating,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      category: category ?? this.category,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      imageUrls: imageUrls ?? this.imageUrls,
      ageRating: ageRating ?? this.ageRating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
      'sku': sku,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'category': category,
      'minStockThreshold': minStockThreshold,
      'imageUrls': imageUrls,
      'ageRating': ageRating,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      sku: map['sku'] ?? '',
      purchasePrice: (map['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (map['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      minStockThreshold: (map['minStockThreshold'] as num?)?.toInt() ?? 0,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      ageRating: (map['ageRating'] as num?)?.toInt() ?? 0,
    );
  }

  // fromJson factory to maintain compatibility with Shop model if needed
  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product.fromMap(json, id);
  }

  String? get productId => null;
}

/// Model untuk merepresentasikan sebuah pesanan di dalam toko.
/// Contoh: node 'akuna' di dalam 'pesanan'.
class Order {
  /// ID unik dari pemesan, contoh: 'akuna'.
  final String id;

  /// Daftar item yang dipesan dalam bentuk Map<nama_item, harga>.
  final Map<String, int> items;

  /// Total harga dari semua item.
  final int total;

  Order({
    required this.id,
    required this.items,
    required this.total,
  });

  /// Factory constructor untuk membuat instance [Order] dari Map (JSON).
  ///
  /// [id] adalah key dari map (nama pemesan).
  /// [json] adalah value dari map (detail pesanan).
  factory Order.fromJson(String id, Map<String, dynamic> json) {
    // Memisahkan 'total' dari item lainnya
    final itemsMap = Map<String, int>.from(json)..remove('total');

    return Order(
      id: id,
      items: itemsMap,
      total: json['total'] as int? ?? 0,
    );
  }

  /// Mengonversi instance [Order] menjadi Map (JSON).
  /// ID tidak disertakan karena ID adalah key pada node parent.
  Map<String, dynamic> toJson() {
    // Menggabungkan map 'items' dengan field 'total'
    return {...items, 'total': total};
  }

  @override
  String toString() {
    return 'Order(id: $id, items: $items, total: $total)';
  }
}

/// Model untuk merepresentasikan sebuah toko di dalam seller_sphere.
/// Contoh: 'toko_agan'.
class Shop {
  /// ID unik dari toko, contoh: 'toko_agan'.
  final String id;

  /// Daftar produk yang dijual dalam bentuk Map<nama_produk, harga>.
  final Map<String, Product> products;

  /// Daftar pesanan yang masuk dalam bentuk Map<id_pemesan, Order>.
  final Map<String, Order> orders;

  Shop({
    required this.id,
    required this.products,
    required this.orders,
  });

  /// Factory constructor untuk membuat instance [Shop] dari Map (JSON).
  ///
  /// [id] adalah key dari map (nama toko).
  /// [json] adalah value dari map (detail toko).
  factory Shop.fromJson(String id, Map<String, dynamic> json) {
    // Mengambil data produk. Jika tidak ada, default ke map kosong.
    final productsData = json['produk'] as Map<String, dynamic>? ?? {};
    final products = productsData.map((key, value) {
      // Assuming product data in 'shop' is just price and stock
      return MapEntry(key, Product.fromMap(value, key));
    });

    // Mengambil data pesanan. Jika tidak ada, default ke map kosong.
    final ordersData = json['pesanan'] as Map<String, dynamic>? ?? {};
    final orders = ordersData.map(
      (orderId, orderJson) => MapEntry(
        orderId,
        Order.fromJson(orderId, orderJson as Map<String, dynamic>),
      ),
    );

    return Shop(
      id: id,
      products: products,
      orders: orders,
    );
  }

  /// Mengonversi instance [Shop] menjadi Map (JSON).
  /// ID tidak disertakan karena ID adalah key pada node parent.
  Map<String, dynamic> toJson() {
    return {
      'produk': products.map((key, product) => MapEntry(key, {
        'price': product.price, 'stock': product.stock
      })),
      'pesanan':
          orders.map((orderId, order) => MapEntry(orderId, order.toJson())),
    };
  }

  @override
  String toString() {
    return 'Shop(id: $id, products: $products, orders: $orders)';
  }
}

/// --- CONTOH PENGGUNAAN ---
/*
void main() async {
  final rtdbService = FirebaseRtdbService();
  final snapshot = await rtdbService.readData('seller_sphere/toko_agan');

  if (snapshot != null && snapshot.value != null) {
    // Konversi data mentah (Map<String, dynamic>) ke model Shop
    final shopData = Map<String, dynamic>.from(snapshot.value as Map);
    final shop = Shop.fromJson(snapshot.key!, shopData);

    // Sekarang Anda bisa mengakses data dengan type-safe
    print('Nama Toko: ${shop.id}'); // Output: Nama Toko: toko_agan
    print('Harga Sepatu: ${shop.products['sepatu']}'); // Output: Harga Sepatu: 25000
    print('Total pesanan dari akuna: ${shop.orders['akuna']?.total}'); // Output: Total pesanan dari akuna: 50000
  }
}
*/