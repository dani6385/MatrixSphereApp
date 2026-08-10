// lib/screens/transaction/transaction_history_screen.dart
import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:flutter/material.dart';

import 'widgets/transaction_history_body.dart';
import 'widgets/transaction_filter_bottom_sheet.dart'; // Import komponen filter

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late Query _query;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedType;

  final List<String> _transactionTypes = ['TOP_UP', 'CASH', 'QRIS'];

  @override
  void initState() {
    super.initState();
    _resetQuery();
  }

  void _resetQuery() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedType = null;
      _query = FirebaseDatabase.instance.ref('transactions').orderByChild('timestamp');
    });
  }

  void _applyFilters(DateTime? startDate, DateTime? endDate, String? selectedType) {
    setState(() {
      _startDate = startDate;
      _endDate = endDate;
      _selectedType = selectedType;

      Query newQuery = FirebaseDatabase.instance.ref('transactions').orderByChild('timestamp');

      if (_startDate != null) {
        newQuery = newQuery.startAt(_startDate!.millisecondsSinceEpoch);
      }
      if (_endDate != null) {
        final endOfDay = _endDate!.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
        newQuery = newQuery.endAt(endOfDay.millisecondsSinceEpoch);
      }
      _query = newQuery;
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return TransactionFilterBottomSheet(
          initialStartDate: _startDate,
          initialEndDate: _endDate,
          initialSelectedType: _selectedType,
          transactionTypes: _transactionTypes,
          onReset: _resetQuery,
          onApply: _applyFilters,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: TransactionHistoryBody(
        query: _query,
        selectedType: _selectedType,
      ),
    );
  }
}