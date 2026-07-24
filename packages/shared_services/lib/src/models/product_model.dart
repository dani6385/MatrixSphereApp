/// Model untuk merepresentasikan satu item produk.
class Product {
  final String id;
  final String name;
  final String? sku;
  final String? description;
  final int stock;
  final double purchasePrice;
  final double sellingPrice;
  final double price;
  final String? category;
  final int minStockThreshold;
  final int ageRating;
  final String? imageUrl;
  final List<String> imageUrls;

  Product({
    required this.id,
    required this.name,
    this.sku,
    this.description,
    required this.stock,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.price,
    this.category,
    required this.minStockThreshold,
    required this.ageRating,
    this.imageUrl,
    required this.imageUrls,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      sku: map['sku'],
      description: map['description'],
      stock: map['stock'] ?? 0,
      purchasePrice: (map['purchasePrice'] ?? 0).toDouble(),
      sellingPrice: (map['sellingPrice'] ?? 0).toDouble(),
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'],
      minStockThreshold: map['minStockThreshold'] ?? 0,
      ageRating: map['ageRating'] ?? 0,
      imageUrl: map['imageUrl'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sku': sku,
      'description': description,
      'stock': stock,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'price': price,
      'category': category,
      'minStockThreshold': minStockThreshold,
      'ageRating': ageRating,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? sku,
    String? description,
    int? stock,
    double? purchasePrice,
    double? sellingPrice,
    double? price,
    String? category,
    int? minStockThreshold,
    int? ageRating,
    String? imageUrl,
    List<String>? imageUrls,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      price: price ?? this.price,
      category: category ?? this.category,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      ageRating: ageRating ?? this.ageRating,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
