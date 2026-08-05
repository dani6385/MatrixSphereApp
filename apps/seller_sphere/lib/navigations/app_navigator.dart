import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:provider/provider.dart';
//import 'app_extractor.dart';
//import '../providers/app_viewmodel.dart';
import 'bottom_nav_bar.dart';
import 'widgets/app_navigator_drawer.dart';
import 'widgets/app_navigator_end_drawer.dart';

class AppNavigator extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigator({super.key, required this.navigationShell});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  // Fungsi untuk memberitahu GoRouter agar berpindah branch/tab
  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return /*MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AppViewModel()),
      ],
      child: */Scaffold(
        extendBody: true,
        body: widget.navigationShell,
        drawer: const AppNavigatorDrawer(),
        endDrawer: const AppNavigatorEndDrawer(),
        bottomNavigationBar: BottomNavBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _onItemTapped,
        ),
      //),
    );
  }
}