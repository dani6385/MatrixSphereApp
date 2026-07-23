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
  });

  factory Product.fromJson(String name, Map<String, dynamic> json) {
    return Product(
      name: name,
      price: json['price'] as int? ?? 0,
      stock: json['stock'] as int? ?? 0,
    );
  }
}