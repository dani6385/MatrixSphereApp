import 'package:flutter/material.dart';

/// Model sederhana untuk data karyawan/member
class Member {
  final String id;
  final String name;
  final String role;
  final String email;
  final String? avatarUrl;

  Member({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    this.avatarUrl,
  });
}

/// Halaman untuk menampilkan dan mengelola daftar karyawan/staf.
class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  // Data mock untuk daftar karyawan.
  // Dalam aplikasi nyata, ini akan diambil dari database.
  final List<Member> _members = [
    Member(
      id: '001',
      name: 'Budi Santoso',
      role: 'Manajer Toko',
      email: 'budi.s@example.com',
    ),
    Member(
      id: '002',
      name: 'Citra Lestari',
      role: 'Staf Gudang',
      email: 'citra.l@example.com',
    ),
    Member(
      id: '003',
      name: 'Doni Firmansyah',
      role: 'Kasir',
      email: 'doni.f@example.com',
    ),
    Member(
      id: '004',
      name: 'Eka Putri',
      role: 'Staf Gudang',
      email: 'eka.p@example.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Karyawan'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Karyawan',
            onPressed: () {
              // Logika untuk menambah karyawan baru
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fungsi tambah karyawan belum diimplementasikan.')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                // Menampilkan inisial jika tidak ada avatar
                backgroundImage: member.avatarUrl != null
                    ? NetworkImage(member.avatarUrl!)
                    : null,
                // Menampilkan inisial jika tidak ada avatar
                child: member.avatarUrl == null
                    ? Text(member.name.isNotEmpty ? member.name[0] : '')
                    : null,
              ),
              title: Text(member.name),
              subtitle: Text(member.role),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Logika untuk menampilkan menu (edit, hapus, dll)
                },
              ),
              onTap: () {
                // Logika untuk melihat detail karyawan
              },
            ),
          );
        },
      ),
    );
  }
}