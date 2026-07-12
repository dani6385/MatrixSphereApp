import 'package:flutter/material.dart';
import 'package:shared_ui/widgets/app_navigation.dart';

class AppScaffold extends StatefulWidget {
  final List<Widget> screens;
  const AppScaffold({super.key, required this.screens, required List<BottomNavigationBarItem> bottomNavBarItems});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: AppNavigation(
        currentIndex: _selectedIndex,
        onTapped: _onItemTapped,
      ),
    );
  }
}
