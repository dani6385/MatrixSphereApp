import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Model untuk merepresentasikan satu item di dalam navigasi.
class MSBottomNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const MSBottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

/// Widget navigasi bawah kustom yang dapat digunakan kembali.
///
/// Widget ini menampilkan bar navigasi dengan animasi yang menarik
/// dan dapat dikonfigurasi melalui daftar [items].
class MSBottomNav extends StatelessWidget {
  /// Daftar item yang akan ditampilkan di navigasi.
  final List<MSBottomNavItem> items;

  /// Indeks item yang sedang aktif.
  final int currentIndex;

  /// Callback yang dipanggil ketika sebuah item ditekan.
  final ValueChanged<int> onTap;

  const MSBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      // Padding untuk memberikan ruang di sekitar navigasi
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottomPadding + 12),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withAlpha(89),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isActive = currentIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animasi untuk item yang aktif
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: isActive ? 44 : 0,
                      height: isActive ? 36 : 0,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: isActive
                          ? Icon(
                              item.activeIcon,
                              color: Colors.white,
                              size: 22,
                            )
                          : null,
                    ),
                    // Tampilkan ikon dan label jika tidak aktif
                    if (!isActive) ...[
                      Icon(item.icon, color: Colors.white, size: 22),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}