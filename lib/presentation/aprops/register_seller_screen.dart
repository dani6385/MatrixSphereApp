import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/services/firestore_service.dart';
import 'package:shared_ui/shared_ui.dart';

// Provider untuk FirestoreService. Sebaiknya ini diletakkan di file provider terpusat.
final firestoreServiceProvider = Provider((ref) => FirestoreService());

/// Halaman formulir untuk mendaftarkan toko baru sebagai mitra Seller Sphere.
class RegisterSellerScreen extends ConsumerStatefulWidget {
  const RegisterSellerScreen({super.key});

  @override
  ConsumerState<RegisterSellerScreen> createState() =>
      _RegisterSellerScreenState();
}

class _RegisterSellerScreenState extends ConsumerState<RegisterSellerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _storeNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final registrationData = {
          'partnerName': _storeNameController.text,
          'ownerName': _ownerNameController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          // 'email' bisa didapat dari user yang sedang login, jika ada.
        };

        // Panggil service untuk menyimpan data ke Firestore
        await ref
            .read(firestoreServiceProvider)
            .addSellerRegistration(registrationData);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran berhasil dikirim!'),
            backgroundColor: Colors.green,
          ),
        );

        // Kembali ke halaman sebelumnya setelah sukses
        context.pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim pendaftaran: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        // Pastikan untuk menghentikan loading indicator meskipun terjadi error
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pendaftaran Mitra'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Lengkapi data usaha Anda untuk bergabung menjadi mitra kami.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xlg),
              TextFormField(
                controller: _storeNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Toko/Warung',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.storefront),
                ),
                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Nama toko tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md + AppSpacing.xxs), // 20
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemilik',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Nama pemilik tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md + AppSpacing.xxs), // 20
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon Aktif',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Nomor telepon tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md + AppSpacing.xxs), // 20
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap Toko',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 3,
                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Alamat tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: AppSpacing.xxlg),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                // Gaya padding sudah diatur di tema global
                child: _isLoading
                    ? const SizedBox(
                        width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white,))
                    : const Text('Kirim Pendaftaran'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}