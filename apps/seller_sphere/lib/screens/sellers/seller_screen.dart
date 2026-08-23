
library seller_screen;

import 'package:flutter/material.dart';

class SellersScreen extends StatelessWidget {
  const SellersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sellers'),
      ),
      body: const Center(
        child: Text('Sellers Screen Content'),
      ),
    );
  }
}