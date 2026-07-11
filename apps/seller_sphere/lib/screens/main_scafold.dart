import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../viewmodels/app_view_model.dart';
import 'dashboard_screen.dart';
import 'streaming_screen.dart';
import 'transactions_screen.dart';
import 'report_screen.dart';
import 'trend_screen.dart';
import 'chat_screen.dart';
import 'inventory_screen.dart';
import 'slides_screen.dart';

import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/common/main_app_bar.dart';

class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold({super.key});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  int _selectedIndex = 0;

  // The list of screens accessible from the bottom navigation bar.
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<AppViewModel>(context, listen: false);

    // Note: The DashboardScreen is initialized with placeholder callbacks here.
    // The actual callbacks with navigation logic are provided in the build method.
    _screens = [
      DashboardScreen(
        onNavigateToLive: () {},
        onNavigateToTransactions: () {},
        onNavigateToChat: (_) {},
        onNavigateToInventory: () {},
        onNavigateToSlides: () {},
      ),
      StreamingScreen(viewModel: viewModel),
      const TransactionsScreen(),
      const ReportScreen(),
      const TrendScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context, listen: false);

    // Replace the placeholder DashboardScreen with one that has navigation logic.
    // This is done here because Navigator needs a BuildContext.
    _screens[0] = DashboardScreen(
      onNavigateToLive: () => _onItemTapped(1),
      onNavigateToTransactions: () => _onItemTapped(2),
      onNavigateToChat: (String customerName) {
        viewModel.activeChatBuyerName = customerName;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      },
      onNavigateToInventory: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InventoryScreen()),
        );
      },
      onNavigateToSlides: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SlidesScreen()),
        );
      },
    );

    return Scaffold(
      appBar: const MainAppBar(),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        // Use a key to ensure the PageTransitionSwitcher updates when the index changes.
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
