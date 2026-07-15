
import 'package:flutter/material.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Matrix Sphere', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[850],
              child: const Icon(Icons.chat_bubble_outline, color: Colors.orange, size: 20),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Local Mode', style: TextStyle(color: Colors.orange)),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MANAJEMEN SELLER', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Daftar penjual terdaftar di sistem', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua', selected: true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Aktif'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Ditolak'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildSellerCard(
                    icon: Icons.storefront,
                    iconColor: Colors.green,
                    storeName: 'Cyber Tech Store',
                    ownerName: 'Ana Syafitri',
                    email: 'ana@matrix.net',
                    phone: '+6281123456789',
                    status: 'AKTIF',
                    statusColor: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildSellerCard(
                    icon: Icons.lightbulb_outline,
                    iconColor: Colors.orange,
                    storeName: 'Quantum Computing',
                    ownerName: 'Budi Hermawan',
                    email: 'budi@sphere.org',
                    phone: '+628571234567',
                    status: 'PENDING VERIFIKASI',
                    statusColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1C1C1E),
        currentIndex: 1, // Set to Seller page
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Seller'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Approval'),
          BottomNavigationBarItem(icon: Icon(Icons.dns_outlined), label: 'System'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.grey[800] : const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Text(
        label,
        style: TextStyle(color: selected ? Colors.white : Colors.grey[400]),
      ),
    );
  }

  Widget _buildSellerCard({
    required IconData icon,
    required Color iconColor,
    required String storeName,
    required String ownerName,
    required String email,
    required String phone,
    required String status,
    required Color statusColor,
  }) {
    final bool isPending = status.contains('PENDING');
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 22),
                  const SizedBox(width: 10),
                  Text(storeName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: isPending ? Colors.transparent : statusColor.withValues(alpha: 0.2),
                  border: isPending ? Border.all(color: statusColor, width: 1) : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.person_outline, 'Pemilik: $ownerName'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.email_outlined, email),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone_outlined, phone),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
