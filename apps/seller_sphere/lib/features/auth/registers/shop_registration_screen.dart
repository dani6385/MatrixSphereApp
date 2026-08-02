
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:seller_sphere/navigation/app_extractor.dart';
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


  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  Future<void> _submitForApproval() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }


    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      _showError("Sesi Anda telah berakhir. Silakan login kembali.");
      LoginScreen;
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


    if (success && mounted) {
      showInfoDialog(
        context: context,
        title: 'Pendaftaran Terkirim',
        message:
            'Pendaftaran toko "$shopName" telah berhasil dikirim. Mohon tunggu persetujuan dari admin.',
        buttonText: 'Mengerti',
        onPressed: () {
          // Arahkan ke halaman login atau halaman tunggu
          LoginScreen;
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
      appBar: AppBar(title: const Text('Registrasi Toko')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Daftarkan toko Anda untuk menunggu persetujuan admin.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _shopNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Toko',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama toko wajib diisi.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForApproval,
                  child: const Text('Ajukan Pendaftaran'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget yang menampilkan pesan "Menunggu Persetujuan"
class WaitingForApprovalScreen extends StatelessWidget {
  const WaitingForApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Status Pendaftaran")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_top_rounded, size: 60, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                'Menunggu Persetujuan',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Pendaftaran toko Anda sedang kami tinjau. Anda akan dapat mengakses dashboard setelah disetujui oleh admin.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await AuthService().logout();
                  if (context.mounted) {
                    LoginScreen;
                  }
                },
                child: const Text('Logout'),
              )
            ],
          ),
        ),
      ),
    );
  }
}