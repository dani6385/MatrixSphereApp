import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/theme/app_colors.dart';
import '../providers/settings_provider.dart';
import './custom_text_field.dart';

class ChangePasswordSection extends StatelessWidget {
  const ChangePasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ubah Kata Sandi', style: theme.textTheme.titleLarge?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'Kata Sandi Saat Ini',
          obscureText: !settingsProvider.isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              settingsProvider.isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: textSecondary,
              size: 20,
            ),
            onPressed: () {
              settingsProvider.togglePasswordVisibility();
            },
          ),
        ),
        const SizedBox(height: 16),
        const CustomTextField(label: 'Kata Sandi Baru', obscureText: true),
        const SizedBox(height: 16),
        const CustomTextField(label: 'Konfirmasi Kata Sandi Baru', obscureText: true),
        const SizedBox(height: 24),
        ElevatedButton.icon(
           style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {},
          icon: const Icon(Icons.lock_reset, size: 20),
          label: Text('Ubah Kata Sandi', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
