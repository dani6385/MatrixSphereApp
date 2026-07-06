import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool showSuccessBanner = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final successMessage = ref.watch(profileSuccessMessageProvider);

    // Show success banner when message is available
    if (successMessage != null && !showSuccessBanner) {
      setState(() => showSuccessBanner = true);
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() => showSuccessBanner = false);
          ref.read(profileSuccessMessageProvider.notifier).clearMessage();
        }
      });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          padding: const EdgeInsets.only(top: 12, bottom: 32),
          children: [
            // Top Avatar Profile banner card
            ProfileAvatarBannerCard(
              fullName: currentUser?.fullName ?? "Administrator",
              email: currentUser?.email ?? "",
            ),
            const SizedBox(height: 16),

            // Real-time Success Notification Banner
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: showSuccessBanner && successMessage != null
                  ? Card(
                      key: const ValueKey('success_banner'),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              successMessage,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Section Title: Kontak
            Text(
              "Informasi Kontak",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 8),

            ContactInformationForm(
              initialName: currentUser?.fullName ?? "",
              initialEmail: currentUser?.email ?? "",
              initialPhone: currentUser?.phone ?? "",
              onSave: (name, email, phone) {
                ref.read(appViewModelProvider.notifier).updateContactInformation(
                      name,
                      email,
                      phone,
                    );
              },
            ),
            const SizedBox(height: 16),

            // Section Title: Kata Sandi
            Text(
              "Ubah Kata Sandi",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 8),

            ChangePasswordForm(
              onSave: (newPass) {
                ref.read(appViewModelProvider.notifier).updatePassword(newPass);
              },
            ),
            const SizedBox(height: 16),

            // Section Title: Keamanan Akun (2FA)
            Text(
              "Keamanan Akun & Otentikasi",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ProfileAvatarBannerCard widget implementation would go here
// ContactInformationForm widget implementation would go here
// ChangePasswordForm widget implementation would go here

// Providers would be defined elsewhere in your app
final currentUserProvider = Provider<User?>((ref) => null);
final profileSuccessMessageProvider = StateNotifierProvider<ProfileMessageNotifier, String?>(
  (ref) => ProfileMessageNotifier(),
);

class ProfileMessageNotifier extends StateNotifier<String?> {
  ProfileMessageNotifier() : super(null);

  void setMessage(String message) => state = message;
  void clearMessage() => state = null;
}