import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_core/shared_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;
  // Use dynamic to allow calling the actual auth method name provided by the service
  final dynamic _authService = GetIt.I<FirebaseService>(); // Mengambil dari Service Locator

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    bool isMemberValid = await _authService.signIn(
      _userController.text.trim(),
      _passController.text.trim(),
    );

    if (isMemberValid) {
      if (!mounted) return;
      // Navigasi ke MainMenuPage
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Placeholder()));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username atau Password salah!")),
      );
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Member")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _userController, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: _passController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            
            // Indikator Loading atau Tombol Login
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(onPressed: _handleLogin, child: const Text("Masuk")),
            
            const Divider(height: 40),
            
            // ... (Sisa Grid menu Anda bisa diletakkan di MainMenuPage nantinya)
          ],
        ),
      ),
    );
  }
}