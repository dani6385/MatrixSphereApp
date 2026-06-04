import 'package:flutter/material.dart';

class LoginOptionsScreen extends StatelessWidget {
  const LoginOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Metode Login'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Memusatkan secara vertikal
          children: [
            // Baris Pertama
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    context,
                    icon: Icons.person_pin,
                    label: 'Login Member',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 16), // Jarak antar tombol
                Expanded(
                  child: _buildOptionButton(
                    context,
                    icon: Icons.confirmation_number,
                    label: 'Gunakan Voucher',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Jarak antar baris
            // Baris Kedua
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    context,
                    icon: Icons.qr_code_scanner,
                    label: 'Scan QRIS',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOptionButton(
                    context,
                    icon: Icons.credit_card,
                    label: 'Bayar dengan QRIS',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget ini sekarang membangun sebuah ElevatedButton dengan ukuran tetap
  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        // Mengatur ukuran tetap 180x10 sesuai permintaan
        fixedSize: const Size(180, 10),
      ),
      // PENTING: Konten (ikon dan teks) di bawah ini terlalu besar
      // untuk dimuat dalam tinggi 10 piksel dan akan menyebabkan error.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
