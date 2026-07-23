import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_sphere/auth/auth_bloc.dart'; // Sesuaikan dengan path AuthBloc Anda
import 'package:seller_sphere/screens/login/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  /// Memuat kredensial pengguna jika 'Remember Me' sebelumnya diaktifkan.
  Future<void> _loadUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final bool rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe) {
      setState(() {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? ''; // Hati-hati dengan menyimpan password
        _rememberMe = true;
      });
    }
  }

  /// Menyimpan atau menghapus kredensial berdasarkan pilihan 'Remember Me'.
  Future<void> _handleRememberMe(bool value) async {
    setState(() {
      _rememberMe = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);

    if (value) {
      // Jika 'Remember Me' dicentang, simpan email dan password
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      // Jika tidak, hapus kredensial yang tersimpan
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  /// Logika untuk memproses login.
  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulasikan panggilan API
      Future.delayed(const Duration(seconds: 2), () {
        // PENTING: Periksa apakah widget masih ada di tree sebelum menggunakan context.
        // Ini mencegah error jika pengguna meninggalkan halaman sebelum Future selesai.
        if (!mounted) return;

        // Panggil event LoginRequested dari AuthBloc Anda
        context.read<AuthBloc>().add(
              LoginRequested(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );

        // Setelah login berhasil, AuthBloc akan mengubah state
        // dan navigator akan membawa pengguna ke halaman utama.
        // Di sini kita hanya menonaktifkan loading.
        // Penanganan navigasi sebaiknya dilakukan oleh BlocListener di atas widget tree.
        
        // Perbarui status 'Remember Me' setelah login berhasil
        _handleRememberMe(_rememberMe);

        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Penjual'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Selamat Datang Kembali!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Masuk untuk mengelola toko Anda.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Mohon masukkan email yang valid.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('Ingat Saya'),
                value: _rememberMe,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      _rememberMe = value;
                    });
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text('Login', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Belum punya akun? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Daftar di sini',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
