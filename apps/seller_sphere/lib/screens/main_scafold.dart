import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../viewmodels/app_view_model.dart';
import 'dashboard_screen.dart';
import 'inventory_screen.dart';
import 'transactions_screen.dart';
import 'chat_screen.dart';
import 'slides_screen.dart';
import 'streaming_screen.dart';
import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/common/main_app_bar.dart';

class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold({super.key});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<AppViewModel>(context, listen: false);
    _screens = [
      DashboardScreen(
        onNavigateToInventory: () => _onItemTapped(1),
        onNavigateToTransactions: () => _onItemTapped(2),
        onNavigateToChat: (String customerName) {
          viewModel.activeChatBuyerName = customerName;
          _onItemTapped(3);
        },
        onNavigateToSlides: () => _onItemTapped(4),
        onNavigateToLive: () => _onItemTapped(5),
      ),
      const InventoryScreen(),
      const TransactionsScreen(),
      const ChatScreen(),
      const SlidesScreen(),
      StreamingScreen(viewModel: viewModel),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
