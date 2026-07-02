// File: apps/client_connectivity/lib/presentation/login_screen/widgets/member_tab_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_services/services/ip_sync_service.dart';
import 'package:shared_services/services/services_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';

class MemberTabWidget extends ConsumerStatefulWidget {
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
  ConsumerState<MemberTabWidget> createState() => _MemberTabWidgetState();
}

class _MemberTabWidgetState extends ConsumerState<MemberTabWidget> {
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

    try {
      // --- BAGIAN INTEGRASI DENGAN SERVICE ---

      // 1. Simulasi otentikasi pengguna (di dunia nyata, ini akan memvalidasi username/password)
      await Future.delayed(const Duration(milliseconds: 1000));
      final String userId = 'user_123'; // ID pengguna didapat setelah login berhasil

      // 2. Dapatkan service dari provider
      final ipSyncService = ref.read(ipSyncServiceProvider);

      // 3. Siapkan konfigurasi (di dunia nyata, ini didapat dari Firestore/Remote Config)
      final mikrotikConfig = MikroTikRestApiConfig(
        host: '192.168.88.1', // Ganti dengan IP router Anda
        username: 'api-user', // Ganti dengan user REST API Anda
        password: 'api-password',
      );

      // 4. Jalankan sinkronisasi IP
      final response = await ipSyncService.syncIpAddress(
        mikrotikId: 'mikrotik_A_id', // ID router yang sedang digunakan
        userId: userId,
        mikrotikRestApiConfig: mikrotikConfig,
      );

      // 5. Tampilkan feedback berdasarkan hasil sinkronisasi
      if (!mounted) return;
      final snackBar = SnackBar(
        content: Text('Status Sinkronisasi: ${response.status.name}'),
        backgroundColor: (response.status == IpSyncStatus.syncFailed) ? Colors.red : Colors.green,
      );
      ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackBar);

      // 6. Lanjutkan navigasi
      if (widget.isPopupMode) {
        Navigator.of(context).pop(true);
      } else {
        context.go(AppRoutes.homeScreen);
      }
    } catch (e) {
      // Tangani error yang mungkin tidak tertangkap di dalam service
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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