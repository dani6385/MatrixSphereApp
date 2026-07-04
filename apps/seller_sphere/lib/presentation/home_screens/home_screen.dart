import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:go_router/go_router.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold dan AppBar dihapus. Widget root sekarang adalah ListView.
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Bagian Ringkasan
        _buildSummarySection(),
        const SizedBox(height: 24),

        // Bagian Pesanan Terbaru
        _buildSectionHeader('Pesanan Terbaru'),
        _buildRecentOrders(),
        const SizedBox(height: 24),

        // Bagian Aksi Cepat
        _buildSectionHeader('Aksi Cepat'),
        _buildQuickActions(context),
      ],
    );
  }

  Widget _buildSummarySection() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.8,
      children: [
        _buildSummaryCard(
          title: 'Pendapatan (Hari Ini)',
          value: 'Rp 1.250.000',
          icon: Icons.monetization_on,
          color: AppColors.primary,
        ),
        _buildSummaryCard(
          title: 'Pesanan Baru',
          value: '5',
          icon: Icons.shopping_cart,
          color: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 32, color: color),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRecentOrders() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Pesanan #1123'),
            subtitle: const Text('3 item - Siap Diambil'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Pesanan #1122'),
            subtitle: const Text('1 item - Selesai'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: () => context.push('/add-product'),
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Tambah Produk'),
        ),
        ElevatedButton.icon(
          onPressed: () => context.push('/products'),
          icon: const Icon(Icons.inventory_2_outlined),
          label: const Text('Lihat Produk'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.push('/orders'),
          icon: const Icon(Icons.list_alt),
          label: const Text('Semua Pesanan'),
        ),
      ],
    );
  }
}
