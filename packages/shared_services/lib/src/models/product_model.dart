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
  final String? brand;
  final String? unit;
  final String? barcode;
  final DateTime? expiryDate;
  final String? supplierId;
  final String? warehouseLocation;
  final double? weight;
  final double? length;
  final double? width;
  final double? height;
  final Map<String, String>? customAttributes;
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
    this.brand,
    this.unit,
    this.barcode,
    this.expiryDate,
    this.supplierId,
    this.warehouseLocation,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.customAttributes,
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
      brand: map['brand'],
      unit: map['unit'],
      barcode: map['barcode'],
      expiryDate: map['expiryDate'] != null
          ? DateTime.parse(map['expiryDate'])
          : null,
      supplierId: map['supplierId'],
      warehouseLocation: map['warehouseLocation'],
      weight: (map['weight'] ?? 0).toDouble(),
      length: (map['length'] ?? 0).toDouble(),
      width: (map['width'] ?? 0).toDouble(),
      height: (map['height'] ?? 0).toDouble(),
      customAttributes: Map<String, String>.from(map['customAttributes'] ?? {}),
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
      'brand': brand,
      'unit': unit,
      'barcode': barcode,
      'expiryDate': expiryDate?.toIso8601String(),
      'supplierId': supplierId,
      'warehouseLocation': warehouseLocation,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'customAttributes': customAttributes,
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
    String? brand,
    String? unit,
    String? barcode,
    DateTime? expiryDate,
    String? supplierId,
    String? warehouseLocation,
    double? weight,
    double? length,
    double? width,
    double? height,
    Map<String, String>? customAttributes,
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
      brand: brand ?? this.brand,
      unit: unit ?? this.unit,
      barcode: barcode ?? this.barcode,
      expiryDate: expiryDate ?? this.expiryDate,
      supplierId: supplierId ?? this.supplierId,
      warehouseLocation: warehouseLocation ?? this.warehouseLocation,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      customAttributes: customAttributes ?? this.customAttributes,
      ageRating: ageRating ?? this.ageRating,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
