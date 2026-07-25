// lib/widgets/demo_mode_banner.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/features/auth/providers/auth_provider.dart';
import 'package:seller_sphere/navigation/app_extraktor.dart';

class DemoModeBanner extends StatelessWidget implements PreferredSizeWidget {
  const DemoModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isDemoMode) {
          return const SizedBox.shrink(); // Jangan tampilkan apapun jika bukan mode demo
        }
        return Container(
          width: double.infinity,
          color: Colors.amber.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Anda dalam Mode Demo. Fitur dibatasi.',
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {
                  authProvider.exitDemoMode();
                  // Arahkan kembali ke halaman login untuk mendaftar
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'LOGIN/DAFTAR',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 48.0);
}
