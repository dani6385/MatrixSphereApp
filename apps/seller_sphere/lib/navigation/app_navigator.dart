import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart'; // <-- 1. IMPORT PROVIDER
//import 'package:seller_sphere/features/chat/Providers/chat_provider.dart';
import '../providers/app_viewmodel.dart';
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
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AppViewModel()),
      ],
      child: Scaffold(
        extendBody: true,
        body: widget.navigationShell,
        bottomNavigationBar: BottomNavBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
