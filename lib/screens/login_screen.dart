import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_view_model.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(8),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(120),
                  bottomRight: Radius.circular(120),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AppLogoBadge(),
                    const SizedBox(height: 16),
                    _AppTitle(),
                    const SizedBox(height: 28),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: _buildLoginStep(context, viewModel.loginStep),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _OtpNotificationCard(),
        ],
      ),
    );
  }

  Widget _buildLoginStep(BuildContext context, LoginStep step) {
    switch (step) {
      case LoginStep.loginSelection:
        return const _LoginSelectionStep();
      case LoginStep.googleSelect:
        return const _GoogleAccountPicker();
      case LoginStep.verifying:
        return const _VerifyingStep();
      case LoginStep.twoFactor:
        return const _TwoFactorStep();
      case LoginStep.loggedIn:
        return const SizedBox.shrink();
    }
  }
}

// --- WIDGETS --- //

class _AppLogoBadge extends StatelessWidget {
  /* Implementasi UI */
  @override
  Widget build(BuildContext context) => Container(
    width: 96,
    height: 96,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Theme.of(context).colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(1),
          blurRadius: 5,
          spreadRadius: 1,
        ),
      ],
      border: Border.all(
        color: Theme.of(context).colorScheme.primary.withAlpha(3),
        width: 2,
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.shield,
          size: 52,
          color: Theme.of(context).colorScheme.primary,
        ),
        Transform.translate(
          offset: const Offset(0, 4),
          child: Icon(Icons.lock, size: 20, color: Colors.teal[300]),
        ),
      ],
    ),
  );
}

class _AppTitle extends StatelessWidget {
  /* Implementasi UI */
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        "AKSES KONTROL & PANTAU",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      Text(
        "SecurApp Admin Portal",
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

class _LoginSelectionStep extends StatefulWidget {
  const _LoginSelectionStep();
  @override
  State<_LoginSelectionStep> createState() => _LoginSelectionStepState();
}

class _LoginSelectionStepState extends State<_LoginSelectionStep> {
  final _usernameController = TextEditingController(text: "admin");
  final _passwordController = TextEditingController(text: "admin");
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context, listen: false);
    final authError = context.watch<AppViewModel>().authError;

    return Column(
      children: [
        Card(
          elevation: 2,
          shadowColor: Colors.black.withAlpha(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Log Masuk Admin",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (authError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    authError,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Pengguna (Username)",
                    prefixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Kata Sandi (Password)",
                    prefixIcon: const Icon(Icons.vpn_key),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => viewModel.performTraditionalLogin(
                      _usernameController.text,
                      _passwordController.text,
                    ),
                    child: const Text(
                      "Masuk Portal",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "atau gunakan Google",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: viewModel.initiateGoogleLogin,
            icon: const Icon(Icons.g_translate, color: Colors.blue),
            label: Text(
              "Masuk dengan Google",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GoogleAccountPicker extends StatelessWidget {
  const _GoogleAccountPicker();
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context, listen: false);
    final accounts = [
      "dani6385@gmail.com",
      "admin.securapp@gmail.com",
      "dani.developer@gmail.com",
    ];

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withAlpha(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle, color: Colors.blue, size: 28),
                const SizedBox(width: 8),
                Text(
                  "Pilih Akun Google",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "SecurApp terhubung secara aman dengan Layanan Google OAuth.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ...accounts.map(
              (email) => Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () => viewModel.selectGoogleAccount(email),
                  leading: CircleAvatar(
                    child: Text(email.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(
                    email,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: viewModel.resetLoginFlow,
                child: const Text("Batal"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerifyingStep extends StatelessWidget {
  const _VerifyingStep();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
      children: const [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text("Menghubungkan layanan otentikasi..."),
      ],
    ),
  );
}

class _TwoFactorStep extends StatefulWidget {
  const _TwoFactorStep();
  @override
  _TwoFactorStepState createState() => _TwoFactorStepState();
}

class _TwoFactorStepState extends State<_TwoFactorStep> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context, listen: false);
    final authError = context.watch<AppViewModel>().authError;
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withAlpha(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phonelink_ring, size: 28),
                const SizedBox(width: 8),
                Text(
                  "Verifikasi Dua Langkah",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Sistem telah mengirimkan 6 digit kode OTP rahasia untuk memverifikasi kepemilikan akun admin Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            if (authError != null) ...[
              const SizedBox(height: 8),
              Text(
                authError,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.otpController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
              decoration: const InputDecoration(
                labelText: "6 Digit Kode OTP",
                border: OutlineInputBorder(),
                counterText: "",
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: viewModel.resetLoginFlow,
                    child: const Text("Batal"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => viewModel.verifyOtp(viewModel.otpController.text),
                    child: const Text(
                      "Verifikasi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpNotificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();
    if (viewModel.loginStep != LoginStep.twoFactor ||
        viewModel.twoFactorCode.isEmpty) {
      return const SizedBox.shrink();
    }
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 8,
        color: const Color(0xFF2C3E50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.cyanAccent),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 11),
              children: [
                const TextSpan(
                  text: "Sistem OTP SecurApp\n",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                TextSpan(
                  text:
                      "KODE VERIFIKASI: ${viewModel.twoFactorCode}. Masukkan untuk log masuk.\n",
                ),
                TextSpan(
                  text: "Ketuk kartu ini untuk mengisi otomatis!",
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = viewModel.autoFillOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
