import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class RegisterShopScreen extends StatefulWidget {
  const RegisterShopScreen({super.key});

  @override
  State<RegisterShopScreen> createState() => _RegisterShopScreenState();
}

class _RegisterShopScreenState extends State<RegisterShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _rtdbService = FirebaseRtdbService();
  bool _isLoading = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Seharusnya tidak terjadi karena ada redirect, tapi sebagai pengaman
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Pengguna tidak ditemukan.")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final shopName = _shopNameController.text.trim();
    final data = {'nama': shopName, 'status': 'waiting'};

    // Menggunakan UID pengguna sebagai key di node 'approval'
    final success = await _rtdbService.writeData('approval/${user.uid}', data);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Pendaftaran toko berhasil! Mohon tunggu persetujuan admin."),
            backgroundColor: kSoftTeal,
          ),
        );
        // Arahkan ke halaman utama, GoRouter akan menangani sisanya
        // (misal, tetap di halaman ini atau halaman tunggu)
        context.go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mendaftarkan toko. Silakan coba lagi."),
            backgroundColor: kAlertRed,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftarkan Toko Anda'),
        automaticallyImplyLeading: false, // Sembunyikan tombol back
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.store_mall_directory_outlined, size: 80, color: kBrandPrimary),
                const SizedBox(height: 24),
                Text(
                  'Satu Langkah Lagi!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Daftarkan nama toko Anda untuk mulai berjualan.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _shopNameController,
                  decoration: const InputDecoration(labelText: 'Nama Toko'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama toko tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isLoading ? null : _submitRegistration,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Daftarkan Toko'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}