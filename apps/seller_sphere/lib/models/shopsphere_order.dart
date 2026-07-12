class ShopsphereOrder {
  final String id;
  final String customerName;
  final String productName;
  final int quantity;
  final double totalAmount;
  final String courierPhone;
  final String status;
  final int dayIndex;
  final String verificationCode;

  ShopsphereOrder({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.totalAmount,
    required this.courierPhone,
    required this.status,
    required this.dayIndex,
    required this.verificationCode,
  });
}
