import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_ui/shared_ui.dart';

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
    if (kIsWeb) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.all,
              backgroundColor: kDarkSurface,
              indicatorColor: kBrandPrimary,
              selectedIconTheme: const IconThemeData(color: kDarkTextPrimary),
              unselectedIconTheme:
                  const IconThemeData(color: kDarkTextSecondary),
              selectedLabelTextStyle: const TextStyle(color: kDarkTextPrimary),
              unselectedLabelTextStyle:
                  const TextStyle(color: kDarkTextSecondary),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.business_outlined),
                    selectedIcon: Icon(Icons.business),
                    label: Text('Seller')),
                NavigationRailDestination(
                    icon: Icon(Icons.check_circle_outline),
                    selectedIcon: Icon(Icons.check_circle),
                    label: Text('Approval')),
                NavigationRailDestination(
                    icon: Icon(Icons.system_update_outlined),
                    selectedIcon: Icon(Icons.system_update),
                    label: Text('System')),
                NavigationRailDestination(
                    icon: Icon(Icons.fingerprint_outlined),
                    selectedIcon: Icon(Icons.fingerprint),
                    label: Text('Absensi')),
                NavigationRailDestination(
                    icon: Icon(Icons.calendar_month_outlined),
                    selectedIcon: Icon(Icons.calendar_month),
                    label: Text('Kalender')),
                NavigationRailDestination(
                    icon: Icon(Icons.person_2_outlined),
                    selectedIcon: Icon(Icons.person),
                    label: Text('Akun')),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: widget.navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      body: widget.navigationShell,
      bottomNavigationBar: CurvedNavigationBar(
        index: widget.navigationShell.currentIndex,
        height: 65,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: kDarkTextSecondary),
          Icon(Icons.business, size: 30, color: kDarkTextSecondary),
          Icon(Icons.system_update_outlined, size: 30, color: kDarkTextSecondary),
          Icon(Icons.fingerprint, size: 30, color: kDarkTextSecondary),
          Icon(Icons.system_update, size: 30, color: kDarkTextSecondary), // Ditambahkan
        ],
        onTap: _onItemTapped,
        color: kDarkBackground,
        buttonBackgroundColor: kBrandPrimary,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
