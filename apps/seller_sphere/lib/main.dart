import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/home_screen.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:logger/logger.dart';

final logger = Logger();

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder navigation functions using logger
    void navigateToInventory() => logger.i("Navigate to Inventory");
    void navigateToChat(String customerName) => logger.i("Navigate to Chat with $customerName");
    void navigateToTransactions() => logger.i("Navigate to Transactions");
    void navigateToSlides() => logger.i("Navigate to Slides");

    final List<Widget> widgetOptions = <Widget>[
      HomeScreen(
        onNavigateToInventory: navigateToInventory,
        onNavigateToChat: navigateToChat,
        onNavigateToTransactions: navigateToTransactions,
        onNavigateToSlides: navigateToSlides,
      ),
      const Text('Seller Screen'),
      const Text('Approval Screen'),
      const Text('System Screen'),
      const Text('Settings Screen'),
    ];

    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: AppNavigation(
        currentIndex: _selectedIndex,
        onTapped: _onItemTapped,
      ),
    );
  }
}
