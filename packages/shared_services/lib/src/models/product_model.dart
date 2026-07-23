/// Model untuk merepresentasikan satu item produk.
class Product {
  /// Nama produk, yang juga berfungsi sebagai ID unik (key) di database.
  final String name;
  int price;
  int stock;

  Product({
    required this.name,
    required this.price,
    required this.stock,
    required String id,
    required String description,
    required String imageUrl,
    required String sku,
    required int purchasePrice,
    required int sellingPrice,
    required String category,
    required int minStockThreshold,
    required List<dynamic> imageUrls,
    required int ageRating,
  });

  factory Product.fromJson(String name, Map<String, dynamic> json) {
    return Product(
      name: name,
      price: json['price'] as int? ?? 0,
      stock: json['stock'] as int? ?? 0,
      id: '',
      description: '',
      imageUrl: '',
      sku: '',
      purchasePrice: 0,
      sellingPrice: 0,
      category: '',
      minStockThreshold: 0,
      imageUrls: [],
      ageRating: 0,
    );
  }

  get description => null;
}
