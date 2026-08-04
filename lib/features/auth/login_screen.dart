
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:matrix_sphere/navigations/app_extractor.dart';

final Logger _logger = Logger();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to MatrixSphere!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
                _logger.i('Login button pressed');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}