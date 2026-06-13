import 'package:client_hotspot/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';

class VoucherLoginScreen extends StatefulWidget {
  const VoucherLoginScreen({super.key});

  @override
  State<VoucherLoginScreen> createState() => _VoucherLoginScreenState();
}

class _VoucherLoginScreenState extends State<VoucherLoginScreen> {
  final _voucherController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final success = await MikrotikService.loginWithVoucher(_voucherController.text);

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        setState(() {
          _error = "Kode voucher tidak valid atau sudah digunakan.";
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login dengan Voucher'),
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Masukkan kode voucher Anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _voucherController,
                    decoration: InputDecoration(
                      labelText: 'Kode Voucher',
                      filled: true,
                      fillColor: Colors.white.withAlpha(230),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kode voucher tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
