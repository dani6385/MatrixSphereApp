import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class ShopRegistrationScreen extends StatefulWidget {
  const ShopRegistrationScreen({super.key});

  @override
  State<ShopRegistrationScreen> createState() => _ShopRegistrationScreenState();
}

class _ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _authService = AuthService();
  final _rtdbService = FirebaseRtdbService();

  bool _isLoading = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  Future<void> _submitForApproval() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      _showError("Sesi Anda telah berakhir. Silakan login kembali.");
      context.go(AppRoutes.login);
      return;
    }

    final shopName = _shopNameController.text.trim();
    final uid = currentUser.uid;

    // Data yang akan dikirim ke node 'approval'
    final approvalData = {
      'nama': shopName,
      'ownerUid': uid,
      'email': currentUser.email,
      'submittedAt': ServerValue.timestamp,
    };

    // Menggunakan FirebaseRtdbService untuk menulis data
    final success = await _rtdbService.writeData('approval/$uid', approvalData);

    setState(() => _isLoading = false);

    if (success && mounted) {
      showInfoDialog(
        context: context,
        title: 'Pendaftaran Terkirim',
        message:
            'Pendaftaran toko "$shopName" telah berhasil dikirim. Mohon tunggu persetujuan dari admin.',
        buttonText: 'Mengerti',
        onPressed: () {
          // Arahkan ke halaman login atau halaman tunggu
          context.go(AppRoutes.login);
        },
      );
    } else {
      _showError("Gagal mengirim pendaftaran toko. Silakan coba lagi.");
    }
  }

  void _showError(String message) {
    if (mounted) {
      showErrorDialog(context: context, message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftarkan Toko Anda'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Satu Langkah Lagi!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Masukkan nama toko Anda untuk menyelesaikan pendaftaran.'),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _shopNameController,
                  decoration: const InputDecoration(labelText: 'Nama Toko'),
                  validator: (value) => (value == null || value.isEmpty) ? 'Nama toko tidak boleh kosong' : null,
                ),
                const SizedBox(height: 24),
                _isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _submitForApproval, child: const Text('Kirim untuk Persetujuan')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}