import 'package:flutter/material.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tekan tombol untuk memicu error.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                throw Exception('Test error');
              },
              child: const Text('Test Crash'),
            ),
          ],
        ),
      ),
    );
  }
}
