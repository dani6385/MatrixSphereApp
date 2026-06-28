import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:client_hotspot/routes/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';

class VoucherInputDialog extends StatefulWidget {
  const VoucherInputDialog({super.key});

  @override
  State<VoucherInputDialog> createState() => _VoucherInputDialogState();
}

class _VoucherInputDialogState extends State<VoucherInputDialog> {
  bool _isLoading = false;

  void _redeemVoucher() async {
    setState(() => _isLoading = true);
    // Simulasi redeem voucher
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go(AppRoutes.homeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.7,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Text(
                  'Masukkan Kode Voucher',
                  style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                textAlign: TextAlign.center,
                style: GoogleFonts.sourceCodePro(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Kode Voucher',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _isLoading ? null : _redeemVoucher,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          'Gunakan',
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}