import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart'; // Import service Anda
import 'package:get_it/get_it.dart';

class CreateMemberPage extends StatefulWidget {
  const CreateMemberPage({super.key});

  @override
  State<CreateMemberPage> createState() => _CreateMemberPageState();
}

class _CreateMemberPageState extends State<CreateMemberPage> {
  // Controller untuk input field
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Mengambil service dari locator
  final dynamic _firestoreService = GetIt.I<FirestoreService>();
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  bool _isLoading = false;

  void _submitMember() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // Panggil fungsi simpan dari service
      await _firestoreService.addMember(
        name: _nameController.text,
        phone: _phoneController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Member berhasil ditambahkan!")),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Member Baru")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Member")),
            TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "No HP")),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitMember,
                    child: const Text("Simpan Member")),
          ],
        ),
      ),
    );
  }
}
