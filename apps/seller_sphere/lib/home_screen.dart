import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/widgets/home_app_bar.dart';
import 'package:seller_sphere/widgets/home_banner.dart';
import 'package:seller_sphere/widgets/stock_warning.dart';
import 'package:seller_sphere/widgets/sales_target.dart';
import 'package:seller_sphere/widgets/package_status.dart';
import 'package:seller_sphere/widgets/order_statistics.dart';
import 'package:seller_sphere/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              HomeBanner(),
              SizedBox(height: 16),
              StockWarning(),
              SizedBox(height: 16),
              SalesTarget(),
              SizedBox(height: 16),
              PackageStatus(),
              SizedBox(height: 16),
              OrderStatistics(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
