class SaleItem {
  final int? id;
  final int transactionId;
  final int productId;
  final String productName;
  final int quantity;
  final double purchasePrice;
  final double sellingPrice;

  SaleItem({
    this.id,
    required this.transactionId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.purchasePrice,
    required this.sellingPrice,
  });

  double get totalAmount => sellingPrice * quantity;
  double get totalProfit => (sellingPrice - purchasePrice) * quantity;
}
