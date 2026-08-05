// lib/navigation/widgets/app_navigator_EndDrawer.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'items/seller_end_drawer_items.dart'; // Impor data menu EndDrawer yang baru dibuat

class SellerEndDrawer extends StatelessWidget {
  const SellerEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil daftar item dari file data terpisah
    final endDrawerList = getEndDrawerItems(context);

    return SideMenu(
      header: const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Mengatur posisi teks & ikon ke sebelah kiri
          mainAxisAlignment: MainAxisAlignment
              .center, // Memposisikan konten agar berada di tengah secara vertikal
          children: [
            // 1. Menambahkan Icon di dalam DrawerHeader
            Icon(
              Icons
                  .payments_outlined, // Kamu bisa mengganti ikon ini sesuai kebutuhan (misal: Icons.account_circle)
              size: 48, // Ukuran ikon
              color: Colors
                  .white, // Warna ikon agar kontras dengan latar belakang biru
            ),
            SizedBox(height: 12), // Jarak antara ikon dan teks
            // 2. Menambahkan Text dengan TextStyle/AppStyle
            Text(
              'Pengaturan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      // Melakukan mapping data item menu secara dinamis
      items: endDrawerList.map((item) {
        return SideMenuItem(
          title: item.title,
          icon: item.icon,
          route: item.route,
          onTap: item.onTap ?? () {},
        );
      }).toList(),
      selectedRoute: '',
      children: null,
    );
  }
}