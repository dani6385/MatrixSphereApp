import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../../account/widgets/account_menu_modal.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  void _showAccountMenu(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AccountMenuModal(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: kDarkBackground,
      elevation: 0,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => _showAccountMenu(context),
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('images/img_profile-avatar.jpg'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Matrix Sphere',
                style: textTheme.titleMedium?.copyWith(color: kDarkBackground),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: kWarmOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    'Local Mode',
                    style: textTheme.bodySmall
                        ?.copyWith(color: kDarkTextSecondary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.cloud_outlined, color: kWarmOrange),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
