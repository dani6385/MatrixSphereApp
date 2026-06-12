import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart' as shared_services;
import 'Dashboard_Screen.dart';
import 'package:shared_core/shared_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedMethod = '';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showInput(String method) {
    setState(() => _selectedMethod = method);
  }

  // Fungsi login utama
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      // Di sini Anda harus memanggil logika login sebenarnya (API/Mikrotik)
      // Contoh: bool success = await MikrotikService.login(_usernameController.text, _passwordController.text);

      // Simulasi sukses
      await Future.delayed(const Duration(seconds: 2));

      // Simpan sesi menggunakan AuthService global
      await shared_services.AuthService.setLoggedIn(true, _usernameController.text);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login gagal: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0f172a),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "MATRIX SPHERE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Sistem Akses Jaringan Terintegrasi",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMethodButton(
                    "Voucher",
                    Icons.confirmation_number,
                    () => _showInput('voucher'),
                  ),
                  const SizedBox(width: 10),
                  _buildMethodButton(
                    "Member",
                    Icons.person,
                    () => _showInput('member'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMethodButton("Scan QR", Icons.qr_code_scanner, () {
                    // Tambahkan logika untuk membuka kamera scanner QR di sini
                    print("Membuka kamera scan...");
                  }),
                  const SizedBox(width: 10),
                  _buildMethodButton("Bayar QR", Icons.payment, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QrisScan()),
                    );
                    print("Membuka menu pembayaran QR...");
                  }),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMethodButton("TRIAL", Icons.qr_code_scanner, () {
                    print("Membuka kamera scan...");
                  }),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 20),
              if (_selectedMethod.isNotEmpty) ...[
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                if (_selectedMethod == 'member')
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _handleLogin,
                        child: const Text("LOGIN"),
                      ),
              ] else
                const Text(
                  "Silakan pilih metode login di atas.",
                  style: TextStyle(color: Colors.white54),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
    );
  }
}
