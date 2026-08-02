
import 'package:flutter/material.dart';


class AttendanceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AttendanceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.menu), // You can change this icon if needed
        tooltip: 'Open Menu',
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: const Text('Attendance'),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list), // You can change this icon if needed
          tooltip: 'Open Filters',
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}