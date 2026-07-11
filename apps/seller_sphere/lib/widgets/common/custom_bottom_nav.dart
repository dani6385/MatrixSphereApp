import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20, top: 8),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF008577),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, "Home", 0, theme),
            _buildNavItem(Icons.live_tv, "Streaming", 1, theme),
            _buildNavItem(Icons.receipt_long, "Transaction", 2, theme),
            _buildNavItem(Icons.assessment, "Laporan", 3, theme),
            _buildNavItem(Icons.trending_up, "Trend", 4, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String title,
    int index,
    ThemeData theme,
  ) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Semantics(
        label: title,
        selected: isSelected,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.white.withAlpha(50) : Colors.transparent,
          ),
          child: Icon(
            icon,
            color: Colors.white.withAlpha(isSelected ? 255 : 150),
            size: 24,
          ),
        ),
      ),
    );
  }
}
