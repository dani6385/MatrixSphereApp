import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../cart_screens/providers/cart_provider.dart';

import '../order_screens/providers/order_provider.dart';
import 'package:shared_ui/shared_ui.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;
import 'models/payment_method_model.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/payment_method_selector.dart';
import 'widgets/pickup_location_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedPaymentMethod;
  bool _isProcessingOrder = false;
  double? _distanceInMeters;
  bool _isCheckingLocation = true;

  // Lokasi dummy penjual (Toko MatrixSphere)
  final double _sellerLatitude = -6.9175; // Contoh: Bandung
  final double _sellerLongitude = 107.6191;
  
  @override
  void initState() {
    super.initState();
    // Cek lokasi saat layar pertama kali dibuka
    _checkInitialLocation();
  }

  /// Meminta izin dan mendapatkan lokasi awal pengguna.
  /// Mengembalikan jarak dalam meter atau melempar Exception jika gagal.
  Future<double> _requestPermissionAndGetDistance() async {
    final status = await perm_handler.Permission.location.status;

    if (status.isGranted) {
      // Izin sudah diberikan, langsung hitung jarak.
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return _calculateDistance(position);
    }

    if (status.isPermanentlyDenied) {
      // Izin ditolak permanen, tampilkan dialog untuk membuka pengaturan.
      if (mounted) {
        await showDialog(
          context: context, // Konteks ini aman karena ada 'mounted' check
          builder: (ctx) => AlertDialog(
            title: const Text('Izin Lokasi Diperlukan'),
            content: const Text('Aplikasi ini memerlukan akses lokasi untuk memvalidasi jarak Anda dari toko. Silakan aktifkan izin lokasi di pengaturan aplikasi.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Batal')),
              TextButton(
                onPressed: () {
                  perm_handler.openAppSettings();
                  Navigator.of(ctx).pop();
                },
                child: const Text('Buka Pengaturan'),
              ),
            ],
          ),
        );
      }
      throw Exception('Izin lokasi ditolak secara permanen.');
    }

    // Jika izin belum diminta atau hanya ditolak sementara.
    final newStatus = await perm_handler.Permission.location.request();
    if (newStatus.isGranted) {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return _calculateDistance(position);
    } else {
      throw Exception('Izin lokasi ditolak. Jarak tidak dapat divalidasi.');
    }
  }

  /// Menghitung jarak dari posisi pengguna ke penjual.
  double _calculateDistance(Position position) {
    return Geolocator.distanceBetween(
      _sellerLatitude, _sellerLongitude,
      position.latitude, position.longitude,
    );
  }

  /// Fungsi untuk mengecek lokasi saat pertama kali layar dimuat.
  Future<void> _checkInitialLocation() async {
    try {
      final distance = await _requestPermissionAndGetDistance();
      if (mounted) {
        setState(() {
          _distanceInMeters = distance;
          _isCheckingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.orange,
        ));
      }
    }
  }

  Future<void> _processOrder() async {
    // Ambil referensi ScaffoldMessenger sebelum async gap untuk pesan error awal.
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (_selectedPaymentMethod == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih metode pembayaran terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessingOrder = true;
    });

    // Ambil semua referensi yang bergantung pada context SEBELUM async gap.
    final cart = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final goRouter = GoRouter.of(context);

    try {
      // 1. Validasi jarak yang sudah dihitung sebelumnya.
      if (_distanceInMeters == null) {
        throw Exception('Lokasi belum terverifikasi. Silakan coba lagi.');
      }

      // 2. Jika jarak > 2km dan <= 3km, tampilkan dialog konfirmasi.
      if (_distanceInMeters! > 2000 && _distanceInMeters! <= 3000) {
        final bool? shouldProceed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Peringatan Jarak'),
            content: const Text('Jarak Anda lebih dari 2 km. Proses penjemputan mungkin membutuhkan waktu lebih lama. Apakah Anda ingin melanjutkan?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Batal')),
              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Lanjutkan')),
            ],
          ),
        );

        // Jika pengguna membatalkan, hentikan proses.
        if (shouldProceed != true) {
          if (mounted) setState(() => _isProcessingOrder = false);
          return;
        }
      }

      // 3. Jika jarak > 3km (seharusnya tidak terjadi karena tombol dinonaktifkan,
      //    tapi sebagai pengaman tambahan).
      if (_distanceInMeters! > 3000) {
        throw Exception('Jarak Anda lebih dari 3 km. Pesanan tidak dapat diproses.');
      }


      // 4. Jika lokasi valid, proses pesanan
      final paymentMethodName = availablePaymentMethods.firstWhere((m) => m.value == _selectedPaymentMethod).name;

      final newOrder = orderProvider.addOrder(cart.items, cart.totalPrice, paymentMethodName);
      
      if (mounted) {
        cart.clearCart(); // Kosongkan keranjang setelah pesanan berhasil dibuat
        goRouter.go('/order-success/${newOrder.id}');
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibuat! Silakan jemput pesanan Anda.')));
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isProcessingOrder = false);
    }
  }

  String _getDistanceStatusMessage() {
    if (_isCheckingLocation) {
      return 'Sedang memverifikasi lokasi Anda...';
    }
    if (_distanceInMeters == null) {
      return 'Gagal memverifikasi lokasi. Izin diperlukan.';
    }
    if (_distanceInMeters! > 3000) {
      return 'Jarak Anda lebih dari 3 km, pesanan tidak dapat diproses.';
    }
    return 'Lokasi Anda terverifikasi.';
  }
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    // Pengaman jika pengguna masuk ke halaman ini dengan keranjang kosong
    if (cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(
          child: Text('Tidak ada item untuk di-checkout.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Checkout'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
              title: 'Lokasi Penjemputan',
              child: PickupLocationCard(
                  isCheckingLocation: _isCheckingLocation,
                  distanceInMeters: _distanceInMeters,
                  distanceStatusMessage: _getDistanceStatusMessage())),
          const SizedBox(height: 24),

          // Bagian Ringkasan Pesanan
          _buildSection(
            title: 'Ringkasan Pesanan', child: OrderSummaryCard(cart: cart)),
          const SizedBox(height: 24),

          // Bagian Metode Pembayaran
          _buildSection(
            title: 'Metode Pembayaran',
            child: PaymentMethodSelector(
              selectedPaymentMethod: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            )),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          // Tombol dinonaktifkan jika sedang proses, sedang cek lokasi,
          // atau jarak lebih dari 3km.
          onPressed: (_isProcessingOrder || _isCheckingLocation || (_distanceInMeters ?? 3001) > 3000) ? null : _processOrder,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isProcessingOrder
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                )
              : const Text('Bayar Sekarang'),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
