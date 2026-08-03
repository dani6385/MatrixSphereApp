import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IncomeTransaction extends StatelessWidget {
  const IncomeTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendapatan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(child: Text('Halaman Pendapatan')),
    );
  }
}