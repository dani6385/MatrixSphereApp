class SaleTransaction {
  final int? id;
  final int timestamp;
  final double totalAmount;
  final double totalProfit;
  final String paymentMethod;

  SaleTransaction({
    this.id,
    required this.timestamp,
    this.totalAmount = 0.0,
    this.totalProfit = 0.0,
    this.paymentMethod = "Tunai",
  });
}
