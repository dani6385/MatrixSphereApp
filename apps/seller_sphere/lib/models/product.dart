class Product {
  final String id;
  final String name;
  final String sku;
  final int stock;
  final double purchasePrice;
  final double sellingPrice;
  final String category;
  final int minStockThreshold;
  final List<String> imageUrls;
  final int ageRating; // 0: Semua, 13: Remaja, 18: Dewasa
  final String? videoUrl;
  // Menambahkan properti yang hilang dari konstruktor sebelumnya
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.stock,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.category,
    required this.minStockThreshold,
    required this.imageUrls,
    required this.ageRating,
    this.videoUrl,
    // Memberikan nilai default agar tidak wajib diisi di semua tempat
    this.description = '',
    this.price = 0.0,
    this.imageUrl = '',
  });

  bool get isLowStock => stock <= minStockThreshold;
  double get profitPerUnit => sellingPrice - purchasePrice;

  /// Factory constructor untuk membuat instance dari Map (dari Firebase).
  /// Menerima `id` sebagai argumen terpisah karena itu adalah 'key' di RTDB.
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      sku: map['sku'] ?? '',
      // Menggunakan (map['...'] as num?) untuk menangani int/double dari JSON
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      purchasePrice: (map['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (map['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] ?? 'Umum',
      minStockThreshold: (map['minStockThreshold'] as num?)?.toInt() ?? 5,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      ageRating: (map['ageRating'] as num?)?.toInt() ?? 0,
      videoUrl: map['videoUrl'],
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  /// Mengubah objek Product menjadi Map untuk disimpan di Firebase.
  /// ID tidak dimasukkan karena ID adalah 'key' dari node di database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sku': sku,
      'stock': stock,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'category': category,
      'minStockThreshold': minStockThreshold,
      'imageUrls': imageUrls,
      'ageRating': ageRating,
      'videoUrl': videoUrl,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
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
    String? description, // Menggunakan '?' karena bisa null
    double? price,       // Menggunakan '?' karena bisa null
    String? imageUrl,    // Menggunakan '?' karena bisa null
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
      videoUrl: videoUrl ?? this.videoUrl,
      description: description ?? this.description, // Menambahkan properti yang diperbarui
      price: price ?? this.price,                   // Menambahkan properti yang diperbarui
      imageUrl: imageUrl ?? this.imageUrl,         // Menambahkan properti yang diperbarui
    );
  }
} // Closing brace for Product class

class LiveChatMessage {
  final String sender;
  final String message;
  final bool isSystem;
  final bool isSeller;

  LiveChatMessage({
    required this.sender,
    required this.message,
    this.isSystem = false,
    this.isSeller = false,
  });
}
