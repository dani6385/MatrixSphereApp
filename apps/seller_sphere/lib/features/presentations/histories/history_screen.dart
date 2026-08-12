import 'package:flutter/material.dart';

/// Layar untuk menampilkan riwayat transaksi.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: const Center(
        child: Text('Daftar riwayat transaksi akan ditampilkan di sini.'),
      ),
    );
  }
}