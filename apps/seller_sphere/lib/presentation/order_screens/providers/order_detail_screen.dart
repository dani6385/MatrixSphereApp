import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// --- DATA DUMMY & MODEL (Ganti dengan data asli Anda) ---

enum PickupStatus { newOrder, preparing, readyForPickup, completed, cancelled }

class OrderDetail {
  final String orderId;
  final String customerName;
  final String pickupCode;
  final PickupStatus status;
  final List<String> items;
  final double totalPrice;
  final LatLng storeLocation; // Lokasi toko Anda

  OrderDetail({
    required this.orderId,
    required this.customerName,
    required this.pickupCode,
    required this.status,
    required this.items,
    required this.totalPrice,
    required this.storeLocation,
  });
}

// Provider untuk mengambil detail pesanan (ganti dengan implementasi API Anda)
final orderDetailProvider = FutureProvider.family<OrderDetail, String>((ref, orderId) async {
  // Simulasi panggilan API
  await Future.delayed(const Duration(seconds: 1));
  return OrderDetail(
    orderId: orderId,
    customerName: 'John Doe',
    pickupCode: 'SPH-7B4K2',
    status: PickupStatus.readyForPickup, // Status saat ini
    items: ['Sepatu Lari Keren (x1)', 'Kaos Polos Premium (x2)'],
    totalPrice: 990000,
    storeLocation: const LatLng(-6.2088, 106.8456), // Contoh: Monas, Jakarta
  );
});

// --- WIDGET SCREEN ---

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: Text('Detail Pesanan #$orderId')),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat pesanan: $err')),
        data: (order) => _buildOrderDetailContent(context, order),
      ),
    );
  }

  Widget _buildOrderDetailContent(BuildContext context, OrderDetail order) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildStatusCard(context, order.status),
        const SizedBox(height: 16),
        _buildPickupCodeCard(context, order.pickupCode),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detail Pelanggan', style: Theme.of(context).textTheme.titleMedium),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(order.customerName),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                Text('Barang Pesanan', style: Theme.of(context).textTheme.titleMedium),
                const Divider(),
                ...order.items.map((item) => ListTile(
                      title: Text(item),
                      contentPadding: EdgeInsets.zero,
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLocationCard(context, order.storeLocation),
        const SizedBox(height: 24),
        if (order.status == PickupStatus.readyForPickup)
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Tandai Selesai (Telah Diambil)'),
            onPressed: () {
              // TODO: Implementasi logika untuk mengubah status pesanan menjadi 'Completed'
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pesanan ditandai sebagai selesai.')),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context, PickupStatus status) {
    // Logika untuk mendapatkan teks dan warna berdasarkan status
    final statusInfo = {
      PickupStatus.readyForPickup: {'text': 'Siap Diambil', 'color': Colors.green, 'icon': Icons.check_circle_outline},
      PickupStatus.preparing: {'text': 'Sedang Disiapkan', 'color': Colors.orange, 'icon': Icons.inventory_2_outlined},
      // Tambahkan status lain di sini
    };
    final info = statusInfo[status] ?? {'text': 'Status Tidak Dikenal', 'color': Colors.grey, 'icon': Icons.help_outline};

    return Card(
      color: info['color'] as Color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: [
          Icon(info['icon'] as IconData, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Text(info['text'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _buildPickupCodeCard(BuildContext context, String code) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Text('Kode Penjemputan', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(code, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 4)),
          const SizedBox(height: 8),
          const Text('Tunjukkan kode ini kepada pembeli saat mengambil pesanan.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        ]),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, LatLng location) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 200,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: location, zoom: 15),
          markers: {Marker(markerId: const MarkerId('storeLocation'), position: location)},
          scrollGesturesEnabled: false,
          zoomGesturesEnabled: false,
        ),
      ),
    );
  }
}