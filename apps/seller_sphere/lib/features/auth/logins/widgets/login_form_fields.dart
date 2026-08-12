// lib/screens/login/widgets/login_form_fields.dart
import 'package:flutter/material.dart';

class LoginFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool rememberMe;
  final VoidCallback onLoginPressed;
  final VoidCallback onTogglePasswordVisibility;
  final ValueChanged<bool?> onRememberMeChanged;

  const LoginFormFields({
    super.key,
    required this.formKey,
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.rememberMe,
    required this.onLoginPressed,
    required this.onTogglePasswordVisibility,
    required this.onRememberMeChanged,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Mohon masukkan email Anda';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Mohon masukkan email yang valid';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onTogglePasswordVisibility,
            ),
          ),
          autofillHints: const [AutofillHints.password],
          onEditingComplete: onLoginPressed,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Mohon masukkan password Anda';
            }
            if (value.length < 8) {
              return 'Password harus memiliki minimal 8 karakter';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Remember Me'),
          value: rememberMe,
          onChanged: onRememberMeChanged,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
