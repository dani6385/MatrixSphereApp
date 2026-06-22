import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MadingWidget extends StatelessWidget {
  const MadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi & Penawaran',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              OfferCard(
                title: 'Diskon 50% Paket Super',
                subtitle: 'Nikmati internetan tanpa batas!',
                color: Colors.orange,
                icon: Icons.local_offer,
              ),
              OfferCard(
                title: 'Bonus Kuota 10GB',
                subtitle: 'Untuk pelanggan setia',
                color: Colors.blue,
                icon: Icons.card_giftcard,
              ),
              OfferCard(
                title: 'Roaming Hemat',
                subtitle: 'Keliling dunia tanpa khawatir',
                color: Colors.green,
                icon: Icons.airplanemode_active,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const OfferCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withAlpha(9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withAlpha(9),
            ),
          ),
        ],
      ),
    );
  }
}
