// lib/screens/widgets/order_management_body.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OrderManagement extends StatefulWidget {
  final DatabaseReference ordersRef;
  final Function(String orderId) onScanQrMatch;

  const OrderManagement({
    super.key,
    required this.ordersRef,
    required this.onScanQrMatch,
  });

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement>
    with SingleTickerProviderStateMixin {
  late TabController _statusTabController;

  @override
  void initState() {
    super.initState();
    // 4 Tahapan: Order Masuk, Proses Pengemasan, Siap Diambil, Selesai/Konfirmasi
    _statusTabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _statusTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Status Pesanan
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _statusTabController,
            isScrollable: true,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent,
            tabs: const [
              Tab(text: 'Order Masuk'),
              Tab(text: 'Pengemasan'),
              Tab(text: 'Siap Diambil'),
              Tab(text: 'Konfirmasi QR'),
            ],
          ),
        ),
        // Daftar Pesanan Berdasarkan Status
        Expanded(
          child: StreamBuilder(
            stream: widget.ordersRef.onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final rawData = snapshot.data?.snapshot.value;
              if (rawData == null || (rawData is Map && rawData.isEmpty)) {
                return const Center(child: Text('Belum ada data pesanan.'));
              }

              // Parsing data dari database
              final ordersMap = Map<String, dynamic>.from(rawData as Map);
              
              return TabBarView(
                controller: _statusTabController,
                children: [
                  _buildOrderList(ordersMap, 'incoming'), // Order Masuk
                  _buildOrderList(ordersMap, 'packing'),  // Proses Pengemasan
                  _buildOrderList(ordersMap, 'ready'),    // Siap Diambil
                  _buildQrConfirmationView(),             // Konfirmasi QR
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget daftar pesanan berdasarkan filter status
  Widget _buildOrderList(Map<String, dynamic> ordersMap, String statusFilter) {
    // Filter data berdasarkan status pesanan (bisa disesuaikan dengan skema data Firebase Anda)
    final filteredEntries = ordersMap.entries.where((entry) {
      final orderData = Map<String, dynamic>.from(entry.value);
      final status = orderData['status'] ?? 'incoming';
      return status == statusFilter;
    }).toList();

    if (filteredEntries.isEmpty) {
      return Center(
        child: Text('Tidak ada pesanan dengan status: $statusFilter'),
      );
    }

    return ListView.builder(
      itemCount: filteredEntries.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final orderId = filteredEntries[index].key;
        final orderData = Map<String, dynamic>.from(filteredEntries[index].value);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text('Order ID: $orderId', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Total: Rp ${orderData['total'] ?? 0}'),
            trailing: Chip(
              label: Text(orderData['status'] ?? 'pending', style: const TextStyle(fontSize: 10)),
            ),
          ),
        );
      },
    );
  }

  // Tampilan khusus untuk tahap pencocokan QR Code
  Widget _buildQrConfirmationView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 16),
            const Text(
              'Konfirmasi Pengambilan Barang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan QR code yang dibawa oleh kurir atau pembeli untuk mencocokkan data pesanan dan menyelesaikan transaksi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Memanggil fungsi scan QR untuk pencocokan
                widget.onScanQrMatch('qr_code_result_placeholder');
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Mulai Scan QR Code'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}