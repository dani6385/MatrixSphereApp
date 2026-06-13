import 'package:client_hotspot/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _loginType;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;

  final String linkLoginOnly = "\$(link-login-only)";
  final String linkOrig = "\$(link-orig)";
  final String chapId = "\$(chap-id)";
  final String chapChallenge = "\$(chap-challenge)";
  final String macEsc = "\$(mac-esc)";

  void _showInput(String type) {
    setState(() {
      _loginType = type;
      _error = null;
    });
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      // Simulate a network request.
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // For now, we'll assume the login is always successful
      // In a real app, you would have logic to check credentials.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  void _scanQRIS() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QRIS scanning not implemented.')),
    );
  }

  void _payQRIS() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QRIS payment not implemented.')),
    );
  }

  void _trialLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trial login not implemented.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black.withAlpha(179),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: _buildGlassBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBox() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.white.withAlpha(51)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildLoginOptions(),
            const SizedBox(height: 20),
            _buildFormArea(),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: _trialLogin,
              child: const Text(
                'Trial',
                style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          "MATRIX SPHERE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Text(
          "Sistem Akses Jaringan Terintegrasi",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginOptions() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton(onPressed: () => _showInput('voucher'), child: const Text("Voucher")),
        ElevatedButton(onPressed: () => _showInput('member'), child: const Text("Member")),
        ElevatedButton(onPressed: _scanQRIS, child: const Text("SCAN QRIS")),
        ElevatedButton(onPressed: _payQRIS, child: const Text("Bayar QRIS")),
      ],
    );
  }

  Widget _buildFormArea() {
    if (_loginType == null) {
      return const Text(
        "Silakan pilih metode login di atas.",
        style: TextStyle(color: Colors.white70),
        textAlign: TextAlign.center,
      );
    }
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                color: Colors.red.withAlpha(204),
                padding: const EdgeInsets.all(8),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (_loginType == 'voucher')
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: "Kode Voucher",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white24),
              validator: (value) =>
                  (value?.isEmpty ?? true) ? "Kode voucher tidak boleh kosong" : null,
            ),
          if (_loginType == 'member') ...[
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: "Username Member",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white24),
              validator: (value) => (value?.isEmpty ?? true) ? "Username tidak boleh kosong" : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white24),
              validator: (value) => (value?.isEmpty ?? true) ? "Password tidak boleh kosong" : null,
            ),
          ],
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text("Login"),
                ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Text(
      "© 2024 MatrixSphere Network.",
      style: TextStyle(color: Colors.white54, fontSize: 12),
    );
  }
}
