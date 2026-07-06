import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// A screen for users to register as a seller.
///
/// This is a placeholder screen. You can expand this with form fields
/// for store name, address, contact info, etc.
class RegisterSellerScreen extends StatelessWidget {
  const RegisterSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Sebagai Penjual'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.storefront_outlined, size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              'Bergabunglah dengan Kami!',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('Mulai perjalanan Anda sebagai penjual di platform kami.', style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            PrimaryButton(onPressed: () {}, child: const Text('Mulai Pendaftaran')),
          ],
        ),
      ),
    );
  }
}