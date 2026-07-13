class Product {
  final String name;
  final String sku;
  final String? ageLimit;
  final double price;
  final int stock;

  const Product({
    required this.name,
    required this.sku,
    this.ageLimit,
    required this.price,
    required this.stock,
  });
}
