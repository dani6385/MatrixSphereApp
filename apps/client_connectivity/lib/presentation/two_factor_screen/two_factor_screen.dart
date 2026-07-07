import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/theme/app_colors.dart';

class TwoFactorScreen extends StatelessWidget {
  const TwoFactorScreen({super.key});

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
                  const Spacer(flex: 1),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: border, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield, color: primary, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sistem OTP SecurApp',
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary),
                                  children: const <TextSpan>[
                                    TextSpan(text: 'KODE VERIFIKASI: '),
                                    TextSpan(
                                      text: '451736',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary),
                                    ),
                                    TextSpan(text: '. Masukkan untuk log masuk.'),
                                  ],
                                ),
                              ),
                               const SizedBox(height: 4),
                              Text(
                                'Ketuk baris ini untuk mengisi otomatis isian di bawah',
                                style: theme.textTheme.bodySmall?.copyWith(color: primary, decoration: TextDecoration.underline, decorationColor: primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone_android, color: textSecondary, size: 24),
                        const SizedBox(height: 8),
                        Text(
                          'Verifikasi Dua Langkah',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sistem telah mengirimkan 6 digit kode OTP rahasia untuk memverifikasi kepemilikan akun admin Anda demi keutuhan keamanan.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          textAlign: TextAlign.center,
                           style: const TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
                          decoration: InputDecoration(
                            labelText: '6 Digit Kode OTP',
                            labelStyle: const TextStyle(color: textSecondary, letterSpacing: 0),
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
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 48),
                                  side: const BorderSide(color: border),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () => context.go('/login'),
                                child: Text('Batal', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary.withOpacity(0.5),
                                  minimumSize: const Size(0, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () {
                                  context.go('/');
                                },
                                child: Text(
                                  'Verifikasi',
                                  style: TextStyle(color: textPrimary.withOpacity(0.5), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
