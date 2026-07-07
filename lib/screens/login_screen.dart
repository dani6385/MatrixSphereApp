import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: viewModel.loginStep == LoginStep.twoFactor 
            ? _buildOtpForm(viewModel)
            : _buildInitialLoginForm(viewModel),
        ),
      ),
    );
  }

  Widget _buildInitialLoginForm(AppViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.shield, size: 80, color: Colors.indigo),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => viewModel.performTraditionalLogin("admin", "admin"),
          child: const Text("Masuk ke Console"),
        ),
      ],
    );
  }

  Widget _buildOtpForm(AppViewModel viewModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Verifikasi OTP", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: "Masukkan Kode"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.verifyOtp(_otpController.text),
              child: const Text("Verifikasi"),
            )
          ],
        ),
      ),
    );
  }
}