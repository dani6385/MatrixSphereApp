
import 'package:flutter/foundation.dart';

@immutable
class ShopsphereOrder {
  final String id;
  final String customerName;
  final String status;
  final String productName;
  final int quantity;
  final double totalAmount;
  final String courierName;
  final int dayIndex; // 0-6, where 6 is today

  const ShopsphereOrder({
    required this.id,
    required this.customerName,
    required this.status,
    required this.productName,
    required this.quantity,
    required this.totalAmount,
    required this.courierName,
    required this.dayIndex,
  });

  ShopsphereOrder copyWith({String? status}) {
    return ShopsphereOrder(
      id: id,
      customerName: customerName,
      status: status ?? this.status,
      productName: productName,
      quantity: quantity,
      totalAmount: totalAmount,
      courierName: courierName,
      dayIndex: dayIndex,
    );
  }
}

@immutable
class DayOrderStats {
  final int completed;
  final int awaiting;

  const DayOrderStats(this.completed, this.awaiting);

  int get total => completed + awaiting;
}
