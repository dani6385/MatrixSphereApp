import 'package:flutter/material.dart';
import 'package:shared_ui/widgets/app_navigation.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Screen'),
    Text('Seller Screen'),
    Text('Approval Screen'),
    Text('System Screen'),
    Text('Settings Screen'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: AppNavigation(
        currentIndex: _selectedIndex,
        onTapped: _onItemTapped,
      ),
    );
  }
}
