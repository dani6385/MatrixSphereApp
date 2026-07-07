import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_view_model.dart';
import 'home_screen.dart';

enum MainTab { home, seller, approval, system, settings }

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  MainTab _selectedTab = MainTab.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GUARDIAN CONSOLE", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Badge(label: Text("3"), child: Icon(Icons.notifications)),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildCurrentScreen(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedTab) {
      case MainTab.home:
        return const HomeScreen();
      default:
        return Center(child: Text("Screen ${_selectedTab.name}"));
    }
  }

  Widget _buildBottomNav() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 8, 24, 20),
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF008577),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: MainTab.values.map((tab) {
            final isSelected = _selectedTab == tab;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForTab(tab),
                  color: Colors.white.withOpacity(isSelected ? 1.0 : 0.6),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getIconForTab(MainTab tab) {
    switch (tab) {
      case MainTab.home: return Icons.home;
      case MainTab.seller: return Icons.storefront;
      case MainTab.approval: return Icons.fact_check;
      case MainTab.system: return Icons.lock;
      case MainTab.settings: return Icons.settings;
    }
  }
}