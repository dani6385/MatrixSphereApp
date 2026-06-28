import 'widgets/member_tab_widget.dart';
import '../../routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:slide_to_act/slide_to_act.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Helper untuk menampilkan popup (modal bottom sheet)
  void _showPopup(BuildContext context, {required String title, required Widget child}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: child,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo atau Judul
              Text(
                'Selamat Datang',
                style: GoogleFonts.dmSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              Text(
                'Pilih metode login Anda',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // Grid 2x2 untuk tombol
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _LoginMenuButton(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Vouchers',
                    onTap: () => _showPopup(context, title: 'Gunakan Voucher', child: const Center(child: Text('UI Voucher di sini'))),
                  ),
                  _LoginMenuButton(
                    icon: Icons.person_outline,
                    label: 'Member',
                    onTap: () => _showPopup(context, title: 'Login Member', child: const MemberTabWidget()),
                  ),
                  _LoginMenuButton(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'Scan QR',
                    onTap: () => _showPopup(context, title: 'Scan QR Code', child: const Center(child: Text('UI Scan QR di sini'))),
                  ),
                  _LoginMenuButton(
                    icon: Icons.qr_code_2_rounded,
                    label: 'Bayar QR',
                    onTap: () => _showPopup(context, title: 'Pembayaran QRIS', child: const Center(child: Text('UI Pembayaran QRIS di sini'))),
                  ),
                ],
              ),
              const Spacer(),

              // Slider untuk Trial
              SlideAction(
                text: 'Geser untuk coba gratis',
                textStyle: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w600),
                outerColor: AppTheme.primary,
                innerColor: Colors.white,
                sliderButtonIcon: const Icon(Icons.wifi, color: AppTheme.primary),
                onSubmit: () {
                  // Aksi setelah slider selesai digeser
                  // Kita bisa langsung navigasi atau tampilkan popup konfirmasi
                  context.go(AppRoutes.homeScreen);
                  return null; // Return null untuk animasi default
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget kustom untuk tombol menu agar tidak duplikat kode
class _LoginMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LoginMenuButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withAlpha(1), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppTheme.primary),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}