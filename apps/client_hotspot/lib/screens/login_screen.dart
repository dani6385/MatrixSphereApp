import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart' as shared_services;
import 'Dashboard_Screen.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_core/shared_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String _selectedMethod = '';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showInput(String method) {
    if (method == 'member') {
      showMemberForm(context);
      return;
    } else if (method == 'voucher') {
      showVoucherDialog(context);
      return;
    } else if (method == 'trial') {
      showTrialDialog(context);
      return;
      } else if (method == 'scan' || method == 'bayar') {
      showQRScanner(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0f172a),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
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
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMethodButton("Scan QRIS", Icons.qr_code_scanner, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScanPage()),
                      );
                    }),
                    const SizedBox(width: 10),
                    _buildMethodButton("Bayar QRis", Icons.qr_code_scanner, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScanPage()),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMethodButton(
                      "TRIAL",
                      Icons.confirmation_number,
                      () => _showInput('trial'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- AREA POPUP/DYNAMIC INPUT (Muncul di bawah tombol) ---
                if (_selectedMethod.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Login $_selectedMethod",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                      ],
                    ),
                  ),
              ],
            ),
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

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      // Panggil service Mikrotik
      bool success = await MikrotikService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (success) {
        // Simpan sesi lokal
        await shared_services.AuthService.setLoggedIn(
          true,
          _usernameController.text,
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        throw Exception("Username atau Password salah/Timeout");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal terhubung ke Mikrotik: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
