
class ShopsphereOrder {
  final String id;
  final String customerName;
  final String productName;
  final int quantity;
  final double totalAmount;
  final String courierName;
  final String status;
  final int dayIndex;

  ShopsphereOrder({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.totalAmount,
    required this.courierName,
    required this.status,
    required this.dayIndex,
  });
}
