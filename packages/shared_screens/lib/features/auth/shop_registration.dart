
library shop_registration;

import 'package:flutter/material.dart';

class ShopRegistrationScreen extends StatelessWidget {
  const ShopRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Toko'),
      ),
      body: const Center(
        child: Text('Halaman Registrasi Toko'),
      ),
    );
  }
}