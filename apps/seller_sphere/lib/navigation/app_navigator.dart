import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart'; // <-- 1. IMPORT PROVIDER
import 'package:seller_sphere/screens/chat/Providers/chat_provider.dart';
import '../screens/attendance/providers/attendance_provider.dart';

class AppNavigator extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigator({super.key, required this.navigationShell});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: Scaffold(
        extendBody: true,
        body: widget.navigationShell,
        // --- Implementasi GNav langsung untuk kontrol penuh ---
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withValues(alpha: 0.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Theme.of(context).primaryColor,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                color: Colors.grey[600],
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Beranda',
                  ),
                  GButton(
                    icon: Icons.live_tv,
                    text: 'Live',
                  ),
                  GButton(
                    icon: Icons.point_of_sale,
                    text: 'Kasir',
                  ),
                  GButton(
                    icon: Icons.inventory_2,
                    text: 'Inventori',
                  ),
                  GButton(
                    icon: Icons.how_to_reg,
                    text: 'Absensi',
                  ),
                ],
                selectedIndex: widget.navigationShell.currentIndex,
                onTabChange: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}