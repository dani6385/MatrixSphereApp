import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart'; // Import package shared Anda
// Import file locator

class CreateVoucher extends StatefulWidget {
  const CreateVoucher({super.key});

  @override
  State<CreateVoucher> createState() => _CreateVoucherPageState();
}

class _CreateVoucherPageState extends State<CreateVoucher> {
  // 1. Memanggil service melalui locator
  final dynamic mikrotikService = getIt<MikrotikService>();

  // 2. Fungsi untuk handle aksi tombol
  void handleCreateVoucher() async {
    // Tampilkan loading (opsional)

    bool success = await mikrotikService.createVoucher(
      name: "VOUCHER001",
      profile: "1jam",
      limitUptime: "1h",
    );

    if (mounted) {
      // Selalu cek mounted sebelum panggil setState atau context setelah await
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Voucher berhasil dibuat!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal membuat voucher")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Voucher")),
      body: Center(
        child: ElevatedButton(
          onPressed: handleCreateVoucher, // 3. Pasang fungsi di sini
          child: const Text("Buat Voucher Sekarang"),
        ),
      ),
    );
  }
}
