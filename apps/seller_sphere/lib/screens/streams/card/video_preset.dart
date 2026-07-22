import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class VideoPreset extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  const VideoPreset({super.key, required this.name, required this.isSelected, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? kNeonCyan.withValues(alpha: 0.15) : Colors.transparent,
            border: Border.all(color: isSelected ? kNeonCyan : Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: isSelected ? kNeonCyan : Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 6),
              Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: isSelected ? kNeonCyan : null)),
            ],
          ),
        ),
      ),
    );
  }
}