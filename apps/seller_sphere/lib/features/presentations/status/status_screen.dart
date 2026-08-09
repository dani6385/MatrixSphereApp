// lib/features/presentations/status/status_screen.dart

import 'package:flutter/material.dart';
import 'components/status_body.dart';

/// Layar untuk menampilkan status umum toko, seperti persetujuan, rating, dll.
class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Toko'),
      ),
      body: const StatusBody(),
    );
  }
}