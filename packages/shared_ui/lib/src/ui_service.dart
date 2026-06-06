library shared_ui;

import 'package:flutter/material.dart';
import 'dialogs/voucher_dialog.dart' as voucher_dialog;
import 'dialogs/member_form.dart' as member_form;
import 'dialogs/scanner_dialog.dart' as scanner_dialog;
import 'dialogs/kuota_dialog.dart' as kuota_dialog;
import 'dialogs/trial_dialog.dart' as trial_dialog;
// ... pastikan semua import dialog di sini benar

class UIService {
  static void showVoucherDialog(BuildContext context) => voucher_dialog.showVoucherDialog(context);
  static void showMemberForm(BuildContext context) => member_form.showMemberForm(context);
  static void showQRScanner(BuildContext context) => scanner_dialog.showQRScanner(context);
  static void showBeliKuota(BuildContext context) => kuota_dialog.showBeliKuota(context);
  static void showTrialDialog(BuildContext context) => trial_dialog.showTrialDialog(context);
}
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