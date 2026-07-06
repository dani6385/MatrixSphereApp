import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, String> package;

  const PaymentScreen({super.key, required this.package});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'GoPay', 'icon': Icons.account_balance_wallet},
    {'name': 'OVO', 'icon': Icons.payment},
    {'name': 'Dana', 'icon': Icons.credit_card},
    {'name': 'Bank Transfer', 'icon': Icons.transfer_within_a_station},
  ];

  void _onPayment() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih metode pembayaran.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Pop payment screen with a success result
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Package Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Paket: ${widget.package['name']}', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Kuota: ${widget.package['quota']}', style: GoogleFonts.dmSans(fontSize: 14)),
                      ],
                    ),
                    Text(widget.package['price']!, style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Payment Methods
            Text('Pilih Metode Pembayaran', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  return Card(
                    color: _selectedPaymentMethod == method['name'] ? AppColors.primary.withAlpha(26) : null,
                    child: ListTile(
                      leading: Icon(method['icon'] as IconData, color: AppColors.primary),
                      title: Text(method['name'] as String),
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = method['name'] as String;
                        });
                      },
                      trailing: _selectedPaymentMethod == method['name']
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _onPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isProcessing
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : Text('Bayar ${widget.package['price']}')
        ),
      ),
    );
  }
}
