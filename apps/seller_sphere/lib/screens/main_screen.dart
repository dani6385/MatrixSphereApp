import 'package:flutter/material.dart';
//import '../features/pos/screens/pos_screen.dart';
import 'home_screen.dart';
import 'streaming_screen.dart';
import '../widgets/bottom_nav_bar.dart';

// Placeholder screens for other tabs
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Report Screen', style: TextStyle(color: Colors.white))));
}

class TrendScreen extends StatelessWidget {
  const TrendScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Trend Screen', style: TextStyle(color: Colors.white))));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    StreamingScreen(),
    //POSScreen(),
    ReportScreen(),
    TrendScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
