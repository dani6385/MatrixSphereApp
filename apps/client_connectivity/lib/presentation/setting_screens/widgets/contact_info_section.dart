import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/theme/app_colors.dart';
import '../providers/settings_provider.dart';
import './custom_text_field.dart';

class ContactInfoSection extends StatelessWidget {
  const ContactInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final user = settingsProvider.user;
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informasi Kontak', style: theme.textTheme.titleLarge?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        CustomTextField(label: 'Nama Lengkap', controller: nameController),
        const SizedBox(height: 16),
        CustomTextField(label: 'Alamat Email', controller: emailController),
        const SizedBox(height: 16),
        CustomTextField(label: 'Nomor Telepon', controller: phoneController),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            settingsProvider.updateUser(
              nameController.text,
              emailController.text,
              phoneController.text,
            );
          },
          icon: const Icon(Icons.save_outlined, size: 20),
          label: Text('Perbarui Kontak', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
