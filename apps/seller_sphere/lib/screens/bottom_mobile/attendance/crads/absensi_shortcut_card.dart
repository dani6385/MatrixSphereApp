// lib/screens/home/widgets/absensi_shortcut_card.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/routes/app_routes.dart'; // Impor rute Anda

class AbsensiShortcutCard extends StatelessWidget {
  const AbsensiShortcutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        
        // Ikon Bulat Sidik Jari (Khas Absensi)
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: kBrandPrimary.withValues(alpha: 0.15),
          child: const Icon(Icons.fingerprint, color: kBrandPrimary, size: 28),
        ),
        
        // Judul Utama
        title: const Text(
          'Presensi Kehadiran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: kDarkTextPrimary,
          ),
        ),
        
        // Sub-judul / Deskripsi Pendek
        subtitle: const Text(
          'Ketuk untuk langsung mengambil foto selfie absen hari ini.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        
        // Panah di Sebelah Kanan
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        
        // AKSI KLIK: Langsung mengarah ke kamera absen via GoRouter
        onTap: () {
          GoRouter.of(context).push(AppRoutes.camera); 
        },
      ),
    );
  }
}