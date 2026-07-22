import 'package:flutter/material.dart';


class AttendanceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AttendanceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Presensi Biometrik',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
      centerTitle: true,
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}