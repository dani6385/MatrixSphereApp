import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/firestore_service.dart';

class CreateQrisPage extends StatefulWidget {
  const CreateQrisPage({super.key});

  @override
  State<CreateQrisPage> createState() => _CreateQrisPageState();
}

class _CreateQrisPageState extends State<CreateQrisPage> {
  // Mengambil service yang sudah terdaftar di GetIt
  final FirestoreService _firestore = GetIt.I<FirestoreService>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Future<void> _handleCreateQris() async {
    final name = _nameController.text;
    final amount = _amountController.text;

    if (name.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan Nominal wajib diisi!")),
      );
      return;
    }

    try {
      // Simpan data QRIS ke Firestore
      await _firestore.setData(
        collectionPath: 'qris_payments', // Koleksi khusus QRIS
        documentId: DateTime.now().millisecondsSinceEpoch.toString(), // ID unik
        data: {
          'name': name,
          'amount': amount,
          'status': 'pending',
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("QRIS berhasil dibuat!")),
      );
      
      _nameController.clear();
      _amountController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create QRIS")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Pembayaran")),
            TextField(controller: _amountController, decoration: const InputDecoration(labelText: "Nominal")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleCreateQris,
              child: const Text("Generate QRIS"),
            ),
          ],
        ),
      ),
    );
  }
}