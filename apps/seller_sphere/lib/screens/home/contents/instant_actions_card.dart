import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class InstantActionsCard extends StatelessWidget {
  const InstantActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle glowButtonStyle = ElevatedButton.styleFrom(
      shadowColor: kWarmOrange.withValues(alpha: 0.8),
      elevation: 10,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Aksi Demonstrasi Instan',
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: glowButtonStyle,
                child: const Text('+ Simulasi Seller'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: glowButtonStyle,
                child: const Text('+ Pesan Konsensus'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => throw Exception(),
          style: glowButtonStyle,
          child: const Text("Throw Test Exception"),
        ),
      ],
    );
  }
}
