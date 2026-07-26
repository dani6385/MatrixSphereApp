import 'package:flutter/material.dart';

class WebNavigationScreen extends StatefulWidget {
  const WebNavigationScreen({super.key});

  @override
  State<WebNavigationScreen> createState() => _WebNavigationScreenState();
}

class _WebNavigationScreenState extends State<WebNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    Center(child: Text('Streaming', style: TextStyle(fontSize: 24))),
    Center(child: Text('Inventory', style: TextStyle(fontSize: 24))),
    Center(child: Text('Kios', style: TextStyle(fontSize: 24))),
    Center(child: Text('Absen', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.white,
            elevation: 4,
            destinations: const [
              // 1. Menu Home dengan ukuran ikon yang membesar saat dipilih
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined, size: 24),
                selectedIcon: Icon(Icons.home, size: 32), // Membesar saat dipilih
                label: Text('Home'),
              ),
              // 2. Menu Streaming
              NavigationRailDestination(
                icon: Icon(Icons.cast, size: 24),
                selectedIcon: Icon(Icons.cast_connected, size: 32),
                label: Text('Streaming'),
              ),
              // 3. Menu Inventory
              NavigationRailDestination(
                icon: Icon(Icons.point_of_sale, size: 24),
                selectedIcon: Icon(Icons.point_of_sale_outlined, size: 32),
                label: Text('Inventory'),
              ),
              // 4. Menu Kios
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2, size: 24),
                selectedIcon: Icon(Icons.inventory_2_outlined, size: 32),
                label: Text('Kios'),
              ),
              // 5. Menu Absen
              NavigationRailDestination(
                icon: Icon(Icons.fingerprint_outlined, size: 24),
                selectedIcon: Icon(Icons.fingerprint, size: 32),
                label: Text('Absen'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}