import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    final currentUser = viewModel.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64),
            SizedBox(height: 8),
            Text("Anda telah keluar."),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileAvatarBannerCard(
              fullName: currentUser.fullName,
              email: currentUser.email,
            ),
            const SizedBox(height: 16),
            _SuccessBanner(),
            const SizedBox(height: 16),
            _SectionTitle("Informasi Kontak"),
            const SizedBox(height: 8),
            _ContactInformationForm(
              key: ValueKey(
                currentUser.fullName + currentUser.email,
              ), // Pastikan form di-rebuild saat data berubah
              initialName: currentUser.fullName,
              initialEmail: currentUser.email,
              initialPhone: currentUser.phone,
            ),
            const SizedBox(height: 16),
            _SectionTitle("Ubah Kata Sandi"),
            const SizedBox(height: 8),
            _ChangePasswordForm(),
            const SizedBox(height: 16),
            _SectionTitle("Keamanan Akun & Otentikasi"),
            const SizedBox(height: 8),
            _TwoFactorToggleCard(is2FAEnabled: currentUser.isTwoFactorEnabled),
            const SizedBox(height: 24),
            _LogoutButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// --- WIDGETS --- //

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final message = Provider.of<AppViewModel>(context).profileSuccessMessage;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          SizeTransition(sizeFactor: animation, child: child),
      child: message != null
          ? Card(
              key: ValueKey(message),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _ProfileAvatarBannerCard extends StatelessWidget {
  final String fullName;
  final String email;
  const _ProfileAvatarBannerCard({required this.fullName, required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withAlpha(1),
      color: Theme.of(context).colorScheme.primary.withAlpha(05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withAlpha(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                fullName.isNotEmpty ? fullName[0].toUpperCase() : 'A',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(email, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Chip(
                  label: const Text("ROLE: ADMINISTRATOR"),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(15),
                  labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
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

class _ContactInformationForm extends StatefulWidget {
  final String initialName, initialEmail, initialPhone;
  const _ContactInformationForm({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
  });
  @override
  State<_ContactInformationForm> createState() =>
      _ContactInformationFormState();
}

class _ContactInformationFormState extends State<_ContactInformationForm> {
  late TextEditingController _name, _email, _phone;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName);
    _email = TextEditingController(text: widget.initialEmail);
    _phone = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_name, "Nama Lengkap"),
            const SizedBox(height: 12),
            _buildTextField(_email, "Alamat Email"),
            const SizedBox(height: 12),
            _buildTextField(_phone, "Nomor Telepon"),
            const SizedBox(height: 16),
            SizedBox(
              height: 44,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Provider.of<AppViewModel>(
                      context,
                      listen: false,
                    ).updateContactInformation(
                      _email.text,
                      _phone.text,
                    ),
                icon: const Icon(Icons.save),
                label: const Text("Perbarui Kontak"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController c, String label) =>
      TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      );
}

class _ChangePasswordForm extends StatefulWidget {
  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  final _currentPass = TextEditingController();
  final _newPass = TextEditingController();
  final _confirmPass = TextEditingController();
  bool _obscureText = true;
  bool _passwordsMismatch = false;
  @override
  void dispose() {
    _currentPass.dispose();
    _newPass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPassField(_currentPass, "Kata Sandi Saat Ini"),
            const SizedBox(height: 12),
            _buildPassField(_newPass, "Kata Sandi Baru"),
            const SizedBox(height: 12),
            _buildPassField(_confirmPass, "Konfirmasi Kata Sandi Baru"),
            if (_passwordsMismatch)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Konfirmasi kata sandi baru tidak cocok!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              height: 44,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_newPass.text == _confirmPass.text &&
                      _newPass.text.isNotEmpty) {
                    Provider.of<AppViewModel>(
                      context,
                      listen: false,
                    ).updatePassword(_currentPass.text, _newPass.text, );
                    _currentPass.clear();
                    _newPass.clear();
                    _confirmPass.clear();
                    setState(() => _passwordsMismatch = false);
                  } else {
                    setState(() => _passwordsMismatch = true);
                  }
                },
                icon: const Icon(Icons.vpn_key),
                label: const Text("Ganti Kata Sandi"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassField(TextEditingController c, String label) =>
      TextFormField(
        controller: c,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
      );
}

class _TwoFactorToggleCard extends StatelessWidget {
  final bool is2FAEnabled;
  const _TwoFactorToggleCard({required this.is2FAEnabled});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: is2FAEnabled
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(15)
                            : Theme.of(context).dividerColor,
                        child: Icon(
                          Icons.verified,
                          color: is2FAEnabled
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Verifikasi 2 Langkah (2FA)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Minta kode OTP rahasia setiap kali login",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: is2FAEnabled,
                  onChanged: (val) => Provider.of<AppViewModel>(
                    context,
                    listen: false,
                  ).toggle2FA(val),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Catatan: Apabila diaktifkan, kode OTP login verifikasi akan dikirimkan sebagai peringatan notifikasi sistem internal.",
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.primary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () =>
            Provider.of<AppViewModel>(context, listen: false).logout(),
        icon: const Icon(Icons.exit_to_app),
        label: const Text("Keluar Sesi Admin"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
