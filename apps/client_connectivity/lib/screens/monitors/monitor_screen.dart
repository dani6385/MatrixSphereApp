
import 'package:flutter/material.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Monitor Screen!'),
      ),
    );
  }
}