import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A reusable icon button with an optional notification badge.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.onPressed,
    this.badgeCount,
    this.badgeColor = Colors.red,
  });

  /// The icon to display inside the button.
  final IconData icon;

  /// The callback that is called when the button is tapped.
  final VoidCallback onPressed;

  /// The number to display in the badge. If null or 0, the badge is hidden.
  final int? badgeCount;

  /// The background color of the badge.
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    final hasBadge = badgeCount != null && badgeCount! > 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.iconBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: AppColors.iconPrimary),
            onPressed: onPressed,
          ),
        ),
        if (hasBadge)
          Positioned(
            right: 4,
            top: 4,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: badgeColor,
              child: Text(
                '$badgeCount',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}