// File: apps/client_connectivity/lib/presentation/login_screen/widgets/member_tab_widget.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';

class MemberTabWidget extends StatefulWidget {
  /// Jika true, widget ditampilkan di dalam dialog.
  /// Ini akan menutup dialog saat berhasil, bukan menavigasi.
  final bool isPopupMode;

  const MemberTabWidget({super.key, this.isPopupMode = false});

  /// Menampilkan widget ini sebagai dialog popup.
  static Future<void> showAsDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => const AlertDialog(
        title: Text('Login Member'),
        content: MemberTabWidget(isPopupMode: true),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );

    if (result == true && context.mounted) {
      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Login berhasil! Anda sekarang terhubung.'),
            backgroundColor: Colors.green,
          ),
        );
      // Arahkan ke home
      context.go(AppRoutes.homeScreen);
    }
  }

  @override
  State<MemberTabWidget> createState() => _MemberTabWidgetState();
}

class _MemberTabWidgetState extends State<MemberTabWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Simulasi panggilan jaringan untuk otentikasi
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      // Di aplikasi nyata, Anda akan memvalidasi kredensial di sini.
      // Untuk demo, kita anggap selalu berhasil.

      if (widget.isPopupMode) {
        // Dalam mode popup, tutup dialog dan berikan flag sukses.
        Navigator.of(context).pop(true);
      } else {
        // Perilaku asli: navigasi ke layar beranda.
        context.go(AppRoutes.homeScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Username Field
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Username tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 16),
            // Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (v) => (v == null || v.isEmpty)
                  ? 'Password tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 24),
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _isLoading ? null : _login,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Login Member',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}