// lib/features/presentations/transactions/transaction_history_screen.dart

import 'package:flutter/material.dart';
import 'components/transaction_model.dart';
import 'components/transaction_card.dart'; // Mengimpor komponen kartu

/// Halaman untuk menampilkan riwayat transaksi.
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  // Data contoh untuk riwayat transaksi.
  final List<Transaction> _transactions = [
    Transaction(
        id: 'TRX001',
        date: DateTime.now().subtract(const Duration(days: 1)),
        amount: 150000,
        status: 'Berhasil'),
    Transaction(
        id: 'TRX002',
        date: DateTime.now().subtract(const Duration(days: 2)),
        amount: 75000,
        status: 'Berhasil'),
    Transaction(
        id: 'TRX003',
        date: DateTime.now().subtract(const Duration(days: 3)),
        amount: 250000,
        status: 'Dibatalkan'),
    Transaction(
        id: 'TRX004',
        date: DateTime.now().subtract(const Duration(days: 4)),
        amount: 50000,
        status: 'Berhasil'),
    Transaction(
        id: 'TRX005',
        date: DateTime.now().subtract(const Duration(days: 5)),
        amount: 300000,
        status: 'Menunggu Pembayaran'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          // Memanggil komponen kartu yang sudah dipisah
          return TransactionCard(transaction: transaction);
        },
      ),
    );
  }
}