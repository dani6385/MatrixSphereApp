// d:\MatrixSphereApp\apps\seller_sphere\lib\screens\streams\models\streaming_models.dart

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
