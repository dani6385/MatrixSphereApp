import 'package:flutter/material.dart';
import 'package:client_hotspot/auth/mikrotik_auth.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final MikrotikAuth _auth = MikrotikAuth();
  final Logger _logger = Logger();

  String? _challenge;
  String? _chapId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
    _fetchChallenge();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedUser = prefs.getString('username');
    String? savedPass = prefs.getString('password');

    if (savedUser != null && savedPass != null) {
      bool isActive = await _checkUserStatusInFirebase(savedUser);

      if (isActive && mounted) {
        _usernameController.text = savedUser;
        _passwordController.text = savedPass;
        await _login();
      }
    }
  }

  Future<bool> _checkUserStatusInFirebase(String username) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .get();

      return doc.exists && (doc.get('is_active') == true);
    } catch (e) {
      return false;
    }
  }

  Future<void> _fetchChallenge() async {
    setState(() => _isLoading = true); // Tampilkan loading spinner

    try {
      // Aplikasi akan menunggu sampai IP didapatkan dari Firebase
      String url = await _auth.getLoginUrl();

      await http.get(Uri.parse(url));
      // ... proses selanjutnya ...
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
    } catch (e) {
      _logger.e("Error terjadi: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Koneksi gagal: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      if (_challenge == null || _chapId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Challenge not available. Cannot login.'),
          ),
        );
        return;
      }

      try {
        await _auth.doLogin(
          _usernameController.text,
          _passwordController.text,
          _challenge!,
          _chapId!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotspot Login'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder<String>(
                      stream: _auth.getLoginUrlStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        return Text("Router aktif di: ${snapshot.data}");
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
