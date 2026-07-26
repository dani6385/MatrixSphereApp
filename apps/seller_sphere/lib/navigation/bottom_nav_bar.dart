import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';

/// A custom bottom navigation bar widget that is reusable across the app.
///
/// It takes the current index and an onTap callback to handle navigation.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// The index of the currently active tab.
  final int currentIndex;

  /// The callback function that is executed when a tab is tapped.
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    // Daftar data untuk setiap tab
    final List<Map<String, dynamic>> tabsData = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'text': 'Home'},
      {
        'icon': Icons.cast,
        'activeIcon': Icons.cast_connected,
        'text': 'Streaming'
      },
      {
        'icon': Icons.inventory_2_outlined,
        'activeIcon': Icons.inventory_2,
        'text': 'Inventory'
      },
      {
        'icon': Icons.inventory_2,
        'activeIcon': Icons.inventory_2_outlined,
        'text': 'Kios'
      },
      {
        'icon': Icons.fingerprint_outlined,
        'activeIcon': Icons.fingerprint,
        'text': 'Absen'
      },
    ];

    // --- AWAL PERUBAHAN ---
    // Bungkus dengan Theme untuk mengontrol properti visual seperti bayangan.
    return Theme(
      data: Theme.of(context).copyWith(
        // Mengatur warna bayangan menjadi transparan untuk menghilangkannya.
        shadowColor: Colors.transparent,
      ),
      child: SharedBottomNavigationBar(
        selectedIndex: currentIndex,
        onItemTapped: onTap,
        // Membuat daftar GButton secara dinamis
        tabs: List.generate(tabsData.length, (index) {
          final isSelected = index == currentIndex;
          final tab = tabsData[index];

          return GButton(
            // Gunakan ikon 'active' jika terpilih, jika tidak gunakan ikon standar
            icon: isSelected ? tab['activeIcon'] : tab['icon'],
            text: tab['text'],
            // Perbesar ukuran ikon jika terpilih
            iconSize: isSelected ? 28 : 24,
          );
        }),
      ),
    );
    // --- AKHIR PERUBAHAN ---
  }
}
