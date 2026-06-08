import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/firestore_service.dart';
import 'mikrotik_service.dart';

class CreateMemberPage extends StatefulWidget {
  const CreateMemberPage({super.key});

  @override
  State<CreateMemberPage> createState() => _CreateMemberPageState();
}

class _CreateMemberPageState extends State<CreateMemberPage> {
  // Mengambil instance service dari GetIt
  final FirestoreService _firestore = GetIt.I<FirestoreService>();
  final MikrotikService _mikrotik = GetIt.I<MikrotikService>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleCreateMember() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan Password wajib diisi!")),
      );
      return;
    }

    try {
      // 1. Logika ke Mikrotik
      await _mikrotik.addMember(username, password);

      // 2. Simpan ke Firestore
      await _firestore.setData(
        collectionPath: 'members',
        documentId: username, // Menggunakan username sebagai ID
        data: {
          'username': username,
          'createdAt': DateTime.now().toIso8601String(),
          'status': 'active',
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Member berhasil dibuat!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Member")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleCreateMember,
              child: const Text("Create Member"),
            ),
          ],
        ),
      ),
    );
  }
}