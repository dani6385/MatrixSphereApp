import 'package:flutter/material.dart';
import 'dashboard_client.dart';
import '../services/hotspot_service.dart';
import 'package:shared_core/mikrotik/akses_voucher.dart';
import 'package:shared_core/shared_core.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  String chapId = '';
  String chapChallenge = '';

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Fungsi bantuan untuk memanggil Popup
  void _showPopup(BuildContext context, Widget page) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: page,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Metode Hotspot"), elevation: 0),
      // Firebase Firestore dihapus dari sini
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildMenuButton(
                    context,
                    "Voucher",
                    Icons.confirmation_number,
                    onPressed: () =>
                        _showPopup(context, const AksesVoucherPage()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMenuButton(
                    context,
                    "Member",
                    Icons.person,
                    // Di dalam Dashboard_Screen.dart
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // User tidak bisa menutup popup tanpa login/batal
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AksesMemberPage(
                              onLoginSuccess: () async {
                                // 1. Tampilkan indikator loading (opsional, bisa pakai showDialog lagi)

                                // 2. Panggil Service Login
                                HotspotService service = HotspotService();

                                // Catatan: Pastikan Anda sudah mengambil chapId & challenge
                                // dari router sebelum baris ini
                                await service.login(
                                  usernameController.text, // 1
                                  passwordController.text, // 2
                                  chapId, // 3
                                  chapChallenge, // 4
                                );

                                // 3. Tutup Popup
                                if (context.mounted) {
                                  Navigator.of(context).pop(); // Menutup dialog

                                  // 4. Navigasi ke DashboardClient
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardClient(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildMenuButton(
                    context,
                    "QR scander",
                    Icons.qr_code_scanner,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('QR Scanner belum tersedia.'),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _buildMenuButton(context, "Beli Kuota", Icons.wifi),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildMenuButton(context, "Trial", Icons.timer, isFullWidth: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onPressed,
    bool isFullWidth = false,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(icon),
        label: Text(title),
        onPressed:
            onPressed ??
            () {
              debugPrint("$title ditekan");
            },
      ),
    );
  }
}
