import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';
import 'package:seller_sphere/widgets/daily_target_card.dart';
import 'package:seller_sphere/widgets/daily_target_dialog.dart';
import 'package:seller_sphere/widgets/pickup_summary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _todaySalesTotal = 750000;
  final List<ShopsphereOrder> _orders = _getDummyOrders();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final dailyTarget = viewModel.dailyTarget;
    final targetPercentage = (_todaySalesTotal / dailyTarget * 100).toInt();
    final targetProgress = (_todaySalesTotal / dailyTarget).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
          ),
        ),
        title: const Text('Seller Sphere', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_active, color: Colors.amber)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.flag, color: Colors.blue)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.grey)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroBanner(),
            const SizedBox(height: 16),
            _buildLowStockWarning(),
            const SizedBox(height: 16),
            DailyTargetCard(
              viewModel: viewModel,
              todaySalesTotal: _todaySalesTotal,
              targetValue: dailyTarget,
              targetPercentage: targetPercentage,
              targetProgress: targetProgress,
              onEdit: () => _showEditTargetDialog(viewModel),
            ),
            const SizedBox(height: 16),
            PickupSummary(orders: _orders),
            const SizedBox(height: 16),
            _buildOrderPickupStats(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/img_hero_banner.jpg'), // Pastikan path ini benar
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLowStockWarning() {
    return Card(
      color: Colors.red.shade900.withAlpha(204),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.white, size: 32),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Peringatan Stok Menipis (2 Produk)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Ketuk untuk melihat detail barang di inventaris.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderPickupStats() {
    return Card(
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statistik Pengambilan Pesanan Toko', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Text('Ketuk hari untuk detail paket masuk & pengambilan oleh pembeli', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    CircleAvatar(radius: 5, backgroundColor: Colors.green),
                    SizedBox(width: 8),
                    Text('Selesai Diambil', style: TextStyle(color: Colors.white70)),
                    SizedBox(width: 16),
                    CircleAvatar(radius: 5, backgroundColor: Colors.orange),
                    SizedBox(width: 8),
                    Text('Belum Diambil', style: TextStyle(color: Colors.white70)),
                  ],
                ),
                Text('5 Pesanan', style: TextStyle(color: Colors.blue.shade300, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1E1E1E),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue.shade300,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Streaming'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Laporan'),
        BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trend'),
      ],
    );
  }

  void _showEditTargetDialog(AppViewModel viewModel) {
    showDialog(
      context: context,
      builder: (_) => DailyTargetDialog(
        viewModel: viewModel,
        currentTarget: viewModel.dailyTarget,
      ),
    );
  }

  static List<ShopsphereOrder> _getDummyOrders() {
    return [
      ShopsphereOrder(id: "SS-240523-001", customerName: "Budi", productName: "T-Shirt Keren", quantity: 1, totalAmount: 120000, courierPhone: "081234567890", status: "Selesai Diambil", dayIndex: 6, verificationCode: "123456"),
      ShopsphereOrder(id: "SS-240523-002", customerName: "Ani", productName: "Sepatu Lari", quantity: 1, totalAmount: 450000, courierPhone: "081234567891", status: "Siap Diambil", dayIndex: 6, verificationCode: "234567"),
      ShopsphereOrder(id: "SS-240523-003", customerName: "Cici", productName: "Tas Ransel", quantity: 2, totalAmount: 260000, courierPhone: "081234567892", status: "Perlu Dipacking", dayIndex: 6, verificationCode: "345678"),
      ShopsphereOrder(id: "SS-240522-001", customerName: "Dedi", productName: "Topi", quantity: 1, totalAmount: 75000, courierPhone: "081234567893", status: "Selesai Diambil", dayIndex: 5, verificationCode: "456789"),
      ShopsphereOrder(id: "SS-240521-001", customerName: "Euis", productName: "Jam Tangan", quantity: 1, totalAmount: 350000, courierPhone: "081234567894", status: "Selesai Diambil", dayIndex: 4, verificationCode: "567890"),
    ];
  }
}
