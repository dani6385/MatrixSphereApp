// d:\MatrixSphereApp\apps\seller_sphere\lib\models\product_model.dart
class Product {
  final String id;
  final String name;
  final List<String> imageUrls;
  final double price;
  final int stock;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.price,
    required this.stock,
    required this.createdAt,
  });
}
