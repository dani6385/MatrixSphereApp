class Product {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final double unitPrice; // This might be purchase price or base price
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
    required this.shopId,
    required this.name,
    this.description = '',
    required this.unitPrice,
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
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      shopId: map['shopId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ??
          0.0, // Added null-check and default
      sellingPrice: ((map['sellingPrice'] as num?)?.toDouble() ?? 0.0) > 0.0
          ? (map['sellingPrice'] as num).toDouble()
          : (map['price'] as num?)?.toDouble() ??
              0.0, // Fallback to price if sellingPrice is not present or is 0
      purchasePrice: ((map['purchasePrice'] as num?)?.toDouble() ?? 0.0) > 0.0
          ? (map['purchasePrice'] as num).toDouble()
          : (map['price'] as num?)?.toDouble() ?? 0.0,
      stock: map['stock'] as int? ?? 0,
      category: map['category'] ?? '',
      sku: map['sku'],
      imageUrl: map['imageUrl'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      minStockThreshold: map['minStockThreshold'] as int? ?? 0,
      ageRating: map['ageRating'] as int? ?? 0,
      soldCount: map['soldCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'unitPrice': unitPrice,
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
    double? unitPrice,
    String? description,
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
      shopId: shopId,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      description: description ?? this.description,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      sku: sku ?? this.sku,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      ageRating: ageRating ?? this.ageRating,
    );
  }
}
