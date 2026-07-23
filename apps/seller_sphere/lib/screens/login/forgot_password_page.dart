import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendResetLink() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // --- SIMULASI PENGIRIMAN LINK RESET ---
      // Di aplikasi nyata, Anda akan memanggil API untuk mengirim email.
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Tampilkan pesan umum untuk keamanan (tidak memberitahu apakah email ada atau tidak)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jika email terdaftar, link reset akan dikirim.'),
          backgroundColor: Colors.blue,
        ),
      );

      // Kembali ke halaman login
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Lupa Password Anda?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan email Anda di bawah untuk menerima instruksi reset password.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _sendResetLink,
                      child: const Text('Kirim Link Reset'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}