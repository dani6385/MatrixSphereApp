import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'menu_content.dart';

class AttendanceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AttendanceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: kDarkBackground,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: kDarkTextPrimary),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Absensi Karyawan',
              style: textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
          Text('Check-in & Rekap',
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
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MenuContent()),
            );
          },
          icon: const Icon(Icons.settings, color: kDarkTextPrimary),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
