// lib/src/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:seller_sphere/navigation/app_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';

/// A custom bottom navigation bar widget that is reusable across the app.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// Indeks tab yang sedang aktif saat ini.
  final int currentIndex;

  /// Fungsi callback saat salah satu tab ditekan.
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    // Data untuk ikon, dipetakan berdasarkan rute
    const Map<String, ({IconData icon, IconData activeIcon})> tabIcons = {
      AppRoutes.home: (
        icon: Icons.home_outlined,
        activeIcon: Icons.home
        ),
      AppRoutes.stream: (
        icon: Icons.cast,
        activeIcon: Icons.cast_connected
        ),
      AppRoutes.inventory: (
        icon: Icons.point_of_sale,
        activeIcon: Icons.point_of_sale_outlined
      ),
      AppRoutes.sellers: (
        icon: Icons.inventory_2,
        activeIcon: Icons.inventory_2_outlined
      ),
      AppRoutes.attendance: (
        icon: Icons.fingerprint_outlined,
        activeIcon: Icons.fingerprint
      ),
    };

    final theme = Theme.of(context);

    // Menggunakan ClipPath untuk membuat bentuk melengkung ke bawah.
    return ClipPath(
      clipper: _BottomNavClipper(), // Clipper kustom untuk bentuknya
      child: Container(
        // Tinggi container perlu didefinisikan agar lengkungan terlihat.
        // Sesuaikan nilai 80.0 ini jika perlu.
        height: 80.0,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, // Menggunakan warna dari tema
        ),
        child: GNav(
          backgroundColor: kTransparent,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6), // Ikon tidak aktif
          activeColor: theme.colorScheme.onSurface, // Ikon aktif
          // Warna latar item aktif dibuat sedikit lebih terang dari background utama
          tabBackgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          selectedIndex: currentIndex,
          onTabChange: onTap,
          tabs: List.generate(appShellBranches.length, (index) {
            final isSelected = index == currentIndex;
            final routePath =
                (appShellBranches[index].routes.first as dynamic).path;
            final icons = tabIcons[routePath]!;
            return GButton(
              icon: isSelected ? icons.activeIcon : icons.icon,
              text: '', // Teks dikosongkan sesuai desain
              iconSize: 26,
            );
          }),
        ),
      ),
    );
  }
}

/// CustomClipper untuk membuat bentuk navigasi bawah yang melengkung ke bawah.
class _BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Kedalaman lengkungan, bisa Anda sesuaikan.
    const double curveDepth = 20.0;

    // 1. Mulai dari kiri atas, tapi sedikit ke bawah untuk awal lengkungan.
    path.moveTo(0, curveDepth);

    // 2. Buat kurva Bezier kuadratik ke tengah atas, lalu ke kanan atas.
    // Titik kontrolnya ada di tengah-bawah, yang membuat lengkungan ke bawah.
    path.quadraticBezierTo(size.width / 2, 0, size.width, curveDepth);

    // 3. Tarik garis lurus ke kanan bawah.
    path.lineTo(size.width, size.height);

    // 4. Tarik garis lurus ke kiri bawah.
    path.lineTo(0, size.height);

    // 5. Tutup path kembali ke titik awal.
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // Tidak perlu menggambar ulang jika ukuran tidak berubah.
  }
}
