<<<<<<< HEAD
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/logo.png', // Jalur direktori tempat logo disimpan
        width: 120.0,             // Lebar gambar dalam piksel
        height: 120.0,            // Tinggi gambar dalam piksel
        fit: BoxFit.contain,      // Menyesuaikan proporsi gambar agar tidak terdistorsi
      ),
    );
  }
=======
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/logo.png', // Jalur direktori tempat logo disimpan
        width: 120.0,             // Lebar gambar dalam piksel
        height: 120.0,            // Tinggi gambar dalam piksel
        fit: BoxFit.contain,      // Menyesuaikan proporsi gambar agar tidak terdistorsi
      ),
    );
  }
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
}