import 'package:flutter/material.dart';

/// Tombol aksi utama untuk memperbarui profil di layar akun.
class UpdateProfileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const UpdateProfileButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.edit, size: 18),
        label: const Text(
          "Perbarui Profil & Lokasi Maps",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}