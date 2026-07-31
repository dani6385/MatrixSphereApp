import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// AppBar kustom untuk ProductScreen yang menyertakan TabBar dan actions.
class ProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final VoidCallback onScanBarcode;
  final VoidCallback onAddProduct;
  final int currentTabIndex;

  const ProductAppBar({
    super.key,
    required this.tabController,
    required this.onScanBarcode,
    required this.onAddProduct,
    required this.currentTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Manajemen Toko',
        style: TextStyle(
          color: kDarkTextPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: kDarkAppBar,
      elevation: 1,
      iconTheme: const IconThemeData(color: kDarkBorder),
      actions: [
        // Tombol Scan Barcode, selalu terlihat
        IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: onScanBarcode,
          tooltip: 'Scan Barcode',
        ),
        // Hanya tampilkan tombol 'Tambah' manual di tab Inventaris
        if (currentTabIndex == 0)
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onAddProduct,
            tooltip: 'Tambah Produk Manual',
          ),
      ],
      bottom: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: 'Inventaris', icon: Icon(Icons.inventory)),
          Tab(text: 'Penjualan', icon: Icon(Icons.point_of_sale)),
        ],
        labelColor: kBrandPrimary,
        unselectedLabelColor: Colors.grey,
        indicatorColor: kBrandPrimary,
        indicatorWeight: 3.0,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  @override
  Size get preferredSize =>
      // Tinggi AppBar standar ditambah tinggi TabBar
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}