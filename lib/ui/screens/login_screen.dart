import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _otpController;

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: 'admin');
    _passwordController = TextEditingController(text: 'admin');
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginStep = ref.watch(loginStepProvider);
    final authError = ref.watch(authErrorProvider);
    final twoFactorCode = ref.watch(twoFactorCodeProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Upper background glow drawing
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(120),
                  bottomRight: Radius.circular(120),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main App Logo Badge
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.shield,
                        size: 52,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Positioned(
                        bottom: 12,
                        child: Icon(
                          Icons.lock,
                          size: 20,
                          color: Colors.teal.shade300,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // App Title
                Text(
                  'AKSES KONTROL & PANTAU',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text(
                  'SecurApp Admin Portal',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),

                const SizedBox(height: 28),

                // Sliding Steps container
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildLoginContent(loginStep),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContent(LoginStep step) {
    switch (step) {
      case LoginStep.loginSelection:
        return Column(
          children: [
            // Login form content would go here
            // This would be similar to the Kotlin version's login selection step
          ],
        );
      // Add other cases for different login steps
      default:
        return const SizedBox.shrink();
    }
  }
}

// Providers (would be defined in a separate file)
final loginStepProvider = StateProvider<LoginStep>((ref) => LoginStep.loginSelection);
final authErrorProvider = StateProvider<String?>((ref) => null);
final twoFactorCodeProvider = StateProvider<String>((ref) => '');

// LoginStep enum (would be defined in a separate file)
enum LoginStep {
  loginSelection,
  // Add other login steps as needed
}