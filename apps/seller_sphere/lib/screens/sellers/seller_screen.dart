
import 'package:flutter/material.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sellers'),
      ),
      body: const Center(
        child: Text('Seller Screen Content'),
      ),
    );
  }
}
