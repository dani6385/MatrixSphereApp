import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/navigation/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna background dari tema untuk konsistensi
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        // AppBar dibuat transparan dengan elevation 0 agar menyatu
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Dasbor Penjual',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Tombol notifikasi dan profil di pojok kanan atas
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 28),
            // PERBAIKAN: Navigasi ke halaman notifikasi saat tombol ditekan.
            onPressed: () => context.push(AppRoutes.notifications),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0, left: 8.0),
            child: CircleAvatar(
              backgroundColor: kBrandPrimary,
              child: Text(
                'A',
                style: TextStyle(color: kDarkTextPrimary),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          // 1. Welcome Header
          _WelcomeHeader(sellerName: 'Andi'),
          SizedBox(height: 24),

          // 2. Summary Cards Section
          _SummarySection(),
          SizedBox(height: 24),

          // 3. Quick Actions Section
          _SectionHeader(title: 'Aksi Cepat'),
          SizedBox(height: 16),
          _QuickActionsGrid(),
          SizedBox(height: 24),

          // 4. Recent Activity Section
          _SectionHeader(title: 'Aktivitas Terbaru'),
          SizedBox(height: 16),
          _RecentActivityList(),
        ],
      ),
    );
  }
}

// Widget untuk header "Selamat Datang"
class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.sellerName});
  final String sellerName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang Kembali,',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: kDarkTextSecondary),
        ),
        Text(
          sellerName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Widget untuk menampilkan ringkasan data (Pendapatan, Pesanan, dll)
class _SummarySection extends StatelessWidget {
  const _SummarySection();

  @override
  Widget build(BuildContext context) {
    // Menggunakan GridView agar responsif di berbagai ukuran layar
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5, // Mengatur rasio kartu
      children: const [
        SummaryCard(
          icon: Icons.monetization_on_outlined,
          value: 'Rp 1.2Jt',
          label: 'Pendapatan Hari Ini',
          iconColor: AppColors.success,
        ),
        SummaryCard(
          icon: Icons.shopping_cart_outlined,
          value: '12',
          label: 'Pesanan Baru',
          iconColor: AppColors.info,
        ),
      ],
    );
  }
}

// Widget untuk menampilkan tombol-tombol aksi cepat
class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        QuickActionChip(icon: Icons.add_box_outlined, label: 'Produk'),
        QuickActionChip(icon: Icons.qr_code_scanner, label: 'Scan'),
        QuickActionChip(icon: Icons.bar_chart_outlined, label: 'Laporan'),
        QuickActionChip(icon: Icons.chat_bubble_outline, label: 'Chat'),
      ],
    );
  }
}

// Widget untuk menampilkan daftar aktivitas terbaru
class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList();

  @override 
  Widget build(BuildContext context) {
    // Menggunakan Card agar aktivitas terlihat terpisah dari background
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          const ActivityListTile(
            icon: Icons.receipt_long_outlined,
            title: 'Pesanan baru #INV-12345',
            subtitle: 'dari Budi',
            color: AppColors.accent,
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          const ActivityListTile(
            icon: Icons.warning_amber_rounded,
            title: 'Stok menipis',
            subtitle: 'Kemeja Lengan Panjang (Sisa 2)',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}

// Widget header untuk setiap seksi (misal: "Aksi Cepat")
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override 
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: kDarkTextSecondary,
          ),
    );
  }
}
// Widget untuk menampilkan promosi atau tips
// ignore: unused_element
class _PromotionsSection extends StatelessWidget {
  const _PromotionsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.campaign_outlined, color: AppColors.accent, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Promo Spesial!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dapatkan diskon 10% untuk semua produk bulan ini.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kDarkTextSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: kDarkTextSecondary),
          ],
        ),
      ),
    );
  }
}
