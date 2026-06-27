import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class _TabSpec {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int? branchIndex;

  const _TabSpec({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.branchIndex,
  });
}

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedVisualIndex = 0;

  static const List<_TabSpec> _tabs = [
    _TabSpec(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'Status',
      icon: Icons.wifi_outlined,
      activeIcon: Icons.wifi_rounded,
      branchIndex: 1,
    ),
    _TabSpec(
      label: 'Transaksi',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      branchIndex: null, // stub
    ),
    _TabSpec(
      label: 'Akun',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      branchIndex: null, // stub
    ),
    _TabSpec(
      label: 'Settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      branchIndex: null, // stub
    ),
  ];

  void _onTabTap(int visualIndex) {
    final tab = _tabs[visualIndex];
    if (tab.branchIndex == null) return; // stub — silent ignore
    setState(() => _selectedVisualIndex = visualIndex);
    widget.navigationShell.goBranch(
      tab.branchIndex!,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(covariant AppNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentBranch = widget.navigationShell.currentIndex;
    for (int i = 0; i < _tabs.length; i++) {
      if (_tabs[i].branchIndex == currentBranch) {
        if (_selectedVisualIndex != i) {
          setState(() => _selectedVisualIndex = i);
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottomPadding + 12),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withAlpha(89),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabs.length, (i) {
            final tab = _tabs[i];
            final isActive = _selectedVisualIndex == i;
            final isStub = tab.branchIndex == null;
            final opacity = isStub ? 0.4 : 1.0;

            return Expanded(
              child: Opacity(
                opacity: opacity,
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
                      if (!isActive) ...[
                        Icon(tab.icon, color: Colors.white, size: 22),
                        const SizedBox(height: 2),
                        Text(
                          tab.label,
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
              ),
            );
          }),
        ),
      ),
    );
  }
}
