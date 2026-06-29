import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_ui/shared_ui.dart';
import 'widgets/bayar_qr_widget.dart';
import 'widgets/member_widget.dart';
import 'widgets/scan_qr_widget.dart';
import 'widgets/trial_widget.dart';
import 'widgets/voucher_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final int _selected = 0;

  final List<_LoginMethod> _methods = const [
    _LoginMethod(label: 'Voucher', icon: Icons.confirmation_number_outlined, widget: VoucherWidget()),
    _LoginMethod(label: 'Member', icon: Icons.person_outline_rounded, widget: MemberWidget()),
    _LoginMethod(label: 'Scan QR', icon: Icons.qr_code_scanner_rounded, widget: ScanQrWidget()),
    _LoginMethod(label: 'Bayar QR', icon: Icons.qr_code_2_rounded, widget: BayarQrWidget()),
    _LoginMethod(label: 'Trial', icon: Icons.timer_outlined, widget: TrialWidget()),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: isTablet ? _buildTabletLayout(theme) : _buildPhoneLayout(theme),
      ),
    );
  }

  Widget _buildPhoneLayout(ThemeData theme) {
    return Column(
      children: [
        _buildHeader(theme),
        Expanded(child: _buildLoginCard(theme)),
      ],
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Center(
      child: SizedBox(
        width: 480,
        child: Column(
          children: [
            _buildHeader(theme),
            Expanded(child: _buildLoginCard(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withAlpha(77),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.wifi_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'MikroLogin',
            style: GoogleFonts.dmSans(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pilih metode login untuk melanjutkan',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildMethods(theme),
          // Karena semua metode login sekarang menggunakan popup,
          // area di bawahnya tidak lagi diperlukan untuk menampilkan widget.
          // Kita bisa memberikan sedikit ruang kosong.
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildMethods(ThemeData theme) {
    // Mengubah dari SingleChildScrollView horizontal menjadi Grid
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _methods.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.5, // Menyesuaikan rasio agar tidak terlalu tinggi
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, i) {
          final isSelected = _selected == i;
          return InkWell(
            onTap: () {
              // Menampilkan popup untuk setiap metode login
              if (i == 0) {
                _showVoucherPopup();
              } else if (i == 1) {
                _showMemberPopup();
              } else if (i == 2) {
                _showScanQrPopup();
              } else if (i == 3) {
                _showBayarQrPopup();
              } else if (i == 4) {
                _showTrialPopup();
              }
            },
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                // Karena semua tombol membuka popup, tidak ada yang akan berada
                // dalam status 'selected' di UI utama.
                color: (isSelected && ![0, 1, 2, 3, 4].contains(i))
                    ? AppTheme.primary
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _methods[i].icon,
                    size: 16,
                    color: (isSelected && ![0, 1, 2, 3, 4].contains(i))
                        ? Colors.white
                        : const Color(0xFF757575),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _methods[i].label,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: (isSelected && ![0, 1, 2, 3, 4].contains(i)) ? Colors.white : const Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Menampilkan dialog popup yang berisi VoucherWidget.
  void _showVoucherPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          // Membatasi tinggi dialog agar tidak terlalu besar di layar kecil.
          child: const SizedBox(
            height: 320,
            child: VoucherWidget(),
          ),
        );
      },
    );
  }

  /// Menampilkan dialog popup yang berisi MemberWidget.
  void _showMemberPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: const SizedBox(
            height: 320,
            child: MemberWidget(),
          ),
        );
      },
    );
  }

  /// Menampilkan dialog popup yang berisi ScanQrWidget.
  void _showScanQrPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: const SizedBox(
            // Sesuaikan tinggi agar pas dengan konten ScanQrWidget
            height: 480,
            child: ScanQrWidget(),
          ),
        );
      },
    );
  }

  /// Menampilkan dialog popup yang berisi BayarQrWidget.
  void _showBayarQrPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: const SizedBox(
            // Sesuaikan tinggi agar pas dengan konten BayarQrWidget
            height: 480,
            child: BayarQrWidget(),
          ),
        );
      },
    );
  }

  /// Menampilkan dialog popup yang berisi TrialWidget.
  void _showTrialPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: const SizedBox(
            // TrialWidget memiliki konten yang cukup panjang
            height: 520,
            child: TrialWidget(),
          ),
        );
      },
    );
  }
}

class _LoginMethod {
  final String label;
  final IconData icon;
  final Widget? widget;
  const _LoginMethod({required this.label, required this.icon, this.widget});
}
