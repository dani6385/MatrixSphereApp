import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Kartu header profil yang menampilkan avatar, nama toko, dan lencana.
class ProfileHeaderCard extends StatelessWidget {
  final String storeName;
  final String avatarAssetPath;

  const ProfileHeaderCard({
    super.key,
    required this.storeName,
    this.avatarAssetPath = 'assets/images/img_profile_avatar.png',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            colorScheme.surfaceContainerHighest,
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kNeonCyan, width: 3),
              color: colorScheme.surface,
            ),
            child: ClipOval(
              child: Image.asset(
                avatarAssetPath, // Menggunakan path dari parameter
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 60),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            storeName.isNotEmpty ? storeName : "Toko Seller Sphere",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, color: kSoftTeal, size: 16),
              SizedBox(width: 4),
              Text(
                "Mitra Penjual Resmi",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kSoftTeal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}