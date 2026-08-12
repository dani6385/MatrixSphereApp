// lib/features/presentations/Historys/History_history_body.dart

import 'package:flutter/material.dart';
import 'history_model.dart';
import 'history_card.dart';

/// Halaman untuk menampilkan riwayat transaksi[cite: 5].
class Historybody extends StatefulWidget {
  const Historybody({super.key});

  @override
  State<Historybody> createState() =>
      _HistorybodyState();
}

class _HistorybodyState extends State<Historybody> {
  // Data contoh untuk riwayat transaksi[cite: 5].
  final List<History> _sampleHistories = [
    History(
      id: 'TRX001',
      date: DateTime(2023, 10, 26, 10, 30),
      amount: 150000.0,
      status: 'Berhasil',
    ),
    History(
      id: 'TRX002',
      date: DateTime(2023, 10, 25, 14, 00),
      amount: 75000.0,
      status: 'Menunggu Pembayaran',
    ),
    History(
      id: 'TRX003',
      date: DateTime(2023, 10, 24, 09, 15),
      amount: 200000.0,
      status: 'Berhasil',
    ),
    History(
      id: 'TRX004',
      date: DateTime(2023, 10, 23, 11, 45),
      amount: 50000.0,
      status: 'Dibatalkan',
    ),
    History(
      id: 'TRX005',
      date: DateTime(2023, 10, 22, 16, 20),
      amount: 300000.0,
      status: 'Berhasil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _sampleHistories.length,
      itemBuilder: (context, index) {
        return HistoryCard(history: _sampleHistories[index]);
      },
    );
  }
}