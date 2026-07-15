import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://placehold.it/100x100'), // Placeholder for avatar
          ),
        ),
        title: const Text('Seller Sphere', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: Colors.yellow)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.flag_outlined, color: Colors.red)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: Colors.white)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(16.0),
                image: const DecorationImage(
                  image: NetworkImage('https://placehold.it/400x200'), // Placeholder for banner
                  fit: BoxFit.cover,
                  opacity: 0.3
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SS Seller Sphere',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Real-time Store Intelligence Pro',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Low Stock Warning
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE94560).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFE94560))
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFE94560)),
                  const SizedBox(width: 16.0),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Peringatan Stok Menipis! (2 Produk)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('Ketuk untuk melihat detail barang di inventaris.', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Daily Sales Target
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Target Penjualan Harian', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      TextButton(onPressed: () {}, child: const Text('Ubah')),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                       Text('Rp 750.000 / Rp 1.000.000', style: TextStyle(color: Colors.white70)),
                       Text('75%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                   const SizedBox(height: 8.0),
                   const Text('Hampir sampai 75% target tercapai. Tambah beberapa transaksi lagi untuk mencapai sukses hari ini!', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
             const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                     decoration: BoxDecoration(
                      color: const Color(0xFF0F3460),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: const [
                         Icon(Icons.warning_amber_rounded, color: Colors.orange),
                         SizedBox(height: 8.0),
                        Text('Belum Diambil', style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 8.0),
                        Text('4 Paket', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                     decoration: BoxDecoration(
                      color: const Color(0xFF0F3460),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: const [
                         Icon(Icons.check_circle_outline, color: Colors.green),
                         SizedBox(height: 8.0),
                        Text('Selesai Diambil', style: TextStyle(color: Colors.white70)),
                         SizedBox(height: 8.0),
                        Text('1 Paket', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
             const SizedBox(height: 16.0),
             // Pickup Statistics
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Statistik Pengambilan Pesanan Toko', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Text('Ketuk hari untuk detail paket masuk & pengambilan oleh pembeli', style: TextStyle(color: Colors.white70)),
                   const SizedBox(height: 16.0),
                  Row(
                    children: [
                       Container(height: 10, width: 10, color: Colors.green),
                       const SizedBox(width: 8.0),
                       const Text('Selesai Diambil', style: TextStyle(color: Colors.white70)),
                       const SizedBox(width: 16.0),
                       Container(height: 10, width: 10, color: Colors.orange),
                       const SizedBox(width: 8.0),
                       const Text('Belum Diambil', style: TextStyle(color: Colors.white70)),
                      const Spacer(),
                      const Text('5 Pesanan', style: TextStyle(color: Colors.blueAccent)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F3460),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.slideshow), label: 'Streaming'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trend'),
        ],
      ),
    );
  }
}
