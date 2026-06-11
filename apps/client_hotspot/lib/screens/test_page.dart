import 'package:flutter/material.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman Kosong"),
      ),
      body: const Center(
        child: Text(
          "Siap untuk diisi konten...",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}