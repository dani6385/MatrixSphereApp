// lib/navigation/widgets/app_Home_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'items/home_drawer_items.dart'; // Impor data menu yang sudah dipecah

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan rute aktif saat ini
    final String currentRoute = GoRouterState.of(context).uri.toString();

    // Mengambil daftar item menu dari fungsi terpisah
    final menuList = getDrawerItems(context, currentRoute);

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
                  .person_outline, // Kamu bisa mengganti ikon ini sesuai kebutuhan (misal: Icons.account_circle)
              size: 48, // Ukuran ikon
              color: Colors
                  .white, // Warna ikon agar kontras dengan latar belakang biru
            ),
            SizedBox(height: 12), // Jarak antara ikon dan teks
            // 2. Menambahkan Text dengan TextStyle/AppStyle
            Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      // Melakukan mapping data ke SideMenuItem secara dinamis dan bersih
      items: menuList.map((item) {
        return SideMenuItem(
          title: item.title,
          icon: item.icon,
          label: item.label,
          route: '',
          onTap: item.onTap ?? () {},
        );
      }).toList(),
      selectedRoute: '',
      children: null,
    );
  }
}
