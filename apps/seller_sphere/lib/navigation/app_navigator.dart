import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
//import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
        // --- PERUBAHAN DARI CurvedNavigationBar KE BottomNavigationBar STANDAR ---
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cast),
              activeIcon: Icon(Icons.cast_connected),
              label: 'Stream',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale_outlined),
              activeIcon: Icon(Icons.point_of_sale),
              label: 'Kasir',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fingerprint),
              label: 'Absensi',
            ),
          ],
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _onItemTapped, // Fungsi ini tetap sama, untuk berpindah branch
          // --- Styling untuk tema gelap ---
          type: BottomNavigationBarType.fixed, // Agar semua label terlihat
          backgroundColor: kDarkSurface, // Warna latar belakang bar
          selectedItemColor: kBrandPrimary, // Warna ikon & label yang aktif
          unselectedItemColor:
              kDarkTextSecondary, // Warna ikon & label yang tidak aktif
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
