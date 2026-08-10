// lib/features/presentations/Historys/History_model.dart

/// Model sederhana untuk merepresentasikan data transaksi.
class History {
  final String id;
  final DateTime date;
  final double amount;
  final String status;

  History({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
  });
}