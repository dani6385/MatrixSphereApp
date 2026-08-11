import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// A chip-like button for quick actions on the home screen.
class QuickActionChip extends StatelessWidget {
  const QuickActionChip({
    super.key,
    required this.icon,
    required this.label,
    this.onTap, required Null Function() onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: context.onSurface),
          const SizedBox(height: 8),
          Text(label, style: AppStyles.bodySmall),
        ],
      ),
    );
  }
}

extension on BuildContext {
  
}