import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_sphere/auth/auth_bloc.dart';
import 'package:seller_sphere/screens/inventory/widgets/quick_actions_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasbor Penjual'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Mengirim event LogoutRequested ke AuthBloc
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            QuickActionsSection(),
            // Anda bisa menambahkan widget lain di sini, seperti daftar produk
          ],
        ),
      ),
    );
  }
}