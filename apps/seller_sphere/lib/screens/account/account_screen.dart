import 'package:flutter/material.dart';

// Impor file yang baru dibuat
import 'package:shared_ui/shared_ui.dart';
import 'widgets/info_card.dart';
import 'widgets/account_detail_item.dart';
import 'widgets/account_appbar.dart';
import 'widgets/navigation_row.dart';
import 'widgets/styled_divider.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/update_profile_button.dart';
import 'widgets/security_disclaimer_badge.dart';
import 'widgets/account_drawer.dart';
import 'widgets/account_enddrawer.dart';

class AccountScreen extends StatelessWidget {
  // Data ini idealnya datang dari state management (ViewModel/Provider/Bloc)
  final String ownerName;
  final String ownerEmail;
  final String storeName;
  final String address;
  final String notes;

  // Navigation Callbacks
  final VoidCallback onNavigateBack;
  final VoidCallback onNavigateToEditProfile;
  final VoidCallback onNavigateToTermsConditions;
  final VoidCallback onNavigateToSecurity;
  final VoidCallback onNavigateToPrivacy;
  final VoidCallback onNavigateToNotification;
  final VoidCallback onNavigateToIntellectualProperty;

  const AccountScreen({
    super.key,
    required this.onNavigateBack,
    required this.onNavigateToEditProfile,
    required this.onNavigateToTermsConditions,
    required this.onNavigateToSecurity,
    required this.onNavigateToPrivacy,
    required this.onNavigateToNotification,
    required this.onNavigateToIntellectualProperty,
    // Inisialisasi data dummy jika tidak disediakan
    this.ownerName = '',
    this.ownerEmail = '',
    this.storeName = '',
    this.address = '',
    this.notes = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AccountAppBar(
        onNavigateBack: onNavigateBack,
        onNavigateToEditProfile: onNavigateToEditProfile,
      ),
      drawer: AccountDrawer(
        storeName: storeName,
        ownerEmail: ownerEmail,
        // Anda dapat menghubungkan callback navigasi di sini
        // contoh: onNavigateToHome: () => Navigator.of(context).pushNamed('/home'),
        // onLogout: () { /* Logika logout */ },
      ),
      endDrawer: const AccountEndDrawer(
        // Anda dapat menghubungkan callback aksi di sini
        // contoh: onShareProfile: () { /* Logika bagikan profil */ },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Section 1: Hero Profile Header Card
            ProfileHeaderCard(storeName: storeName),
            const SizedBox(height: 20),

            // Section 2: Account Details Card
            _buildOwnerInfoCard(context),
            const SizedBox(height: 20),

            // Section 3: Operational & Address Card
            _buildLogisticsInfoCard(context),
            const SizedBox(height: 20),

            // Section 4: Legalities
            _buildLegalitiesCard(context),
            const SizedBox(height: 20),

            // Quick Edit Button
            UpdateProfileButton(onPressed: onNavigateToEditProfile),
            const SizedBox(height: 20),

            // Security Disclaimer Badge
            const SecurityDisclaimerBadge(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerInfoCard(BuildContext context) {
    return InfoCard(
      title: "INFORMASI PROFIL PEMILIK",
      titleIcon: Icons.person,
      titleColor: kNeonCyan,
      children: [
        AccountDetailItem(
          label: "Nama Pemilik",
          value: ownerName.isNotEmpty ? ownerName : "Nama Belum Diatur",
          icon: Icons.badge,
        ),
        const StyledDivider(),
        AccountDetailItem(
          label: "Alamat Email",
          value: ownerEmail.isNotEmpty ? ownerEmail : "danixxxx@gmail.com",
          icon: Icons.email,
        ),
        const StyledDivider(),
        AccountDetailItem(
          label: "Nama Bisnis / Toko",
          value: storeName.isNotEmpty ? storeName : "Seller Sphere Store",
          icon: Icons.storefront,
        ),
      ],
    );
  }

  Widget _buildLogisticsInfoCard(BuildContext context) {
    return InfoCard(
      title: "LOKASI & OPERASIONAL TOKO",
      titleIcon: Icons.location_on,
      titleColor: kWarmOrange,
      children: [
        AccountDetailItem(
          label: "Alamat Penjemputan Paket",
          value: address.isNotEmpty
              ? address
              : "Alamat belum diatur. Ketuk tombol pensil di atas untuk mengonfigurasi peta lokasi penjemputan logistik.",
          icon: Icons.home,
        ),
        const StyledDivider(),
        AccountDetailItem(
          label: "Catatan Pengiriman / Petunjuk",
          value: notes.isNotEmpty ? notes : "Tidak ada catatan tambahan.",
          icon: Icons.description,
        ),
      ],
    );
  }

  Widget _buildLegalitiesCard(BuildContext context) {
    return InfoCard(
      title: "LEGALITAS, KEAMANAN & NOTIFIKASI",
      titleIcon: Icons.security,
      titleColor: kSoftTeal,
      childPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children: [
        NavigationRow(
          title: "Syarat & Ketentuan Layanan",
          subtitle: "Aturan dasar operasional, kebijakan, & keamanan",
          icon: Icons.policy,
          iconBackgroundColor: kNeonCyan.withValues(alpha: 0.15),
          iconColor: kNeonCyan,
          onTap: onNavigateToTermsConditions,
        ),
        const SizedBox(height: 8),
        NavigationRow(
          title: "Keamanan Akun & PIN",
          subtitle: "Ubah PIN, biometrik, & pantau riwayat akses",
          icon: Icons.verified_user,
          iconBackgroundColor: kVividOrchid.withValues(alpha: 0.15),
          iconColor: kVividOrchid,
          onTap: onNavigateToSecurity,
        ),
        const SizedBox(height: 8),
        NavigationRow(
          title: "Privasi Akun & Data",
          subtitle: "Kontrol enkripsi, sensor EXIF, & ekspor data",
          icon: Icons.admin_panel_settings,
          iconBackgroundColor: kSoftTeal.withValues(alpha: 0.15),
          iconColor: kSoftTeal,
          onTap: onNavigateToPrivacy,
        ),
        const SizedBox(height: 8),
        NavigationRow(
          title: "Notifikasi & Saluran",
          subtitle: "Atur tujuan & kirim via Email, WhatsApp, & SMS",
          icon: Icons.notifications_active,
          iconBackgroundColor: kNeonCyan.withValues(alpha: 0.15),
          iconColor: kNeonCyan,
          onTap: onNavigateToNotification,
        ),
        const SizedBox(height: 8),
        NavigationRow(
          title: "Hak Kekayaan Intelektual",
          subtitle: "Kelola perlindungan merek, hak cipta, & aduan plagiarisme",
          icon: Icons.copyright,
          iconBackgroundColor: kWarmOrange.withValues(alpha: 0.15),
          iconColor: kWarmOrange,
          onTap: onNavigateToIntellectualProperty,
        ),
      ],
    );
  }
}