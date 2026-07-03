import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'widgets/home_app_bar.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/promo_carousel.dart';
import 'widgets/category_list.dart';
import 'widgets/flash_sale_section.dart';
import '../product_screens/product_recommendation_grid.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    // Data pengguna bisa didapat dari state management yang sesuai untuk shop_sphere
    // Untuk saat ini, kita gunakan data statis.
    const String username = 'Budi';

    // Data dummy untuk kategori. Nantinya ini bisa diambil dari API.
    // Pastikan path asset icon sudah benar.
    final List<CategoryModel> dummyCategories = [
      CategoryModel(id: '1', name: 'Elektronik', iconAsset: 'assets/icons/electronics.png'),
      CategoryModel(id: '2', name: 'Fashion', iconAsset: 'assets/icons/fashion.png'),
      CategoryModel(id: '3', name: 'Rumah', iconAsset: 'assets/icons/home.png'),
      CategoryModel(id: '4', name: 'Kesehatan', iconAsset: 'assets/icons/health.png'),
      CategoryModel(id: '5', name: 'Hobi', iconAsset: 'assets/icons/hobby.png'),
      CategoryModel(id: '6', name: 'Voucher', iconAsset: 'assets/icons/voucher.png'),
    ];

    // Fungsi yang akan dipanggil saat kategori dipilih
    void handleCategorySelection(String categoryId) {
      _logger.i('Category selected: $categoryId');
      // Di sini Anda bisa navigasi ke halaman daftar produk berdasarkan kategori
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HomeAppBar(username: username),
            ),

            // 2. Search Bar
            const SliverToBoxAdapter(
              child: HomeSearchBar(),
            ),

            // 3. Promo Carousel
            const SliverToBoxAdapter(
              child: PromoCarousel(),
            ),

            // Jarak
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // 4. Kategori Produk
            SliverToBoxAdapter(
              child: CategoryList(categories: dummyCategories, 
              onCategorySelected: handleCategorySelection),
            ),

             // Jarak
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // 5. Flash Sale Section
            const SliverToBoxAdapter(
              child: FlashSaleSection(),
            ),

             // Jarak
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // 6. Rekomendasi Produk (Grid)
            const ProductRecommendationGrid(),
          ],
        ),
      ),
    );
  }
}