import 'package:flutter/material.dart';
//import '../screens/seller/seller_screen.dart';
//import '../screens/home/home_content.dart';
//import '../screens/approval/approval_screen.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('System Screen', style: TextStyle(color: Colors.white))),
    Center(
        child: Text('Settings Screen', style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Seller'),
          BottomNavigationBarItem(
              icon: Icon(Icons.approval), label: 'Approval'),
          BottomNavigationBarItem(
              icon: Icon(Icons.system_update), label: 'System'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
