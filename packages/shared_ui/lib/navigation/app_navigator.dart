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
    /*HomeContent(),
    SellerScreen(),
    ApprovalScreen(),*/
    Center(child: Text('System Screen', style: TextStyle(color: Colors.white))),
    Center(child: Text('Settings Screen', style: TextStyle(color: Colors.white))),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
            _buildNavItem(icon: Icons.business, label: 'Seller', index: 1),
            const SizedBox(width: 40), // The space for the FAB
            _buildNavItem(icon: Icons.system_update, label: 'System', index: 3),
            _buildNavItem(icon: Icons.settings, label: 'Settings', index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
