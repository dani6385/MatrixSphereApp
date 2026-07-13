import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart' hide ProductCard;

import '../data/mock_products.dart';
import '../widgets/product_card.dart';

// Halaman utama untuk fitur Point of Sale
class POSScreen extends StatelessWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kDarkBackground,
        appBar: const POSAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const POSTabBar(),
              const SizedBox(height: 16),
              const SearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75, // Sesuaikan ini agar pas dengan konten
                  ),
                  itemCount: mockProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: mockProducts[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Cari barang untuk dijual...',
        hintStyle: const TextStyle(color: kLightBackground),
        prefixIcon: const Icon(Icons.search, color: kLightBorder),
        suffixIcon: const Icon(Icons.qr_code_scanner, color: kNeonBlue),
        filled: true,
        fillColor: kDarkBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class POSTabBar extends StatelessWidget {
  const POSTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: kDarkBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: kNeonBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: kLightBackground,
        tabs: const [
          Tab(text: 'Kasir POS'),
          Tab(text: 'Orderan Masuk (3)'),
        ],
      ),
    );
  }
}

class POSAppBar extends StatelessWidget implements PreferredSizeWidget {
  const POSAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kDarkBackground,
      elevation: 0,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          // TODO: Ganti dengan gambar pengguna asli
          backgroundColor: kNeonBlue,
        ),
      ),
      title: const Text(
        'Seller Sphere',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: kWarmOrange),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.flag_outlined, color: kRadiantRose),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: kNeonBlue),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
