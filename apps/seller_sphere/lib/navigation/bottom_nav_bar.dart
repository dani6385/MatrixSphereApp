import 'package:flutter/material.dart';
//import 'app_routes.dart';
import 'app_extractor.dart';
import 'package:shared_ui/shared_ui.dart';

/// A wrapper widget that configures and displays the [SharedBottomNavBar]
/// with tabs specific to the Seller Sphere application.
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This widget is stateless, so    // it will return the SharedBottomNavBar directly.
    return SharedBottomNavBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Streams',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Management',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.live_tv),
          label: 'Seller',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Attendance',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap ?? (index) {}, tabs: const [], selectedIndex: currentIndex,
    );
  }
}
