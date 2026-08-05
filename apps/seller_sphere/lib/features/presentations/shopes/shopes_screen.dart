import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/features/presentations/shopes/components/shopes_body.dart';
import 'package:seller_sphere/features/presentations/shopes/providers/shopes_viewmodel.dart';

/// Halaman utama untuk fitur "Shopes" atau Pelanggan.
///
/// Widget ini bertanggung jawab untuk menyediakan [ShopesViewModel]
/// ke widget turunannya dan membangun struktur dasar UI.
class ShopesScreen extends StatelessWidget {
  const ShopesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShopesViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pelanggan'),
          centerTitle: true,
        ),
        body: const ShopesBody(),
      ),
    );
  }
}