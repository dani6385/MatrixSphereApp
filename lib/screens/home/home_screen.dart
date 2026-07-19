import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../account/widgets/account_menu_modal.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';
import 'widgets/featured_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightSurface,
      appBar: const HomeAppBar(),
      endDrawer: const AccountMenuModal(),
      body: const Column(
        children: [
          // 1. Widget Atas: FeaturedCard (mengikuti tinggi asli widgetnya)
          FeaturedCard(),

          SizedBox(height: 12), // Jarak pemisah tengah

          // 2. Widget Bawah: HomeBody (dibungkus Expanded agar sisa layar bisa di-scroll)
          Expanded(
            child: HomeBody(),
          ),
        ],
      ),
    );
  }
}
