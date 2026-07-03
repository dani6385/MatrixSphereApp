import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

import '../../providers/order_provider.dart';
import 'package:shared_ui/shared_ui.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedPaymentMethod;
  bool _isProcessingOrder = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Transfer Bank', 'icon': Icons.account_balance, 'value': 'bank_transfer'},
    {'name': 'E-Wallet (GoPay, OVO)', 'icon': Icons.account_balance_wallet, 'value': 'e_wallet'},
    {'name': 'Kartu Kredit/Debit', 'icon': Icons.credit_card, 'value': 'credit_card'},
    {'name': 'Bayar di Tempat (COD)', 'icon': Icons.storefront, 'value': 'cod'},
  ];

  // Lokasi dummy penjual (Toko MatrixSphere)
  final double _sellerLatitude = -6.9175; // Contoh: Bandung
  final double _sellerLongitude = 107.6191;
  
  /// Menangani validasi lokasi dengan UX yang lebih baik.
  /// Melempar Exception jika validasi gagal.
  Future<void> _handleLocationValidation() async {
    final status = await perm_handler.Permission.location.status;

    if (status.isGranted) {
      // Izin sudah diberikan, lanjutkan validasi jarak.
      await _validateDistance();
      return;
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
      await _validateDistance();
    } else {
      throw Exception('Izin lokasi ditolak. Tidak dapat memproses pesanan.');
    }
  }

  /// Mengambil posisi pengguna dan memvalidasi jaraknya dari penjual.
  Future<void> _validateDistance() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final distanceInMeters = Geolocator.distanceBetween(
      _sellerLatitude, _sellerLongitude,
      position.latitude, position.longitude,
    );

    if (distanceInMeters > 2000) {
      throw Exception('Jarak Anda lebih dari 2 km dari lokasi penjual. Pesanan tidak dapat diproses.');
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
      // 1. Validasi lokasi dengan UX yang lebih baik
      await _handleLocationValidation();

      // 2. Jika lokasi valid, proses pesanan
      final paymentMethodName = _paymentMethods.firstWhere((m) => m['value'] == _selectedPaymentMethod)['name'];

      orderProvider.addOrder(cart.items, cart.totalPrice, paymentMethodName);
      cart.clearCart();
      
      if (mounted) {
        goRouter.go('/home');
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibuat! Silakan jemput pesanan Anda.')));
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isProcessingOrder = false);
    }
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
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
            title: 'Lokasi Penjemputan',
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Toko MatrixSphere', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Jl. Digital No. 20, Gedung MatrixSphere Lt. 5, Kota Bandung, Jawa Barat 40222'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Bagian Ringkasan Pesanan
          _buildSection(
            title: 'Ringkasan Pesanan',
            child: Card(
              child: Column(
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cart.items.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('${item.quantity} x Rp ${item.price.toStringAsFixed(0)}'),
                        trailing: Text('Rp ${(item.quantity * item.price).toStringAsFixed(0)}'),
                      );
                    },
                  ),
                  const Divider(height: 1, thickness: 2),
                  ListTile(
                    title: const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(
                      'Rp ${cart.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Bagian Metode Pembayaran
          _buildSection(
            title: 'Metode Pembayaran',
            child: Card(
              child: Column(
                children: _paymentMethods.map((method) {
                  return RadioListTile<String>(
                    title: Text(method['name']),
                    secondary: Icon(method['icon'], color: AppColors.primary),
                    value: method['value'],
                    // ignore: deprecated_member_use
                    groupValue: _selectedPaymentMethod,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isProcessingOrder ? null : _processOrder,
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
