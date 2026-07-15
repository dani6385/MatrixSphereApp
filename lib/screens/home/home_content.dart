
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Matrix Sphere', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Local Mode', style: TextStyle(color: Colors.orange)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SYSTEM INTEGRITY: ACTIVE', style: TextStyle(color: Colors.orange)),
                  const SizedBox(height: 10),
                  Text(
                    'Berjalan dalam Offline-first Mode. Database lokal Room siap menyinkronkan data begitu google-services.json diaktifkan.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoCard('3', 'PENDING'),
                _buildInfoCard('1', 'SELLER AKTIF'),
                _buildInfoCard('0', 'SELESAI'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Aksi Demonstrasi Instan', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('+ Simulasi Seller'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('+ Pesan Konsensus'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('HISTORI AKTIVITAS TERKINI', style: TextStyle(color: Colors.white)),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, color: Colors.grey, size: 50),
                    SizedBox(height: 10),
                    Text('Belum ada histori persetujuan.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(count, style: const TextStyle(color: Colors.white, fontSize: 24)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
