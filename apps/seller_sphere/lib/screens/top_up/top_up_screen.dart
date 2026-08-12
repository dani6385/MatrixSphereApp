import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../services/wallet_service.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _selectedChipIndex;
  bool _isLoading = false;
  final WalletService _walletService = WalletService();

  final List<int> _quickAmounts = [50000, 100000, 250000, 500000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onChipSelected(int index) {
    setState(() {
      _selectedChipIndex = index;
      _amountController.text = _quickAmounts[index].toString();
    });
  }

  Future<void> _submitTopUp() async {
    if (_formKey.currentState!.validate()) {
      final amount = int.tryParse(_amountController.text) ?? 0;

      setState(() => _isLoading = true);

      try {
        // Hardcode userId untuk sementara, idealnya didapat dari state otentikasi
        const userId = 'user_andi';
        await _walletService.processTopUp(userId: userId, amount: amount);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Top Up berhasil!'),
                backgroundColor: Colors.green),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(e.toString().replaceAll('Exception: ', '')),
                backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up Saldo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppStyles.defaultScreenPadding,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Jumlah Top Up',
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  if ((int.tryParse(value) ?? 0) < 10000) {
                    return 'Minimum Top Up adalah Rp 10.000';
                  }
                  return null;
                },
                onChanged: (_) => setState(() => _selectedChipIndex = null),
              ),
              const SizedBox(height: 24),
              const Text('Pilih Nominal Cepat:', style: AppStyles.bodyMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(_quickAmounts.length, (index) {
                  return ChoiceChip(
                    label: Text('Rp ${formatCurrency.format(_quickAmounts[index])}'),
                    selected: _selectedChipIndex == index,
                    onSelected: (_) => _onChipSelected(index),
                  );
                }),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitTopUp,
                style: AppStyles.filledButton,
                child: _isLoading
                    ? const SizedBox(
                        height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Konfirmasi Top Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}