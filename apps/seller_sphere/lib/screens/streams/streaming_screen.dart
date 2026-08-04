
import 'package:flutter/material.dart';

class StreamingScreen extends StatelessWidget {
  const StreamingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streaming'),
      ),
      body: const Center(
        child: Text('Streaming Screen Content'),
      ),
    );
  }
}
