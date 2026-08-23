import 'package:flutter/material.dart';

class AttendanceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefreshLocation;

  const AttendanceAppBar({
    Key? key,
    required this.onRefreshLocation,
    required void Function() onOpenDrawer,
    required void Function() onOpenEndDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Absensi Wajah & Lokasi"),
      backgroundColor: Colors.blueAccent,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefreshLocation,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
