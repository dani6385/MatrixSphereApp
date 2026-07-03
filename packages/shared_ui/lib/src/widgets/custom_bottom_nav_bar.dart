import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/models/bottom_nav_item.dart';
import 'package:shared_ui/theme/app_theme.dart';

/// Widget Bottom Navigation Bar kustom dengan desain melengkung.
class CustomBottomNavBar extends StatelessWidget {
  /// Daftar item yang akan ditampilkan di bilah navigasi.
  final List<BottomNavItem> items;

  /// Indeks item yang sedang aktif/dipilih.
  final int currentIndex;

  /// Callback yang dipanggil saat item ditekan.
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.primary, // Warna latar belakang utama
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items.map((item) {
          int index = items.indexOf(item);
          bool isSelected = index == currentIndex;
          return _buildNavItem(item, isSelected, () => onTap(index));
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem(BottomNavItem item, bool isSelected, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isSelected ? 100 : 70,
        height: 60,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSelected ? 40 : 30,
              height: isSelected ? 40 : 30,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: isSelected ? AppTheme.primary : Colors.white.withOpacity(0.8),
                size: isSelected ? 24 : 22,
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  item.label,
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
          ],
        ),
      ),
    );
  }
}
