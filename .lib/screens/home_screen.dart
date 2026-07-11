import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Welcome to Guardian Console\nSystem Operational",
        textAlign: TextAlign.center,
      ),
    );
  }
}