import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_navigations/shared_navigations.dart';
/// Widget yang berfungsi sebagai shell UI utama aplikasi.
///
/// Ini membangun Scaffold dengan BottomNavigationBar dan menggunakan
/// [navigationShell] yang disediakan oleh GoRouter untuk menampilkan
/// konten halaman yang sesuai dengan tab yang aktif.
class BottomNavBar extends StatelessWidget {
  /// Widget yang disediakan oleh [StatefulShellRoute] untuk merender
  /// halaman dari branch yang sedang aktif.
  final Widget navigationShell;

  /// Indeks dari tab yang sedang aktif.
  final int currentIndex;

  /// Callback yang dipanggil ketika tab baru dipilih.
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.navigationShell,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // INI BAGIAN PENTING:
      // Tampilkan konten dari rute yang aktif di sini.
      body: navigationShell,

      // Ganti BottomNavigationBar standar dengan SharedBottomNavBar kustom.
      // SharedBottomNavBar menggunakan CurvedNavigationBar di dalamnya.
      bottomNavigationBar: SharedBottomNavBar(
        selectedIndex: currentIndex,
        onTap: onTap,
        // SharedBottomNavBar memerlukan List<GButton> untuk tabs-nya.
        tabs: const [
          GButton(icon: Icons.home_outlined, text: 'Home'),
          GButton(icon: Icons.check_circle_outline, text: 'Approvals'),
          GButton(icon: Icons.analytics_outlined, text: 'Analytics'),
          GButton(icon: Icons.receipt_long_outlined, text: 'Transactions'),
          GButton(icon: Icons.co_present_outlined, text: 'Attendance'),
        ],
      ),
    );
  }
}
