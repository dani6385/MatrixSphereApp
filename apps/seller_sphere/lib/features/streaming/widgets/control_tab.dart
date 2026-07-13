import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ControlTab extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isActive;

  const ControlTab({super.key, required this.text, required this.icon, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: isActive ? kPurple : Colors.grey, size: 16),
            const SizedBox(width: 8),
            Text(text, style: textTheme.bodyMedium?.copyWith(color: isActive ? kPurple : Colors.grey)),
          ],
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 2,
            width: 60,
            color: kPurple,
          ),
      ],
    );
  }
}
