import 'package:flutter/material.dart';

class InstantActionsCard extends StatelessWidget {
  const InstantActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Aksi Demonstrasi Instan', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('+ Simulasi Seller'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('+ Pesan Konsensus'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => throw Exception(),
          child: const Text("Throw Test Exception"),
        ),
      ],
    );
  }
}
