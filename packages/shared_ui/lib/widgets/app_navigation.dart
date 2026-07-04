import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/theme/app_color.dart';

// Menggunakan AppColors untuk warna

class AppTabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int? branchIndex;

  const AppTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.branchIndex,
  });
}

class AppBottomNav extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final List<AppTabItem> tabs;

  const AppBottomNav({
    required this.navigationShell,
    required this.tabs,
    super.key,
  });

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  int _selectedVisualIndex = 0;

  void _onTabTap(int index) {
    final branch = widget.tabs[index].branchIndex;
    if (branch == null) return;

    setState(() => _selectedVisualIndex = index);
    widget.navigationShell.goBranch(
      branch,
      initialLocation: branch == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottomPadding + 12),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(89),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(widget.tabs.length, (i) {
            final tab = widget.tabs[i];
            final isActive = _selectedVisualIndex == i;
            final isStub = tab.branchIndex == null;

            return Expanded(
              child: Opacity(
                opacity: isStub ? 0.4 : 1.0,
                child: GestureDetector(
                  onTap: () => _onTabTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                tab.activeIcon,
                                color: Colors.white,
                                size: 22,
                              )
                            : null,
                      ),
                      if (!isActive)
                        Icon(tab.icon, color: Colors.white, size: 22),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
