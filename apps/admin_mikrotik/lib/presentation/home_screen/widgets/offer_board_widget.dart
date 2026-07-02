import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/theme/app_theme.dart';

import 'package:shared_ui/shared_ui.dart';

import '../../../widgets/custom_image_widget.dart';

class OfferBoardWidget extends StatelessWidget {
  OfferBoardWidget({super.key});

  final List<Map<String, dynamic>> _offers = [
    {
      'title': 'Paket Weekend Special',
      'subtitle': 'Nikmati internet 3 hari + bonus 2 hari gratis',
      'tag': 'PROMO',
      'tagColor': AppTheme.secondary,
      'imageUrl':
          'https://images.unsplash.com/photo-1707757840354-7598d2224d3b',
      'semanticLabel':
          'Person using laptop in a bright cafe with coffee on table',
      'bgColor': const Color(0xFFFFF3E0),
    },
    {
      'title': 'Member Bulanan',
      'subtitle': 'Akses tanpa batas 30 hari, kecepatan hingga 20 Mbps',
      'tag': 'TERLARIS',
      'tagColor': AppTheme.primary,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1bfc1f750-1782544013481.png',
      'semanticLabel':
          'Entrepreneur working on laptop with fast wifi connection',
      'bgColor': const Color(0xFFE8F5E9),
    },
    {
      'title': 'Voucher Pelajar',
      'subtitle': 'Khusus pelajar & mahasiswa, hemat 30%',
      'tag': 'DISKON',
      'tagColor': const Color(0xFF6A1B9A),
      'imageUrl':
          'https://images.unsplash.com/photo-1625111382375-900a8741c425',
      'semanticLabel':
          'Students studying together with laptops in university library',
      'bgColor': const Color(0xFFF3E5F5),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Penawaran Spesial',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Lihat Semua',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _offers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final offer = _offers[i];
              return _OfferCard(offer: offer);
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;

  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: offer['bgColor'] as Color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -10,
              child: CustomImageWidget(
                imageUrl: offer['imageUrl'] as String,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                semanticLabel: offer['semanticLabel'] as String,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: offer['tagColor'] as Color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      offer['tag'] as String,
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    offer['title'] as String,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    offer['subtitle'] as String,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: const Color(0xFF5C5C5C),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
