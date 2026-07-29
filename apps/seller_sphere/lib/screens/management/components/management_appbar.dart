// lib/screens/widgets/management_app_bar.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManagementAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ManagementAppBar({super.key});

  @override
  State<ManagementAppBar> createState() => _ManagementAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ManagementAppBarState extends State<ManagementAppBar> {
  // Nilai awal yang terpilih di dropdown
  String _selectedMenu = 'Produk';

  // Daftar opsi menu yang diminta
  final List<String> _menuOptions = ['Produk', 'Proses', 'Chart'];

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      // Tombol untuk navigasi ke chat di sisi kiri
      leading: IconButton(
        icon: const Icon(Icons.chat),
        tooltip: 'Chat',
        onPressed: () {
          context.go('/chat');
        },
      ),
      // Menempatkan Dropdown di bagian Title AppBar
      title: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMenu,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          items: _menuOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedMenu = newValue;
              });

              // Kamu bisa menambahkan logika navigasi atau aksi di sini
              // Contoh: 
              // if (newValue == 'Produk') context.go('/inventory');
              // if (newValue == 'Proses') context.go('/process');
              // if (newValue == 'Chart') context.go('/chart');
            }
          },
        ),
      ),
      // Tombol untuk membuka laci kanan (endDrawer)
      actions: [
        IconButton(
          icon: const Icon(Icons.tune_rounded),
          tooltip: 'Buka Filter atau Pengaturan',
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }
}