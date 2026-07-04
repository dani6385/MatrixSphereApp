// File: apps/client_connectivity/lib/presentation/login_screen/widgets/trial_tab_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/auth_provider.dart';
import '../../../routes/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';

class TrialTabWidget extends ConsumerWidget {
  /// Jika true, widget ditampilkan di dalam dialog.
  /// Ini akan menutup dialog saat berhasil, bukan menavigasi.
  final bool isPopupMode;

  const TrialTabWidget({super.key, this.isPopupMode = false});

  /// Menampilkan widget ini sebagai dialog popup.
  static Future<void> showAsDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => const AlertDialog(
        title: Text('Coba Gratis'),
        content: TrialTabWidget(isPopupMode: true),
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
            content: Text('Sesi coba gratis dimulai! Anda sekarang terhubung.'),
            backgroundColor: Colors.green,
          ),
        );
      // Arahkan ke home
      context.go(AppRoutes.homeScreen);
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.loginProcessState is AuthLoading;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      final processState = next.loginProcessState;
      if (processState is AuthSuccess) {
        if (isPopupMode) {
          // Dalam mode popup, tutup dialog dan berikan flag sukses.
          Navigator.of(context).pop(true);
        } else {
          // Perilaku asli: navigasi ke layar beranda.
          context.go(AppRoutes.homeScreen);
        }
      } else if (processState is AuthError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(processState.message)));
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer_outlined,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Coba Gratis',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Anda akan mendapatkan akses internet gratis selama 15 menit. Sesi ini hanya dapat digunakan satu kali per perangkat.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: isLoading
                  ? null
                  : () => ref.read(authNotifierProvider.notifier).startTrial(),
              icon: isLoading
                  ? const SizedBox.shrink()
                  : const Icon(Icons.play_circle_outline_rounded),
              label: Text(
                isLoading ? 'Mengaktifkan...' : 'Mulai Coba Gratis',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
