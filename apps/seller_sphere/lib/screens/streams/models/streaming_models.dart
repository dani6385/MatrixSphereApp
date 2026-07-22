// d:\MatrixSphereApp\apps\seller_sphere\lib\screens\streams\models\streaming_models.dart

class Product {
  final String id;
  final String name;
  final double sellingPrice;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.sellingPrice,
    required this.stock,
  });
}

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
