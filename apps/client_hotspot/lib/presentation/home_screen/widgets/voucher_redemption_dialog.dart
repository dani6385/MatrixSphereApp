import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/session_provider.dart';
import 'package:shared_ui/shared_ui.dart';

class VoucherRedemptionDialog extends StatefulWidget {
  const VoucherRedemptionDialog({super.key});

  @override
  State<VoucherRedemptionDialog> createState() => _VoucherRedemptionDialogState();
}

class _VoucherRedemptionDialogState extends State<VoucherRedemptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _voucherController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  Future<void> _redeemVoucher() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Panggil provider untuk menggunakan voucher
      await Provider.of<SessionProvider>(context, listen: false)
          .redeemVoucher(_voucherController.text.trim());

      if (mounted) {
        // Tampilkan notifikasi sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voucher berhasil digunakan! Data sesi diperbarui.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Tutup dialog setelah berhasil
      }
    } catch (e) {
      // Jika gagal, tampilkan pesan error di bawah field input
      setState(() {
        _errorMessage = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      // Hentikan loading indicator terlepas dari hasilnya
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Gunakan Voucher',
        style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Masukkan kode voucher Anda untuk menambah kuota atau memperpanjang paket.',
              style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _voucherController,
              textCapitalization: TextCapitalization.characters,
              onChanged: (_) {
                // Hapus pesan error saat pengguna mulai mengetik lagi
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'KODE-VOUCHER-ANDA',
                prefixIcon: const Icon(Icons.confirmation_number_outlined),
                errorText: _errorMessage,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Kode voucher tidak boleh kosong';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton.icon(
          onPressed: _isLoading ? null : _redeemVoucher,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
          ),
          icon: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.check_circle_outline, size: 18),
          label: Text(_isLoading ? 'Memproses...' : 'Gunakan'),
        ),
      ],
    );
  }
}