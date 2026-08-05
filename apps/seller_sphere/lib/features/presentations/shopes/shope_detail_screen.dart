import 'package:flutter/material.dart';
import 'package:seller_sphere/features/domain/entities/user.dart';
import 'components/shope_detail_body.dart';

/// Halaman untuk menampilkan detail seorang pelanggan.
class ShopeDetailScreen extends StatelessWidget {
  final User user;

  const ShopeDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.displayName ?? 'Detail Pelanggan'),
        centerTitle: true,
      ),
      body: ShopeDetailBody(user: user),
    );
  }
}