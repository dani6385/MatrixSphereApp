import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_ui/shared_ui.dart';

enum LoginMethod { voucher, member, scanQr, bayarQr, trial }

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static const _userData = _UserData(
    username: 'budi.santoso',
    email: 'budi.santoso@email.com',
    phoneNumber: '+62 812-3456-7890',
    loginMethod: LoginMethod.member,
    createdAt: '27 Juni 2025',
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, colorScheme),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _ProfileAvatarCard(userData: _userData),
                  const SizedBox(height: 20),
                  _SectionLabel(label: 'Informasi Akun'),
                  const SizedBox(height: 10),
                  _InfoCard(
                    items: [
                      _InfoItem(
                        icon: Icons.person_outline_rounded,
                        label: 'Username',
                        value: _userData.username,
                      ),
                      _InfoItem(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: _userData.email,
                      ),
                      _InfoItem(
                        icon: Icons.phone_outlined,
                        label: 'Nomor Telepon',
                        value: _userData.phoneNumber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SectionLabel(label: 'Detail Login'),
                  const SizedBox(height: 10),
                  _InfoCard(
                    items: [
                      _InfoItem(
                        icon: _loginMethodIcon(_userData.loginMethod),
                        label: 'Metode Login',
                        value: _loginMethodLabel(_userData.loginMethod),
                        valueColor: colorScheme.primary,
                        valueBold: true,
                      ),
                      _InfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tanggal Bergabung',
                        value: _userData.createdAt,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _LoginMethodBadge(method: _userData.loginMethod),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, ColorScheme colorScheme) {
    return SliverAppBar(
      pinned: false,
      backgroundColor: colorScheme.primary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 0,
      title: Text(
        'Akun Saya',
        style: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A1A),
        ),
      ),
      centerTitle: false,
    );
  }

  static IconData _loginMethodIcon(LoginMethod method) {
    switch (method) {
      case LoginMethod.voucher:
        return Icons.confirmation_number_outlined;
      case LoginMethod.member:
        return Icons.badge_outlined;
      case LoginMethod.scanQr:
        return Icons.qr_code_scanner_rounded;
      case LoginMethod.bayarQr:
        return Icons.qr_code_2_rounded;
      case LoginMethod.trial:
        return Icons.wifi_tethering_rounded;
    }
  }

  static String _loginMethodLabel(LoginMethod method) {
    switch (method) {
      case LoginMethod.voucher:
        return 'Voucher';
      case LoginMethod.member:
        return 'Member';
      case LoginMethod.scanQr:
        return 'Scan QR';
      case LoginMethod.bayarQr:
        return 'Bayar QR';
      case LoginMethod.trial:
        return 'Trial';
    }
  }
}

// ─── Data model ──────────────────────────────────────────────────────────────

class _UserData {
  final String username;
  final String email;
  final String phoneNumber;
  final LoginMethod loginMethod;
  final String createdAt;

  const _UserData({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.loginMethod,
    required this.createdAt,
  });
}

// ─── Profile avatar card ─────────────────────────────────────────────────────

class _ProfileAvatarCard extends StatelessWidget {
  final _UserData userData;

  const _ProfileAvatarCard({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withAlpha(204),
            const Color(0xFF00695C),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile picture placeholder
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(38),
                  border: Border.all(
                    color: Colors.white.withAlpha(128),
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 52,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 13,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            userData.username,
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userData.email,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withAlpha(204),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withAlpha(77)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _loginMethodIcon(userData.loginMethod),
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  'Login via ${_loginMethodLabel(userData.loginMethod)}',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static IconData _loginMethodIcon(LoginMethod method) {
    switch (method) {
      case LoginMethod.voucher:
        return Icons.confirmation_number_outlined;
      case LoginMethod.member:
        return Icons.badge_outlined;
      case LoginMethod.scanQr:
        return Icons.qr_code_scanner_rounded;
      case LoginMethod.bayarQr:
        return Icons.qr_code_2_rounded;
      case LoginMethod.trial:
        return Icons.wifi_tethering_rounded;
    }
  }

  static String _loginMethodLabel(LoginMethod method) {
    switch (method) {
      case LoginMethod.voucher:
        return 'Voucher';
      case LoginMethod.member:
        return 'Member';
      case LoginMethod.scanQr:
        return 'Scan QR';
      case LoginMethod.bayarQr:
        return 'Bayar QR';
      case LoginMethod.trial:
        return 'Trial';
    }
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF5C5C5C),
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ─── Info card ────────────────────────────────────────────────────────────────

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  });
}

class _InfoCard extends StatelessWidget {
  final List<_InfoItem> items;

  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration( // TODO: Use colorScheme.surface
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration( // TODO: Use colorScheme.primary
                        color: Theme.of(context).colorScheme.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, size: 18, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF9E9E9E),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: item.valueBold
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: item.valueColor ?? const Color(0xFF1A1A1A),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 68,
                  endIndent: 0,
                  color: Color(0xFFF0F0F0),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Login method badge ───────────────────────────────────────────────────────

class _LoginMethodBadge extends StatelessWidget {
  final LoginMethod method;

  const _LoginMethodBadge({required this.method});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor, description) = _methodDetails(method);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_methodIcon(method), size: 22, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipe Akun: ${_methodLabel(method)}',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: color.withAlpha(179),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static (Color, Color, String) _methodDetails(LoginMethod method) {
    switch (method) {
      case LoginMethod.voucher:
        return (
          const Color(0xFF0277BD),
          const Color(0xFFE3F2FD),
          'Akses menggunakan kode voucher hotspot',
        );
      case LoginMethod.member:
        return ( // TODO: Use colorScheme.primary
          const Color(0xFF00695C),
          const Color(0xFFE0F2F1),
          'Akses penuh sebagai anggota terdaftar',
        );
      case LoginMethod.scanQr:
        return (
          const Color(0xFF6A1B9A),
          const Color(0xFFF3E5F5),
          'Login dengan memindai kode QR',
        );
      case LoginMethod.bayarQr:
        return (
          const Color(0xFFE65100),
          const Color(0xFFFFF3E0),
          'Login melalui pembayaran QR',
        );
      case LoginMethod.trial:
        return (
          const Color(0xFF558B2F),
          const Color(0xFFF1F8E9),
          'Akses percobaan gratis berdasarkan MAC address',
        );
    }
  }

  static IconData _methodIcon(LoginMethod method) {
    switch (method) {
      case LoginMethod.voucher:
        return Icons.confirmation_number_outlined;
      case LoginMethod.member:
        return Icons.verified_user_outlined;
      case LoginMethod.scanQr:
        return Icons.qr_code_scanner_rounded;
      case LoginMethod.bayarQr:
        return Icons.qr_code_2_rounded;
      case LoginMethod.trial:
        return Icons.wifi_tethering_rounded;
    }
  }

  static String _methodLabel(LoginMethod method) {
    switch (method) {
      case LoginMethod.voucher:
        return 'Voucher';
      case LoginMethod.member:
        return 'Member';
      case LoginMethod.scanQr:
        return 'Scan QR';
      case LoginMethod.bayarQr:
        return 'Bayar QR';
      case LoginMethod.trial:
        return 'Trial';
    }
  }
}
