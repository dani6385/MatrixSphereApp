
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  const Icon(
                    Icons.shield,
                    size: 60,
                    color: primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'AKSES KONTROL & PANTAU',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SecurApp Admin Portal',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log Masuk Admin',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          initialValue: 'admin',
                          style: const TextStyle(color: textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Nama Pengguna (Username)',
                            labelStyle: const TextStyle(color: textSecondary),
                            prefixIcon:
                                const Icon(Icons.person_outline, color: textSecondary, size: 20),
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: border),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: primary),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          obscureText: !_isPasswordVisible,
                          style: const TextStyle(color: textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Kata Sandi (Password)',
                            labelStyle: const TextStyle(color: textSecondary),
                            isDense: true,
                            prefixIcon: const Icon(Icons.lock_outline, color: textSecondary, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: textSecondary,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: border),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: primary),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          initialValue: "password",
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            context.go('/two_factor');
                          },
                          child: Text(
                            'Masuk Portal',
                            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: border, thickness: 0.5)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('atau gunakan Google',
                            style: TextStyle(color: textSecondary, fontSize: 12)),
                      ),
                      const Expanded(child: Divider(color: border, thickness: 0.5)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: textPrimary,
                      backgroundColor: surface,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: border),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                    ),
                    onPressed: () {
                      // Handle Google Sign-in
                    },
                    icon: Image.asset('assets/images/google_logo.png', height: 22),
                    label: const Text(
                      'Masuk dengan Google',
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
