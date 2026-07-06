import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
// Kerangka Button yang bisa dipakai semua aplikasi
class MSButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const MSButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: AppColors.primary)),
    );
  }
}