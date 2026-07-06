import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';

class BayarQrTabWidget extends StatefulWidget {
  /// Jika true, widget ditampilkan di dalam dialog.
  /// Ini akan menutup dialog saat berhasil, bukan menavigasi.
  final bool isPopupMode;

  const BayarQrTabWidget({super.key, this.isPopupMode = false});

  /// Menampilkan widget ini sebagai dialog popup.
  static Future<void> showAsDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => const AlertDialog(
        title: Text('Bayar dengan QR'),
        content: BayarQrTabWidget(isPopupMode: true),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
    if (result == true && context.mounted) {
      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Pembayaran berhasil! Anda sekarang terhubung.'),
            backgroundColor: Colors.green,
          ),
        );
      // Arahkan ke home
      context.go(AppRoutes.homeScreen);
    }
  }

  @override
  State<BayarQrTabWidget> createState() => _BayarQrTabWidgetState();
}

class _BayarQrTabWidgetState extends State<BayarQrTabWidget> {
  String _selectedPackage = '1 Jam - Rp 3.000';
  bool _isWaiting = false;

  final List<_PackageOption> _packages = const [
    _PackageOption(label: '1 Jam', price: 'Rp 3.000', duration: '1 Jam'),
    _PackageOption(label: '3 Jam', price: 'Rp 7.000', duration: '3 Jam'),
    _PackageOption(label: '1 Hari', price: 'Rp 15.000', duration: '1 Hari'),
    _PackageOption(label: '1 Minggu', price: 'Rp 50.000', duration: '1 Minggu'),
  ];

  Future<void> _checkPayment() async {
    setState(() => _isWaiting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isWaiting = false);
      if (widget.isPopupMode) {
        // Dalam mode popup, tutup dialog dan berikan flag sukses.
        Navigator.of(context).pop(true);
      } else {
        context.go(AppRoutes.homeScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Paket',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _packages.map((pkg) {
              final label = '${pkg.duration} - ${pkg.price}';
              final isSelected = _selectedPackage == label;
              return InkWell(
                onTap: () => setState(() => _selectedPackage = label),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        pkg.duration,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        pkg.price,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white.withAlpha(217)
                              : const Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // QR Code display
          Center(
            child: Column(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_2_rounded,
                        size: 120,
                        color: const Color(0xFF1A1A1A),
                      ),
                      Text(
                        'QRIS',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _selectedPackage,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bayar dengan aplikasi e-wallet / m-banking',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _isWaiting ? null : _checkPayment,
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isWaiting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
                    ),
              label: Text(
                _isWaiting ? 'Memeriksa pembayaran...' : 'Sudah Bayar',
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
  }
}

class _PackageOption {
  final String label;
  final String price;
  final String duration;
  const _PackageOption({
    required this.label,
    required this.price,
    required this.duration,
  });
}
