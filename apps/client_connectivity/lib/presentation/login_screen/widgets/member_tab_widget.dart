import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_services/shared_services.dart';
import '../../../providers/auth_provider.dart';
import '../../../routes/app_routes.dart';

class MemberTabWidget extends ConsumerStatefulWidget {
  final bool isPopupMode;

  const MemberTabWidget({super.key, this.isPopupMode = false});

  static Future<void> showAsDialog(BuildContext context) async {
    // ... (kode dialog tetap sama)
  }

  @override
  ConsumerState<MemberTabWidget> createState() => _MemberTabWidgetState();
}

class _MemberTabWidgetState extends ConsumerState<MemberTabWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ref.read(authNotifierProvider.notifier).login(
          _usernameController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.loginProcessState is AuthLoading;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) async {
      final processState = next.loginProcessState;
      if (processState is AuthSuccess) {
        // Panggil service setelah login berhasil
        final ipSyncService = ref.read(ipSyncServiceProvider);
        final mikrotikConfig = MikroTikRestApiConfig(
          host: '192.168.88.1',
          username: 'api-user',
          password: 'api-password',
        );
        final response = await ipSyncService.syncIpAddress(
          mikrotikId: 'mikrotik_A_id',
          userId: 'user_123', // Ganti dengan ID pengguna yang sebenarnya
          mikrotikRestApiConfig: mikrotikConfig,
        );

        if (!context.mounted) return;
        final snackBar = SnackBar(
          content: Text('Status Sinkronisasi: ${response.status.name}'),
          backgroundColor:
              (response.status == IpSyncStatus.syncFailed) ? Colors.red : Colors.green,
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        if (widget.isPopupMode) {
          Navigator.of(context).pop(true);
        } else {
          context.go(AppRoutes.homeScreen);
        }
      } else if (processState is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(processState.message), backgroundColor: Colors.red),
        );
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Username tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            PasswordTextField(
              controller: _passwordController,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: _login,
              isLoading: isLoading,
              child: const Text('Login Member'),
            ),
          ],
        ),
      ),
    );
  }
}
