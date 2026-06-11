import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AksesVoucherPage extends StatefulWidget {
  const AksesVoucherPage({super.key});

  @override
  State<AksesVoucherPage> createState() => _AksesVoucherPageState();
}

class _AksesVoucherPageState extends State<AksesVoucherPage> {
  // Controller untuk menangkap input dari user
  final TextEditingController _voucherController = TextEditingController();

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan Popup Input Voucher
  void _showVoucherPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Masukkan Kode Voucher"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _voucherController,
                decoration: const InputDecoration(
                  labelText: "Kode Voucher",
                  hintText: "Contoh: ABC123XYZ",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                String kode = _voucherController.text;
                if (kode.isNotEmpty) {
                  debugPrint("Memproses voucher: $kode");
                  // Panggil fungsi validasi voucher ke MikroTik
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Memproses voucher: $kode")),
                  );
                  await _validasiVoucherKeMikrotik(kode);
                }
              },
              child: const Text("Gunakan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Voucher")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _showVoucherPopup(context),
          icon: const Icon(Icons.confirmation_number),
          label: const Text("Masukkan Voucher"),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
        ),
      ),
    );
  }
}

// Contoh fungsi untuk mengecek voucher ke MikroTik
Future<void> _validasiVoucherKeMikrotik(String kode) async {
  // Ganti dengan IP Hotspot Anda
  final url = Uri.parse('http://192.168.20.1/login'); 
  
  try {
    final response = await http.post(url, body: {
      'username': kode, // Biasanya username di MikroTik adalah kode voucher
      'password': '',   // Kosongkan jika tidak pakai password
    });

    if (response.statusCode == 200) {
      debugPrint("Voucher berhasil terpakai!");
    } else {
      debugPrint("Voucher tidak valid!");
    }
  } catch (e) {
    debugPrint("Gagal terhubung ke router: $e");
  }
}