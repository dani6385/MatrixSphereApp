// d:\matrixsphere\apps\seller_sphere\lib\features\auth\waiting_for_approval_screen.dart
import 'package:flutter/material.dart';
import 'package:seller_sphere/navigations/app_navigation.dart';
import 'package:shared_services/shared_services.dart';

/// Widget yang menampilkan pesan "Menunggu Persetujuan"
class WaitingForApprovalScreen extends StatelessWidget {
  const WaitingForApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Status Pendaftaran")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_top_rounded,
                  size: 60, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                'Menunggu Persetujuan',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Pendaftaran toko Anda sedang kami tinjau. Anda akan dapat mengakses dashboard setelah disetujui oleh admin.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await AuthService().logout();
                  if (context.mounted) {
                    AppNavigation.goToLogin(context);
                  }
                },
                child: const Text('Logout'),
              )
            ],
          ),
        ),
      ),
    );
  }
}