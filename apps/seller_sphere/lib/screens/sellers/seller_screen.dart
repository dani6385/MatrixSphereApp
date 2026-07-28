import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl untuk format angka

/// Layar untuk menampilkan laporan penjualan, pendapatan, dan pengeluaran.
class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  // Data dummy untuk demonstrasi. Nantinya ini akan diambil dari database/API.
  final double _totalRevenue = 15750000.0;
  final double _totalExpenses = 4500000.0;

  final List<Map<String, dynamic>> _expenseDetails = [
    {'description': 'Gaji Karyawan - Budi', 'amount': 2500000.0},
    {'description': 'Gaji Owner - Andi', 'amount': 2000000.0},
    {'description': 'Sewa Kios', 'amount': 0.0}, // Contoh item lain
    {'description': 'Listrik & Internet', 'amount': 0.0},
  ];

  // Helper untuk format mata uang
  String _formatCurrency(double amount) {
    final format =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final double netIncome = _totalRevenue - _totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
        backgroundColor: kDarkAppBar,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // 1. Ringkasan Pendapatan & Pengeluaran
          _buildSummarySection(netIncome),
          const SizedBox(height: AppSpacing.lg),

          // 2. Placeholder untuk Kurva Pendapatan
          _buildChartPlaceholder(),
          const SizedBox(height: AppSpacing.lg),

          // 3. Detail Pengeluaran
          _buildExpenseDetailsSection(),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan kartu ringkasan (Pendapatan, Pengeluaran, Laba).
  Widget _buildSummarySection(double netIncome) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _buildSummaryRow('Total Pendapatan', _formatCurrency(_totalRevenue),
                Colors.green.shade700),
            const Divider(),
            _buildSummaryRow('Total Pengeluaran', _formatCurrency(_totalExpenses),
                Colors.red.shade700),
            const Divider(),
            _buildSummaryRow(
                'Laba Bersih', _formatCurrency(netIncome), kBrandPrimary,
                isBold: true),
          ],
        ),
      ),
    );
  }

  /// Widget untuk menampilkan detail pengeluaran.
  Widget _buildExpenseDetailsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rincian Pengeluaran',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            ..._expenseDetails.map(
              (expense) => _buildSummaryRow(
                expense['description'],
                _formatCurrency(expense['amount']),
                kDarkTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Placeholder untuk grafik/chart.
  Widget _buildChartPlaceholder() {
    return const Card(
      elevation: 2,
      child: SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, size: 40, color: kLightTextSecondary),
              SizedBox(height: AppSpacing.sm),
              Text('Kurva Pendapatan (Segera Hadir)'),
            ],
          ),
        ),
      ),
    );
  }

  /// Baris untuk menampilkan item ringkasan.
  Widget _buildSummaryRow(String title, String value, Color valueColor,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  color: valueColor,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}