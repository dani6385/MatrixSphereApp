import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});
 @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final TextEditingController kodeController = TextEditingController();

  // Fungsi untuk mendapatkan ID perangkat
  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    }
    return "unknown_device";
  }

  // FUNGSI _handleAktivasi yang Anda tanyakan
  void _handleAktivasi() async {
    String deviceId = await getDeviceId();
    String kode = kodeController.text;

    if (kode.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Masukkan kode voucher!")));
      return;
    }

    // Memanggil service yang sudah kita buat tadi
    String hasil = await DatabaseService().prosesVoucher(kode, deviceId);

    // Menampilkan pesan hasil ke user
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hasil)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aktivasi Voucher")),
      body: Column(
        children: [
          TextField(controller: kodeController, decoration: InputDecoration(labelText: "Masukkan Kode")),
          ElevatedButton(
            onPressed: _handleAktivasi, // Memanggil fungsi di sini
            child: Text("Aktifkan"),
          ),
        ],
      ),
    );
  }
}