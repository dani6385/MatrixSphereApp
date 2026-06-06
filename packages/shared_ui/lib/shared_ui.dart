library shared_ui;
import 'package:flutter/material.dart';

export 'src/dialogs/voucher_dialog.dart';
export 'src/dialogs/member_form.dart';
export 'src/widgets/bottom_navbar.dart';
export 'src/widgets/qr_scanner.dart';
export 'src/ui_service.dart';

// Di packages/shared_ui/lib/src/widgets/menu_button.dart
class MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const MenuButton({super.key, required this.title, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon), const SizedBox(height: 4), Text(title)],
      ),
    );
  }
}