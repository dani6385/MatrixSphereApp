<<<<<<< HEAD
// lib/models/product_model.dart

class Product {
  final String id;
  String name;
  double price;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  /// Membuat salinan objek Product dengan perubahan opsional.[cite: 13]
  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }
}
=======
// lib/models/product_model.dart

class Product {
  final String id;
  String name;
  double price;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  /// Membuat salinan objek Product dengan perubahan opsional.[cite: 13]
  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }
}
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
