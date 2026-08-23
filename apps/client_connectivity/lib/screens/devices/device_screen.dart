
import 'package:flutter/material.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Device Screen!'),
      ),
    );
  }
}