import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: kDarkBackground,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tv),
          label: 'Streaming',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Laporan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'Trend',
        ),
      ],
    );
  }
}
