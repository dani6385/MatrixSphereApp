import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kDarkSurface,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage('https://placehold.co/100x100'),
        ),
      ),
      title: const Text(
        'Seller Sphere',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.amber),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.flag, color: Colors.red),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.blue),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
