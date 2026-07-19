import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SystemAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SystemAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: kDarkBackground,
      elevation: 0,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('images/img_profile-avatar.jpg'),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('System Monitor',
              style: textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
          Text('Konsol Ringkasan',
              style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Rekonsiliasi'),
          style: TextButton.styleFrom(
            foregroundColor: kDarkTextPrimary,
            backgroundColor: kDarkSecondary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.cloud_outlined, color: Colors.orange),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
