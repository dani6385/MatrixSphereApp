// lib/screens/shop/widgets/shop_profile_body.dart
import 'package:flutter/material.dart';

/// Widget wrapper yang menangani status loading untuk profil toko.
/// Jika `isLoading` true, akan menampilkan `CircularProgressIndicator`.
/// Jika tidak, akan menampilkan `child` yang diberikan di dalam `SingleChildScrollView`.
class ShopProfileBody extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const ShopProfileBody({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: child,
          );
  }
}