// lib/screens/transaction/widgets/transaction_filter_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';

class TransactionFilterBottomSheet extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final String? initialSelectedType;
  final List<String> transactionTypes;
  final VoidCallback onReset;
  final void Function(DateTime? startDate, DateTime? endDate, String? selectedType) onApply;

  const TransactionFilterBottomSheet({
    super.key,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.initialSelectedType,
    required this.transactionTypes,
    required this.onReset,
    required this.onApply,
  });

  @override
  State<TransactionFilterBottomSheet> createState() => _TransactionFilterBottomSheetState();
}

class _TransactionFilterBottomSheetState extends State<TransactionFilterBottomSheet> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late String? _selectedType;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _selectedType = widget.initialSelectedType;
  }

  Widget _buildDatePickerField(BuildContext context, {required String label, DateTime? date, required ValueChanged<DateTime> onDateSelected}) {
    final format = DateFormat('d MMM yyyy');
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (pickedDate != null) onDateSelected(pickedDate);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        child: Text(date != null ? format.format(date) : 'Pilih tanggal'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Wrap(
        runSpacing: 16,
        children: [
          Text('Filter Transaksi', style: AppStyles.titleLarge),
          Row(
            children: [
              Expanded(
                child: _buildDatePickerField(
                  context,
                  label: 'Dari Tanggal',
                  date: _startDate,
                  onDateSelected: (date) => setState(() => _startDate = date),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDatePickerField(
                  context,
                  label: 'Sampai Tanggal',
                  date: _endDate,
                  onDateSelected: (date) => setState(() => _endDate = date),
                ),
              ),
            ],
          ),
          Text('Tipe Transaksi', style: AppStyles.bodyLarge),
          Wrap(
            spacing: 8.0,
            children: widget.transactionTypes.map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: _selectedType == type,
                onSelected: (isSelected) {
                  setState(() => _selectedType = isSelected ? type : null);
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  widget.onReset();
                  Navigator.of(context).pop();
                },
                child: const Text('Reset'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  widget.onApply(_startDate, _endDate, _selectedType);
                  Navigator.of(context).pop();
                },
                child: const Text('Terapkan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}