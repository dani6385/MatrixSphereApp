import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class GeneralActions extends StatelessWidget {
  const GeneralActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _buildSmallActionCard(context,
                icon: Icons.calendar_today, text: 'Ajukan Cuti / Izin')),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child: _buildSmallActionCard(context,
                icon: Icons.gps_fixed, text: 'Verifikasi GPS')),
      ],
    );
  }

  Widget _buildSmallActionCard(BuildContext context,
      {required IconData icon, required String text}) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        foregroundColor: kDarkTextPrimary,
        backgroundColor: kDarkSecondary,
        side: const BorderSide(color: kDarkSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
