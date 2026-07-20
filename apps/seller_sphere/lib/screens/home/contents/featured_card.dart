// lib/screens/home/widgets/featured_card.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kBrandPrimary, // Warna latar belakang banner
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.star, color: kDarkTextPrimary, size: 36),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fitur Baru Telah Hadir!',
                  style: TextStyle(
                    color: kDarkTextPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Ketuk untuk menjelajahi menu baru kami.',
                  style: TextStyle(
                    color: kDarkTextPrimary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}