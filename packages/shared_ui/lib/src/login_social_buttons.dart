// lib/features/auth/login/widgets/login_social_buttons.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_ui/shared_ui.dart';

class LoginSocialButtons extends StatelessWidget {
  const LoginSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Atau masuk dengan',
                style: AppStyles.bodySmall,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.google),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Login dengan Google belum diimplementasikan.')),
                );
              },
              iconSize: 35,
              color: kAlertRed,
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.facebook),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Login dengan Facebook belum diimplementasikan.')),
                );
              },
              iconSize: 35,
              color: kBrandPrimary,
            ),
          ],
        ),
      ],
    );
  }
}