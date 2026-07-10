import 'package:seller_sphere/data/database/app_database.dart';

class SalesTarget {
  final String dateString; // YYYY-MM-DD
  final double targetAmount;

  SalesTarget({
    required this.dateString,
    this.targetAmount = 0.0,
  });

  factory SalesTarget.fromMap(Map<String, dynamic> map) {
    return SalesTarget(
      dateString: map[AppDatabase.columnTargetDate],
      targetAmount: map[AppDatabase.columnTargetAmount],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppDatabase.columnTargetDate: dateString,
      AppDatabase.columnTargetAmount: targetAmount,
    };
  }
}
