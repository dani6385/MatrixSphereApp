class Product {
  final String id;
  final String name;
  final String description;
  final double price; // This might be purchase price or base price
  final double sellingPrice; // Price at which it's sold
  final double purchasePrice; // Price at which it's bought
  final int stock;
  final String category;
  final String? sku;
  final String? imageUrl;
  final List<String> imageUrls;
  final int minStockThreshold;
  final int ageRating;
  final int soldCount; // New field for 'mostSold' sorting

  Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.stock,
    this.category = '',
    this.sku,
    this.imageUrl,
    this.imageUrls = const [],
    this.minStockThreshold = 0,
    this.ageRating = 0,
    this.soldCount = 0,
    required String shopId, // Initialize new field
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (map['sellingPrice'] as num?)?.toDouble() ??
          (map['price'] as num?)?.toDouble() ??
          0.0, // Fallback to price if sellingPrice not present
      purchasePrice: (map['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      stock: map['stock'] as int? ?? 0,
      category: map['category'] ?? '',
      sku: map['sku'],
      imageUrl: map['imageUrl'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      minStockThreshold: map['minStockThreshold'] as int? ?? 0,
      ageRating: map['ageRating'] as int? ?? 0,
      soldCount: map['soldCount'] as int? ?? 0, shopId: '', // Parse new field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'sellingPrice': sellingPrice,
      'purchasePrice': purchasePrice,
      'stock': stock,
      'category': category,
      'sku': sku,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'minStockThreshold': minStockThreshold,
      'ageRating': ageRating,
      'soldCount': soldCount, // Include new field
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? sellingPrice,
    double? purchasePrice,
    int? stock,
    String? category,
    String? sku,
    String? imageUrl,
    List<String>? imageUrls,
    int? minStockThreshold,
    int? ageRating,
    int? soldCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      sku: sku ?? this.sku,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      ageRating: ageRating ?? this.ageRating,
      soldCount: soldCount ?? this.soldCount,
      shopId: '',
    );
  }
}
