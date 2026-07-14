import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
        ),
        title: const Text('Seller Sphere'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SS Seller Sphere',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const Text(
                  'Real-time Store Intelligence Pro',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // Stock Alert
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.red[900],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Peringatan Stok Menipis! (2 Produk)\nKetuk untuk melihat detail barang di inventaris.',
                    style: TextStyle(color: Colors.white),
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
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Target Penjualan Harian', style: TextStyle(color: Colors.white)),
                    TextButton(onPressed: () {}, child: const Text('Ubah')),
                  ],
                ),
                const SizedBox(height: 8.0),
                const LinearProgressIndicator(value: 0.75),
                const SizedBox(height: 8.0),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rp 750.000 / Rp 1.000.000', style: TextStyle(color: Colors.white70)),
                    Text('75%', style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Hampir sampai 75% target tercapai. Tambah beberapa transaksi lagi untuk mencapai sukses hari ini!',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // Packages
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange),
                      Text('Belum Diambil', style: TextStyle(color: Colors.white)),
                      Text('4 Paket', style: TextStyle(color: Colors.white, fontSize: 24)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green),
                      Text('Selesai Diambil', style: TextStyle(color: Colors.white)),
                      Text('1 Paket', style: TextStyle(color: Colors.white, fontSize: 24)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Order Pickup Statistics
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Statistik Pengambilan Pesanan Toko', style: TextStyle(color: Colors.white)),
                const Text('Ketuk leri antak detail paket masak & perpendice ich pombek', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 10),
                        SizedBox(width: 4),
                        Text('Selesai Diambil', style: TextStyle(color: Colors.white70)),
                        SizedBox(width: 8),
                        Icon(Icons.circle, color: Colors.orange, size: 10),
                        SizedBox(width: 4),
                        Text('Belum Diambil', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    TextButton(onPressed: (){}, child: const Text('5 Pesanan')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video),
            label: 'Streaming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trend',
          ),
        ],
      ),
    );
  }
}
