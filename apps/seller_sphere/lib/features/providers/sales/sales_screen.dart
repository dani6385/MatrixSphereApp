
// lib/features/presentations/reports/sales_report_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';
import 'models/top_product_model.dart';
//import 'components/summary_card.dart' hide SummaryCard;

/// Halaman untuk menampilkan laporan penjualan yang lebih detail.
class SalestScreen extends StatefulWidget {
  const SalestScreen({super.key});

  @override
  State<SalestScreen> createState() => _SalestScreenState();
}

class _SalestScreenState extends State<SalestScreen> {
  final double _totalRevenue = 15750000;
  final int _totalOrders = 125;
  final List<TopProduct> _topProducts = [
    TopProduct(name: 'Produk A', unitsSold: 50),
    TopProduct(name: 'Produk B', unitsSold: 35),
    TopProduct(name: 'Produk C', unitsSold: 20),
    TopProduct(name: 'Produk D', unitsSold: 15),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Laporan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur filter belum tersedia.')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSummarySection(context),
          const SizedBox(height: 24),
          _buildChartSection(context),
          const SizedBox(height: 24),
          _buildTopProductsSection(context),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Penjualan',
          style: AppStyles.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Total Pendapatan',
                value: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
                    .format(_totalRevenue),
                icon: Icons.attach_money,
                color: Colors.green, label: '', iconColor: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'Total Pesanan',
                value: _totalOrders.toString(),
                icon: Icons.shopping_cart,
                color: Colors.blue, label: '', iconColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grafik Penjualan (7 Hari Terakhir)',
          style: AppStyles.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text(
                'Placeholder untuk Grafik Penjualan',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopProductsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produk Terlaris',
          style: AppStyles.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: List.generate(_topProducts.length, (index) {
              final product = _topProducts[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(product.name),
                trailing: Text('${product.unitsSold} unit terjual'),
              );
            }),
          ),
        ),
      ],
    );
  }
}