import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/presentation/order_screens/providers/order_provider.dart';

// --- SIMULASI LAYANAN NOTIFIKASI ---

final logger = Logger();

/// Layanan ini mensimulasikan pengiriman permintaan notifikasi ke backend Anda.
class NotificationService {
  Future<void> sendOrderReadyNotification({required String orderId, required String customerId}) async {
    // Di aplikasi nyata, ini akan menjadi panggilan HTTP POST ke endpoint backend Anda.
    // Misalnya: await http.post(Uri.parse('https://api.yourdomain.com/notifications/order-ready'),
    // body: {'orderId': orderId, 'customerId': customerId});
    logger.i('MENGIRIM NOTIFIKASI: Pesanan #$orderId untuk pelanggan #$customerId sudah siap diambil.');
    await Future.delayed(const Duration(seconds: 1)); // Simulasi latensi jaringan
    logger.i('BERHASIL: Notifikasi untuk pesanan #$orderId telah dikirim.');
  }
}

final notificationServiceProvider = Provider((ref) => NotificationService());

// Use PickupStatus from order_provider.dart to avoid duplicate enum definitions
class OrderDetail {
  final String orderId;
  final String customerId;
  final String customerName;
  final String pickupCode;
  final PickupStatus status;
  final List<String> items;
  final double totalPrice;
  final LatLng storeLocation; // Lokasi toko Anda

  OrderDetail({
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.pickupCode,
    required this.status,
    required this.items,
    required this.totalPrice,
    required this.storeLocation,
  });
}

// State Notifier untuk mengelola state detail pesanan
class OrderDetailNotifier extends StateNotifier<AsyncValue<OrderDetail>> {
  final String orderId;
  final Ref _ref;

  OrderDetailNotifier(this.orderId, this._ref) : super(const AsyncValue.loading()) {
    _fetchOrderDetail();
  }

  // Metode privat untuk memuat data pesanan awal
  Future<void> _fetchOrderDetail() async {
    state = const AsyncValue.loading();
    try {
      // Menggunakan repository terpusat untuk mengambil data
      final orderFromRepo = await _ref.read(orderRepositoryProvider).fetchOrderById(orderId);

      // Konversi dari model Order di repository ke model OrderDetail di UI
      // Ini adalah praktik yang baik untuk memisahkan model data dari model UI
      final orderDetail = OrderDetail(
        orderId: orderFromRepo.id,
        customerId: orderFromRepo.customerId,
        customerName: orderFromRepo.customerName,
        pickupCode: 'SPH-${orderFromRepo.id.substring(0, 5).toUpperCase()}', // Contoh generate kode pickup
        status: orderFromRepo.status,
        items: orderFromRepo.items.map((item) => '${item.name} (x${item.quantity})').toList(),
        totalPrice: orderFromRepo.totalAmount,
        storeLocation: const LatLng(-6.2088, 106.8456),
      );
      state = AsyncValue.data(orderDetail);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  // Metode untuk mengubah status secara dinamis
  Future<void> updateStatus(PickupStatus newStatus) async {
    if (state.hasValue) {
      final currentOrder = state.value!;
      // Simulasi update ke backend/API
      await Future.delayed(const Duration(milliseconds: 500));
      // Update state lokal dengan status baru
      state = AsyncValue.data(OrderDetail(
        orderId: currentOrder.orderId,
        customerId: currentOrder.customerId,
        customerName: currentOrder.customerName,
        pickupCode: currentOrder.pickupCode,
        status: newStatus, // Status diubah secara dinamis
        items: currentOrder.items,
        totalPrice: currentOrder.totalPrice,
        storeLocation: currentOrder.storeLocation,
      ));

      // **TITIK PENTING: Kirim notifikasi jika statusnya "Siap Diambil"**
      if (newStatus == PickupStatus.readyForPickup) {
        await _ref.read(notificationServiceProvider).sendOrderReadyNotification(
          orderId: currentOrder.orderId,
          customerId: currentOrder.customerId,
        );
      }
    }
  }
  // Metode untuk menandai pesanan sebagai selesai
  Future<void> markAsCompleted() async {
    // Pastikan ada data sebelum mencoba update
    if (state.hasValue) {
      final currentOrder = state.value!;
      // Simulasi update ke backend/API
      await Future.delayed(const Duration(milliseconds: 500));
      // Update state lokal dengan status baru
      state = AsyncValue.data(OrderDetail(
        orderId: currentOrder.orderId,
        customerId: currentOrder.customerId,
        customerName: currentOrder.customerName,
        pickupCode: currentOrder.pickupCode,
        status: PickupStatus.completed, // Status diubah
        items: currentOrder.items,
        totalPrice: currentOrder.totalPrice,
        storeLocation: currentOrder.storeLocation,
      ));
    }
  }
}

// Provider untuk OrderDetailNotifier
final orderDetailProvider = StateNotifierProvider.autoDispose.family<OrderDetailNotifier, AsyncValue<OrderDetail>, String>((ref, orderId) {
  return OrderDetailNotifier(orderId, ref);
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
        data: (order) => _buildOrderDetailContent(context, ref, order),
      ),
    );
  }

  Widget _buildOrderDetailContent(BuildContext context, WidgetRef ref, OrderDetail order) {
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
        _buildActionButtons(context, ref, order), // Ganti dengan widget tombol aksi
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context, PickupStatus status) {
    // Logika untuk mendapatkan teks dan warna berdasarkan status
    final statusInfo = <PickupStatus, Map<String, dynamic>>{
      PickupStatus.newOrder: {'text': 'Pesanan Baru', 'color': Colors.blue.shade700, 'icon': Icons.new_releases_outlined},
      PickupStatus.readyForPickup: {'text': 'Siap Diambil', 'color': Theme.of(context).colorScheme.primary, 'icon': Icons.check_circle_outline},
      PickupStatus.preparing: {'text': 'Sedang Disiapkan', 'color': Colors.orange.shade700, 'icon': Icons.inventory_2_outlined},
      PickupStatus.completed: {'text': 'Selesai', 'color': Colors.green.shade700, 'icon': Icons.task_alt_outlined},
      PickupStatus.cancelled: {'text': 'Dibatalkan', 'color': Colors.red.shade700, 'icon': Icons.cancel_outlined},
      
    };
    final info = statusInfo[status] ?? {'text': 'Status Tidak Dikenal', 'color': Theme.of(context).disabledColor, 'icon': Icons.help_outline};

    return Card(
      color: info['color'],
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
          Text('Tunjukkan kode ini kepada pembeli saat mengambil pesanan.', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
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

  // Widget baru untuk menampilkan tombol aksi yang sesuai dengan status pesanan
  Widget _buildActionButtons(BuildContext context, WidgetRef ref, OrderDetail order) {
    final notifier = ref.read(orderDetailProvider(orderId).notifier);

    void showSuccessSnackBar(String message) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    switch (order.status) {
      case PickupStatus.newOrder:
        return ElevatedButton.icon(
          icon: const Icon(Icons.inventory_2_outlined),
          label: const Text('Mulai Siapkan Pesanan'),
          onPressed: () async {
            await notifier.updateStatus(PickupStatus.preparing);
            showSuccessSnackBar('Status diubah menjadi: Sedang Disiapkan.');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        );
      case PickupStatus.preparing:
        return ElevatedButton.icon(
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Tandai Siap Diambil'),
          onPressed: () async {
            await notifier.updateStatus(PickupStatus.readyForPickup);
            showSuccessSnackBar('Status diubah menjadi: Siap Diambil.');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
        );
      case PickupStatus.readyForPickup:
        return ElevatedButton.icon(
          icon: const Icon(Icons.task_alt_outlined),
          label: const Text('Tandai Selesai (Telah Diambil)'),
          onPressed: () async {
            // Tampilkan dialog verifikasi sebelum menyelesaikan pesanan
            _showVerificationDialog(context, notifier, order.pickupCode);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
          ),
        );
      case PickupStatus.completed:
      case PickupStatus.cancelled:
        // Tidak ada aksi untuk status selesai atau dibatalkan
        return const SizedBox.shrink();
    }
  }

  // Widget baru untuk menampilkan dialog verifikasi kode
  void _showVerificationDialog(BuildContext context, OrderDetailNotifier notifier, String correctCode) {
    final codeController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Verifikasi Kode Penjemputan'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Masukkan kode yang diberikan oleh pembeli untuk menyelesaikan pesanan.'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: codeController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Kode Penjemputan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kode tidak boleh kosong';
                    }
                    if (value.toUpperCase() != correctCode.toUpperCase()) {
                      return 'Kode salah. Periksa kembali.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(dialogContext).pop()),
            ElevatedButton(
              child: const Text('Konfirmasi & Selesaikan'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(); // Tutup dialog
                  await notifier.markAsCompleted(); // Selesaikan pesanan
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Verifikasi berhasil. Pesanan telah diselesaikan.'), backgroundColor: Colors.green),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}