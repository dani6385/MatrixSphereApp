import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'states/user_registration_state.dart';
import 'logics/user_registration_logic.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final UserRegistrationLogic _logic = UserRegistrationLogic();
  final UserRegistrationState _state = UserRegistrationState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Mencegah aplikasi langsung tertutup atau keluar
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }
        // Arahkan kembali ke halaman login saat tombol kembali ditekan
        context.go(AppRoutes.login);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrasi Akun Baru'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _state.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Buat akun baru Anda untuk memulai.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _state.nameController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _state.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Masukkan email yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _state.passwordController,
                  decoration: const InputDecoration(labelText: 'Kata Sandi'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _state.confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Konfirmasi Kata Sandi'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi kata sandi tidak boleh kosong';
                    }
                    if (value != _state.passwordController.text) {
                      return 'Kata sandi tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _state.isLoading
                      ? null
                      : () => _logic.registerUser(
                            context: context,
                            state: _state,
                            onUpdate: () => setState(() {
                              _state.isLoading = !_state.isLoading;
                            }),
                          ),
                  child: _state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Daftar'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () async {
                    // 1. Tampilkan indikator splash / loading sederhana di tengah layar
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Pengguna tidak bisa menutup dialog sembarangan
                      builder: (BuildContext context) {
                        return const Center(
                          child:
                              CircularProgressIndicator(), // Bisa diganti dengan widget splash/loading kustom
                        );
                      },
                    );

                    // 2. Berikan jeda waktu sebentar (misalnya 1 detik) untuk efek transisi splash
                    await Future.delayed(const Duration(seconds: 1));

                    // 3. Pastikan widget masih aktif sebelum melakukan navigasi
                    if (!context.mounted) return;

                    // 4. Tutup dialog loading
                    context.pop();

                    // 5. Kirim pengguna secara otomatis ke halaman login
                    context.go(AppRoutes.login);
                  },
                  child: const Text('Sudah punya akun? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
