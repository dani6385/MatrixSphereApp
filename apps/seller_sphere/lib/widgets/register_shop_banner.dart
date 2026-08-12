import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';

class RegisterShopBanner extends StatelessWidget {
  

final VoidCallback onDismiss;

  const RegisterShopBanner({
    super.key,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kNeonBlue,
      child: InkWell(
        onTap: () {
          // Navigasi ke halaman pendaftaran toko saat di-klik
          context.go(AppRoutes.shopRegister);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.store, color: Colors.white, size: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Toko Anda belum terdaftar.',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Klik di sini untuk mendaftar!',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
