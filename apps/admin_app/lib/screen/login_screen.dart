import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

import '../auth/mikrotik_hotspot.dart';
import '../bottom/member_bottom.dart';
import '../dialog/member_dialog.dart';
import '../dialog/voucher_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Fungsi untuk menangani login member
  void _handleMemberLogin() async {
    // Tampilkan dialog login member dan tunggu hasilnya
    final credentials = await showMemberLoginDialog(context);

    if (credentials != null && mounted) {
      final username = credentials['username']!;
      final password = credentials['password']!;

      AppLogger.info("Mencoba login sebagai member: $username");

      // Panggil logika login Mikrotik
      final bool success = await MikrotikHotspot.login(username, password);

      if (success && mounted) {
        AppLogger.info("HASIL: Login Member Berhasil!");
        // Jika berhasil, navigasi ke halaman member
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MemberBottom()),
        );
      } else {
        AppLogger.warning("HASIL: Login Member Gagal.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Gagal. Periksa koneksi atau kredensial Anda.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Fungsi untuk menangani login voucher
  void _handleVoucherLogin() async {
    // Tampilkan dialog voucher dan tunggu hasilnya
    final voucherCode = await showVoucherDialog(context);

    if (voucherCode != null && mounted) {
      AppLogger.info("Mencoba login dengan voucher: $voucherCode");

      // Panggil logika login Mikrotik (voucher seringkali hanya butuh username)
      final bool success = await MikrotikHotspot.login(voucherCode, '');

      if (success && mounted) {
        AppLogger.info("HASIL: Login Voucher Berhasil!");
        // Di sini Anda mungkin ingin navigasi ke halaman status atau halaman sukses
        // Untuk saat ini, kita hanya akan log dan tampilkan SnackBar sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Voucher Berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        AppLogger.warning("HASIL: Login Voucher Gagal.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Gagal. Periksa koneksi atau kode voucher.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotspot Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _handleMemberLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Login Member'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleVoucherLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Login Voucher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
