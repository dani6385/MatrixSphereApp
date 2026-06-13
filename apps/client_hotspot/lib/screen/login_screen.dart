import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
// Import utama dari shared_core yang mengekspor semua service yang diperlukan
import 'package:shared_core/shared_core.dart'; 
import 'package:client_hotspot/screen/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // --- Data Simulasi untuk Paket Internet ---
  static const List<InternetPackage> _packages = [
    InternetPackage(name: 'Paket Harian', price: 5000, validity: '1 Hari'),
    InternetPackage(name: 'Paket 3 Hari', price: 12000, validity: '3 Hari'),
    InternetPackage(name: 'Paket Mingguan', price: 25000, validity: '7 Hari'),
  ];

  // --- Logika Login Terpusat (Voucher) ---
  Future<void> _performVoucherLogin(BuildContext context, String voucherCode) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('Mencoba login...'), duration: Duration(seconds: 30)),
    );

    // Menggunakan kelas yang benar: MikrotikHotspot
    final bool success = await MikrotikHotspot.loginWithVoucher(voucherCode);
    scaffoldMessenger.hideCurrentSnackBar();

    if (success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Login berhasil!'), backgroundColor: Colors.green),
      );
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Login gagal! Kode salah atau sudah digunakan.'), backgroundColor: Colors.red),
      );
    }
  }

  // --- Logika Login Terpusat (Member/Trial) ---
  Future<void> _performMemberLogin(BuildContext context, String username, String password) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Mencoba login sebagai $username...'), duration: const Duration(seconds: 30)),
    );

    // Menggunakan kelas yang benar: MikrotikHotspot
    final bool success = await MikrotikHotspot.login(username, password);
    scaffoldMessenger.hideCurrentSnackBar();

    if (success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Login berhasil!'), backgroundColor: Colors.green),
      );
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Login gagal! Periksa kembali kredensial Anda.'), backgroundColor: Colors.red),
      );
    }
  }

  // --- Handlers untuk Tombol-tombol UI ---

  void _handleVoucherLogin(BuildContext context) async {
    final String? voucherCode = await showVoucherDialog(context);
    if (voucherCode != null && voucherCode.isNotEmpty) {
      await _performVoucherLogin(context, voucherCode);
    }
  }

  void _handleMemberLogin(BuildContext context) async {
    final MemberLoginDetails? details = await showMemberDialog(context);
    if (details != null) {
      await _performMemberLogin(context, details.username, details.password);
    }
  }

  void _handleQrisPayment(BuildContext context) async {
    final InternetPackage? selectedPackage = await showPackageSelectionDialog(context, _packages);
    if (selectedPackage == null) return;

    final bool? confirmedPayment = await showQrisDisplayDialog(context, selectedPackage);
    if (confirmedPayment != true) return;

    final String fakeVoucher = 'QRIS-${Random().nextInt(999999).toString().padLeft(6, '0')}';
    final bool? useAndLogin = await showVoucherResultDialog(context, fakeVoucher);

    if (useAndLogin == true) {
      await _performVoucherLogin(context, fakeVoucher);
    }
  }

  void _handleTrialLogin(BuildContext context) async {
    final bool confirmed = await showConfirmationDialog(
      context: context, 
      title: 'Gunakan Trial?', 
      content: 'Anda akan login menggunakan akses trial. Kecepatan dan durasi mungkin terbatas. Lanjutkan?',
      confirmText: 'Lanjutkan',
    );

    if (confirmed) {
      await _performMemberLogin(context, 'trial', 'trial');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotspot Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _handleVoucherLogin(context),
              child: const Text('Gunakan Voucher'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _handleMemberLogin(context),
              child: const Text('Login Member'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _handleQrisPayment(context),
              child: const Text('Bayar dengan QRIS'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _handleTrialLogin(context),
              child: const Text('Coba Gratis (Trial)'),
            ),
          ],
        ),
      ),
    );
  }
}
