import 'package:flutter/material.dart';
import 'package:shared_ui/widgets/app_scaffold.dart';
import 'screens/home_screen.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// Placeholder screens for other tabs
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class SellerSphereScaffold extends StatelessWidget {
  const SellerSphereScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    // The AppScaffold will manage the page switching via the bottom navigation bar.
    return AppScaffold(
      screens: [
        HomeScreen(
          onNavigateToInventory: () {
            // In a real app, this would be handled by the AppScaffold's PageController
            // to switch to the Inventory tab.
            logger.i("Navigate to Inventory Tab");
          },
          onNavigateToTransactions: () {
            // Same as above, for the Transactions tab.
            logger.i("Navigate to Transactions Tab");
          },
          onNavigateToChat: (String customerName) {
            // This would likely trigger a navigation to a new page on top of the current one.
            logger.i("Navigate to Chat with $customerName");
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Navigate to Chat with $customerName")),
            );
          },
          onNavigateToSlides: () {
             logger.i("Navigate to Slides");
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Navigate to Slides/Hero Banner Details")),
            );
          },
        ),
        const PlaceholderScreen(title: 'Inventory'),
        const PlaceholderScreen(title: 'Transactions/POS'),
        const PlaceholderScreen(title: 'Settings'),
      ],
      bottomNavBarItems: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.point_of_sale),
          label: 'POS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
