import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SellerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SellerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kDarkBackground,
      elevation: 0,
      title: const Text('Matrix Sphere',
          style: TextStyle(color: kDarkTextPrimary, fontWeight: FontWeight.bold)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[850],
            child: const Icon(Icons.chat_bubble_outline,
                color: kWarmOrange, size: 20),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: kWarmOrange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text('Local Mode', style: TextStyle(color: kWarmOrange)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30.0);
}
