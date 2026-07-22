import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';
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
        // --- Implementasi CustomBottomNavigationBar ---
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onItemTapped: _onItemTapped,
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
        ),
      ),
    );
  }
}