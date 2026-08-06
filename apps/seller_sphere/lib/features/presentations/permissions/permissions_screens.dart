import 'package:flutter/material.dart';

// Model sederhana untuk merepresentasikan sebuah peran (Role)
class Role {
  final String name;
  final String description;
  final List<String> permissions;

  Role({
    required this.name,
    required this.description,
    required this.permissions,
  });
}

/// Halaman untuk mengelola peran (Roles) dan hak akses (Permissions).
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  // Data mock untuk daftar peran. Dalam aplikasi nyata, ini akan berasal dari database.
  final List<Role> _roles = [
    Role(
      name: 'Administrator',
      description: 'Akses penuh ke semua fitur.',
      permissions: [
        'Kelola Pengguna',
        'Kelola Produk',
        'Lihat Laporan',
        'Ubah Pengaturan'
      ],
    ),
    Role(
      name: 'Manajer Toko',
      description: 'Mengelola operasional harian toko.',
      permissions: ['Kelola Produk', 'Kelola Pesanan', 'Lihat Laporan'],
    ),
    Role(
      name: 'Staf Gudang',
      description: 'Bertanggung jawab atas stok dan inventaris.',
      permissions: ['Kelola Inventaris', 'Lihat Produk'],
    ),
    Role(
      name: 'Kasir',
      description: 'Hanya akses untuk memproses pesanan.',
      permissions: ['Kelola Pesanan'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles & Permissions'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Peran Baru',
            onPressed: () {
              // Logika untuk menambah peran baru akan ditambahkan di sini
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fungsi tambah peran belum diimplementasikan.')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          final role = _roles[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: ExpansionTile(
              title: Text(role.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
              subtitle: Text(role.description),
              children: role.permissions.map((permission) {
                return CheckboxListTile(
                  title: Text(permission),
                  value: true, // Dalam aplikasi nyata, ini akan menjadi state
                  onChanged: (bool? value) {
                    // Logika untuk mengubah hak akses
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}