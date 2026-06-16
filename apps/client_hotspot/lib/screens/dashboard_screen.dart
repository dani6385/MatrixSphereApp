import 'package:flutter/material.dart';
// Impor yang benar dari file publik
import 'package:shared_services/shared_services.dart';
import './login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Fungsi untuk logout
  void _logout(BuildContext context) async {
    await AuthService.logout();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false, // Hapus semua riwayat navigasi
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2, // 2 kolom
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _buildMenuCard(context, Icons.person_add, 'Beli Voucher', Colors.orange, () {}),
          _buildMenuCard(context, Icons.wifi_tethering, 'Layanan Hotspot', Colors.blue, () {}),
          _buildMenuCard(context, Icons.history, 'Riwayat Transaksi', Colors.green, () {}),
          // Menambahkan aksi logout ke tombol 'Profil Saya'
          _buildMenuCard(context, Icons.account_circle, 'Profil Saya', Colors.purple, () {
            // Tampilkan dialog konfirmasi sebelum logout
            showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text('Konfirmasi Logout'),
                  content: const Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(), // Tutup dialog
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(); // Tutup dialog dulu
                        _logout(context); // Panggil fungsi logout
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // Widget pembantu untuk membuat kotak menu, sekarang dengan aksi `onTap`
  Widget _buildMenuCard(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap, // Menggunakan aksi yang diberikan
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
