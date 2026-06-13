import 'package:flutter/material.dart';
//import 'package:shared_ui/shared_ui.dart';
import 'package:shared_core/shared_core.dart';
import 'Dashboard_Screen.dart'; 


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi Login Utama dengan metode CHAP
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      const String chapId = "1"; 
      const String chapChallenge = "challenge_dari_mikrotik";

      await MikrotikService.login(
        _usernameController.text,
        _passwordController.text,
        chapId,
        chapChallenge,
      );

      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal login: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Implementasi UI Anda di sini
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading ? const CircularProgressIndicator() : const Text("LOGIN"),
            ),
          ],
        ),
      ),
    );
  }
}