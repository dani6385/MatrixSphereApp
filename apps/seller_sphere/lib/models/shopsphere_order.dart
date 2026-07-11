class ShopsphereOrder {
  final String id;
  final String customerName;
  final String productName;
  final int quantity;
  final double totalAmount;
  final String courierPhone;
  final String verificationCode;
  final String status;
  final int dayIndex; // 0 for 6 days ago, 6 for today

  ShopsphereOrder({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.totalAmount,
    required this.courierPhone,
    required this.verificationCode,
    required this.status,
    required this.dayIndex,
  });
}
