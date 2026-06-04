import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Material agar teks memiliki default font/style yang benar
    return Material(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "STRUK PEMBAYARAN",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const Text("Item: Layanan Internet"),
            const Text("Harga: Rp 10.000"),
            // Tambahkan elemen lainnya di sini
          ],
        ),
      ),
    );
  }
}