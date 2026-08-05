// lib/features/presentations/transactions/transaction_model.dart

/// Model sederhana untuk merepresentasikan data transaksi.
class Transaction {
  final String id;
  final DateTime date;
  final double amount;
  final String status;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
  });
}