import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart'; // Pastikan sudah di-export

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Layanan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Selamat Datang",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 1. Grid untuk menu 2 kolom
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 5.0,
                      children: [
                        // Tombol-tombol grid
                        _buildMenuButton(
                          'Voucher',
                          Icons.card_membership,
                          () => UIService.showVoucherDialog(context),
                        ),
                        _buildMenuButton(
                          'Member',
                          Icons.person_add,
                          () => UIService.showMemberForm(context),
                        ),
                        _buildMenuButton(
                          'Scan QRIS',
                          Icons.qr_code_scanner,
                          () => UIService.showQRScanner(context),
                        ),
                        _buildMenuButton(
                          'Beli Kuota',
                          Icons.data_usage,
                          () => UIService.showBeliKuota(context),
                        ),
                      ],
                    ),
                  ),

                  // 2. Tombol Trial yang Full Width (di bawah grid)
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity, // Membuat lebar penuh
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => UIService.showTrialDialog(context),
                      icon: const Icon(Icons.access_time),
                      label: const Text("Mulai Trial"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat tombol grid
  Widget _buildMenuButton(String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title),
    );
  }
}
