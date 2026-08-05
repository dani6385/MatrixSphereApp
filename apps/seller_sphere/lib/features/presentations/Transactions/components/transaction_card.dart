// lib/features/presentations/transactions/components/transaction_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';
import 'transaction_model.dart'; // Mengimpor model data transaksi

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  /// Mendapatkan warna berdasarkan status transaksi.
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Berhasil':
        return kSoftTeal;
      case 'Dibatalkan':
        return kAlertRed;
      case 'Menunggu Pembayaran':
        return kWarmOrange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(transaction.status),
          child: const Icon(Icons.receipt_long, color: Colors.white),
        ),
        title: Text('ID Transaksi: ${transaction.id}'),
        subtitle: Text(
            'Tanggal: ${DateFormat('dd MMM yyyy, HH:mm').format(transaction.date)}\nStatus: ${transaction.status}'),
        trailing: Text(
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
              .format(transaction.amount),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}