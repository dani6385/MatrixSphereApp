import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AksesMemberPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const AksesMemberPage({super.key, required this.onLoginSuccess});

  @override
  State<AksesMemberPage> createState() => _AksesMemberPageState();
}

class _AksesMemberPageState extends State<AksesMemberPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  // 1. Tambahkan variabel status loading
  bool _isLoading = false;

  Future<void> _loginMember() async {
    // 2. Aktifkan loading saat tombol ditekan
    setState(() => _isLoading = true);

    final Uri loginUrl = Uri.parse('http://192.168.20.1/login');

    try {
      final response = await http.post(loginUrl, body: {
        'username': _userController.text,
        'password': _passController.text,
        'dst': 'http://www.google.com',
        'popup': 'true',
      });

      if (mounted) {
        if (response.statusCode == 200) {
          widget.onLoginSuccess();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Gagal, cek username/password")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Tidak bisa terhubung ke MikroTik")),
        );
      }
    } finally {
      // 3. Matikan loading setelah proses selesai (sukses atau gagal)
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Login Member", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextField(controller: _userController, decoration: const InputDecoration(labelText: "Username")),
          TextField(controller: _passController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
          const SizedBox(height: 20),
          
          // 4. Modifikasi Tombol agar menampilkan loading
          ElevatedButton(
            onPressed: _isLoading ? null : _loginMember, 
            child: _isLoading 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                  )
                : const Text("Login"),
          ),
        ],
      ),
    );
  }
}