import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Sebuah badge yang menampilkan pesan disclaimer keamanan.
class SecurityDisclaimerBadge extends StatelessWidget {
  const SecurityDisclaimerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    const disclaimerColor = kSoftTeal;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: disclaimerColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: disclaimerColor.withValues(alpha: 0.2), width: 0.5),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock, color: disclaimerColor, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Data profil Anda dilindungi dengan enkripsi lokal end-to-end. Lokasi digunakan untuk memetakan kurir logistik penjemputan barang.",
              style: TextStyle(
                fontSize: 10,
                color: disclaimerColor,
                height: 1.4, // line-height
              ),
            ),
          ),
        ],
      ),
    );
  }
}