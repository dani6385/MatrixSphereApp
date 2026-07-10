
class Product {
  final String? id;
  final String name;
  final double price;
  final String description;

  Product({this.id, required this.name, required this.price, required this.description});

  // Convert a Product object into a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
    };
  }

  // Create a Product object from a map
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
    );
  }
}
