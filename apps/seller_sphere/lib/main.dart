import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/home_screen.dart';

import 'package:shared_ui/shared_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seller Sphere',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kBrandPrimary,
          brightness: Brightness.dark,
          surface: kDarkBackground,
        ),
        useMaterial3: true,
      ),
      home: const AppScaffold(),
    );
  }
}

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
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
