import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';
import '../screens/seller/seller_screen.dart';
import '../screens/home/home_content.dart';
import '../screens/approval/approval_screen.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomBottomNavigationBar(
      initialSelectedIndex: 0,
      screens: [
        HomeContent(),
        SellerScreen(),
        ApprovalScreen(),
        Center(child: Text('System Screen', style: TextStyle(color: Colors.white))),
        Center(child: Text('Settings Screen', style: TextStyle(color: Colors.white))),
      ],
      tabs: [
        GButton(icon: Icons.home, text: 'Home'),
        GButton(icon: Icons.business, text: 'Seller'),
        GButton(icon: Icons.check_circle_outline, text: 'Approval'),
        GButton(icon: Icons.system_update, text: 'System'),
        GButton(icon: Icons.settings, text: 'Settings'),
      ],
    );
  }
}
