
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

  ShopsphereOrder copyWith({
    String? id,
    String? customerName,
    String? productName,
    int? quantity,
    double? totalAmount,
    String? courierName,
    String? status,
    int? dayIndex,
  }) {
    return ShopsphereOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      courierName: courierName ?? this.courierName,
      status: status ?? this.status,
      dayIndex: dayIndex ?? this.dayIndex,
    );
  }
}
