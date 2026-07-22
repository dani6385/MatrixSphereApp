class Product {
  final String id;
  final String name;
  final String sku;
  int stock;
  double purchasePrice;
  double sellingPrice;
  String category;
  int minStockThreshold;
  List<String> imageUrls;
  int ageRating; // 0: Semua, 13: Remaja, 18: Dewasa
  String? videoUrl;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    this.stock = 0,
    this.purchasePrice = 0.0,
    this.sellingPrice = 0.0,
    this.category = 'Umum',
    this.minStockThreshold = 5,
    this.imageUrls = const [],
    this.ageRating = 0,
    this.videoUrl, required String description, required int price, required String imageUrl,
  });

  bool get isLowStock => stock <= minStockThreshold;
  double get profitPerUnit => sellingPrice - purchasePrice;

  // Factory constructor untuk membuat instance dari Map (misalnya dari JSON)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      sku: map['sku'],
      stock: map['stock'] ?? 0,
      purchasePrice: (map['purchasePrice'] ?? 0.0).toDouble(),
      sellingPrice: (map['sellingPrice'] ?? 0.0).toDouble(),
      category: map['category'] ?? 'Umum',
      minStockThreshold: map['minStockThreshold'] ?? 5,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      ageRating: map['ageRating'] ?? 0,
      videoUrl: map['videoUrl'], description: '', price: 0, imageUrl: '',
    );
  }

  // Method untuk menyalin objek dengan beberapa perubahan (mirip .copy() di Kotlin)
  Product copyWith({
    String? id,
    String? name,
    String? sku,
    int? stock,
    double? purchasePrice,
    double? sellingPrice,
    String? category,
    int? minStockThreshold,
    List<String>? imageUrls,
    int? ageRating,
    String? videoUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      stock: stock ?? this.stock,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      category: category ?? this.category,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      imageUrls: imageUrls ?? this.imageUrls,
      ageRating: ageRating ?? this.ageRating,
      videoUrl: videoUrl ?? this.videoUrl, description: '', price: 0, imageUrl: '',
    );
  }
}
