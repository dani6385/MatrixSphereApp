
import 'package:flutter/material.dart';

class PublicProductScreen extends StatelessWidget {
  const PublicProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Product'),
      ),
      body: const Center(
        child: Text('Public Product Screen Content'),
      ),
    );
  }
}
