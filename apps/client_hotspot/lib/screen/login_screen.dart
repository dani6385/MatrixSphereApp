import 'package:client_hotspot/screen/voucher_login_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Metode Login'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildOptionButton(
                  context,
                  icon: Icons.confirmation_number,
                  label: 'Gunakan Voucher',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VoucherLoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildOptionButton(
                  context,
                  icon: Icons.person_pin,
                  label: 'Login Member',
                  onPressed: () {
                    // TODO: Implementasi logika untuk login member
                  },
                ),
                const SizedBox(height: 16),
                _buildOptionButton(
                  context,
                  icon: Icons.qr_code_scanner,
                  label: 'Scan QRIS',
                  onPressed: () {
                    // TODO: Implementasi logika untuk scan QRIS
                  },
                ),
                const SizedBox(height: 16),
                _buildOptionButton(
                  context,
                  icon: Icons.credit_card,
                  label: 'Bayar dengan QRIS',
                  onPressed: () {
                    // TODO: Implementasi logika untuk bayar dengan QRIS
                  },
                ),
                const SizedBox(height: 16),
                _buildOptionButton(
                  context,
                  icon: Icons.hourglass_empty,
                  label: 'Trial',
                  onPressed: () {
                    // TODO: Implementasi logika untuk trial
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.deepPurple, 
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 20),
        elevation: 5,
      ),
    );
  }
}
