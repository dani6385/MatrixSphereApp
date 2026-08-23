import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: AppStyles.elevatedButtonStyle,
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}