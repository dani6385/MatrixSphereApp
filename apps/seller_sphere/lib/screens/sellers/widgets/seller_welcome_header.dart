import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart'; // Impor AppStyles
import '../../top_up/top_up_screen.dart';

class SellerWelcomeHeader extends StatelessWidget {
  final String sellerName;
  final String saldo;
  const SellerWelcomeHeader({
    super.key,
    required this.sellerName, required this.saldo,
    //required this.Saldo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selamat Datang,',
          style: AppStyles.bodyMedium,
        ),
        Text(
          '$sellerName (Saldo: $saldo)', // Combine sellerName and Saldo into a single string
          style: AppStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const TopUpScreen()),
                  );
                },
                icon: const Icon(Icons.add_card_outlined),
                label: const Text('Top Up'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Implementasi logika Transfer
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Transfer belum tersedia.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: context.secondaryContainer,
                    foregroundColor: context.onSecondaryContainer),
                icon: const Icon(Icons.send_outlined),
                label: const Text('Transfer'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
