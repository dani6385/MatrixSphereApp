import 'package:flutter/material.dart';

class MemberBottom extends StatelessWidget {
  const MemberBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang, Member!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Anda bisa menambahkan informasi atau aksi lain untuk member di sini
            Text('Ini adalah area khusus member.'),
          ],
        ),
      ),
    );
  }
}
