<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/features/providers/shopes/components/shopes_body.dart';
import 'package:seller_sphere/features/providers/shopes/providers/shopes_viewmodel.dart';

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
<<<<<<< HEAD
=======
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/features/providers/shopes/components/shopes_body.dart';
import 'package:seller_sphere/features/providers/shopes/providers/shopes_viewmodel.dart';

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
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
}