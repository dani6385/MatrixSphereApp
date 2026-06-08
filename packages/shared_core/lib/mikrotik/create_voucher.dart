import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/firestore_service.dart';
import 'mikrotik_service.dart';

class CreateVoucherPage extends StatefulWidget {
  const CreateVoucherPage({super.key});

  @override
  State<CreateVoucherPage> createState() => _CreateVoucherPageState();
}

class _CreateVoucherPageState extends State<CreateVoucherPage> {
  final FirestoreService _firestore = GetIt.I<FirestoreService>();
  final MikrotikService _mikrotik = GetIt.I<MikrotikService>();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();

  Future<void> _handleCreateVoucher() async {
    final code = _codeController.text;
    final limit = _limitController.text;

    if (code.isEmpty || limit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode dan Limit wajib diisi!")),
      );
      return;
    }

    try {
      // 1. Kirim perintah ke Mikrotik untuk membuat Voucher/User hotspot
      // Asumsi: MikrotikService memiliki method addVoucher
      await _mikrotik.addVoucher(code, limit);

      // 2. Simpan record voucher ke Firestore untuk monitoring
      await _firestore.setData(
        collectionPath: 'vouchers',
        documentId: code,
        data: {
          'code': code,
          'limit': limit,
          'status': 'available',
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Voucher berhasil dibuat!")),
      );
      
      _codeController.clear();
      _limitController.clear();
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
      appBar: AppBar(title: const Text("Create Voucher")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _codeController, decoration: const InputDecoration(labelText: "Kode Voucher")),
            TextField(controller: _limitController, decoration: const InputDecoration(labelText: "Limit (Jam/Kuota)")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleCreateVoucher,
              child: const Text("Generate Voucher"),
            ),
          ],
        ),
      ),
    );
  }
}