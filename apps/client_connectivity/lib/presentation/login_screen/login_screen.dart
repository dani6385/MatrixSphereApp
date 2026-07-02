import 'package:client_connectivity/presentation/login_screen/widgets/scan_qr_tab_widget.dart';
import 'package:client_connectivity/presentation/login_screen/widgets/member_tab_widget.dart';
import 'package:client_connectivity/presentation/login_screen/widgets/bayar_qr_tab_widget.dart';
import 'package:client_connectivity/presentation/login_screen/widgets/voucher_tab_widget.dart';
import 'widgets/trial_tab_widget.dart';
import 'package:shared_ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_tethering_rounded,
                  size: 80,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Selamat Datang',
                  style: GoogleFonts.dmSans(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih metode untuk terhubung ke jaringan internet.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                // Grid of login buttons
                Row(
                  children: [
                    Expanded(
                      child: _LoginMethodButton(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Voucher',
                        onPressed: () => VoucherTabWidget.showAsDialog(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LoginMethodButton(
                        icon: Icons.person_outline,
                        label: 'Member',
                        onPressed: () => MemberTabWidget.showAsDialog(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _LoginMethodButton(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scan QR',
                        onPressed: () => ScanQrTabWidget.showAsDialog(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LoginMethodButton(
                        icon: Icons.qr_code_2_rounded,
                        label: 'Bayar QR',
                        onPressed: () => BayarQrTabWidget.showAsDialog(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginMethodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _LoginMethodButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
