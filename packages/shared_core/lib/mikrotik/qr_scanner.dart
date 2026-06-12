import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class QrisScan extends StatefulWidget {
  const QrisScan({super.key});

  @override
  State<QrisScan> createState() => _QrisScanState();
}

class _QrisScanState extends State<QrisScan> {
  final ImagePicker _picker = ImagePicker();
  final Logger _logger = Logger();
  
  // Variabel yang tadi error sekarang dideklarasikan
  File? _selectedImage; 
  final FirestoreService _firestore = GetIt.I<FirestoreService>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _logger.i("Gambar dipilih: ${pickedFile.path}");
    }
  }

  Future<void> _handleCreateQris() async {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data wajib diisi!")));
      return;
    }

    try {
      await _firestore.setData(
        collectionPath: 'qris_payments',
        documentId: DateTime.now().millisecondsSinceEpoch.toString(),
        data: {
          'name': _nameController.text,
          'amount': _amountController.text,
          'status': 'pending',
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("QRIS berhasil dibuat!")));
    } catch (e) {
      _logger.e("Error QRIS: $e");
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
            if (_selectedImage != null) Image.file(_selectedImage!, height: 100),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Pembayaran")),
            TextField(controller: _amountController, decoration: const InputDecoration(labelText: "Nominal")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => _pickImage(ImageSource.gallery), child: const Text("Pilih QR")),
            ElevatedButton(onPressed: _handleCreateQris, child: const Text("Generate QRIS")),
          ],
        ),
      ),
    );
  }
}