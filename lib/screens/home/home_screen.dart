import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:provider/provider.dart';
import '../chat/providers/chat_provider.dart';
import '../account/widgets/account_menu_modal.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';
import 'widgets/home_content.dart';
import 'widgets/featured_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) =>
            ChatProvider(), // Menginisialisasi ChatProvider hanya untuk halaman ini
        child: const Scaffold(
          backgroundColor: kLightSurface,
          appBar: const HomeAppBar(),
          drawer: const AccountMenuModal(),
          body: const Column(
            children: [
              // 1. Widget Atas: FeaturedCard (mengikuti tinggi asli widgetnya)
              FeaturedCard(),
              SizedBox(height: 12), // Jarak pemisah tengah
              Expanded(
                child: Column(
                  children: [
                    // 2. Widget Bawah: HomeBody (mengisi sisa ruang yang tersedia)
                    HomeBody(),
                    HomeContent(),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
