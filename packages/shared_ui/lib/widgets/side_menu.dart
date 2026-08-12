import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Model data untuk setiap item yang akan ditampilkan di dalam [SideMenu].
/// Ini membuat menu menjadi dinamis dan dapat dikonfigurasi dari luar.
class SideMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const SideMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
    required String route, required String label,
  });
}

/// Widget laci navigasi (drawer) yang dapat digunakan kembali di berbagai layar.
///
/// Widget ini bersifat generik dan menerima daftar [items] dan sebuah [header]
/// untuk ditampilkan, sehingga bisa dikonfigurasi oleh setiap aplikasi.
class SideMenu extends StatelessWidget {
  final Widget header;
  final List<SideMenuItem> items;
  final Widget? footer;
  final void Function(SideMenuItem item)? onItemSelected;

  const SideMenu({
    super.key,
    required this.header,
    required this.items,
    this.footer,
    this.onItemSelected, required String selectedRoute, required children,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan SizedBox untuk memastikan lebar drawer konsisten
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        backgroundColor: kDarkSurface, // Warna latar yang lebih sesuai
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            header,
            ..._buildMenuItems(),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }

  /// Membangun daftar widget ListTile dari data [items].
  List<Widget> _buildMenuItems() {
    return items.map((item) {
      return ListTile(
        leading: Icon(
          item.icon,
          color: item.isSelected ? kBrandPrimary : kDarkTextSecondary,
        ),
        title: Text(
          item.title,
          style: TextStyle(
              color: item.isSelected ? kBrandPrimary : kDarkTextPrimary),
        ),
        selected: item.isSelected,
        selectedTileColor: kBrandPrimary.withOpacity(0.1),
        onTap: () {
          item.onTap();
          onItemSelected?.call(item);
        },
      );
    }).toList();
  }
}
