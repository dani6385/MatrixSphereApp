class ShopsphereOrder {
  final String id;
  final int dayIndex;
  final String productName;
  final int quantity;
  final String customerName;
  final String courierPhone;
  final double totalAmount;
  final String status;
  final String verificationCode;

  ShopsphereOrder({
    required this.id,
    required this.dayIndex,
    required this.productName,
    required this.quantity,
    required this.customerName,
    required this.courierPhone,
    required this.totalAmount,
    required this.status,
    required this.verificationCode,
  });
}
