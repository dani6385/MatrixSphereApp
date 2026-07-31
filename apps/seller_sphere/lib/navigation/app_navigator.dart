import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart'; // <-- 1. IMPORT PROVIDER
import 'package:seller_sphere/navigation/app_extraktor.dart';
import '../providers/app_viewmodel.dart';
import 'app_navigation.dart';
import 'package:shared_ui/shared_ui.dart';
import 'bottom_nav_bar.dart';

class AppNavigator extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigator({super.key, required this.navigationShell});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  // Fungsi untuk memberitahu GoRouter agar berpindah branch/tab
  void _onItemTapped(int index) {
    // Menggunakan navigationShell untuk berpindah antar branch (tab)
    // tanpa kehilangan state di setiap tab.
    widget.navigationShell.goBranch(index);
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
        // Contoh implementasi Drawer
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: kTransparent,
                ),
                child: Text('Menu Utama', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil Saya'),
                onTap: () {
                  // Tutup drawer terlebih dahulu
                  Navigator.pop(context);
                  // Gunakan AppNavigation untuk berpindah halaman
                  AppNavigation.pushToProfile(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Logout (ke Halaman Login)'),
                onTap: () => AppNavigation.goToLogin(context),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
