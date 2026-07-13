import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kDarkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https://placehold.co/400x150/000000/FFFFFF/png?text=SS+Seller+Sphere',
          ),
          const SizedBox(height: 8),
          const Text(
            'Real-time Store Intelligence Pro',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
