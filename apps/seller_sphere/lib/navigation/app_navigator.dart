import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart'; // <-- 1. IMPORT PROVIDER
import 'package:seller_sphere/screens/chat/Providers/chat_provider.dart';
import 'package:shared_ui/shared_ui.dart';
import '../providers/app_viewmodel.dart';

class AppNavigator extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigator({super.key, required this.navigationShell});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  // Fungsi untuk memberitahu GoRouter agar berpindah branch/tab
  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AppViewModel()),
      ],
      child: Scaffold(
        extendBody: true,
        body: widget.navigationShell,
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onItemTapped: _onItemTapped,
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.live_tv, text: 'Stream'),
            GButton(icon: Icons.point_of_sale, text: 'Sellers'),
            GButton(icon: Icons.inventory_2, text: 'Inventory'),
            GButton(icon: Icons.how_to_reg, text: 'Attendance'),
          ],
        ),
      ),
    );
  }
}
