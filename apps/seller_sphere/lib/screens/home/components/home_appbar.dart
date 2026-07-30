
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/navigation/app_routes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required List<Widget> actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Dasbor Penjual',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, size: 28),
          onPressed: () => context.push(AppRoutes.notifications),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16.0, left: 8.0),
          child: CircleAvatar(
            backgroundColor: kBrandPrimary,
            child: Text('A',
              style: TextStyle(color: kDarkTextPrimary),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
