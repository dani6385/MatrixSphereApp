// lib/screens/transaction/widgets/transaction_history_body.dart
import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:seller_sphere/models/transaction.dart' ;
import 'transaction_list_item.dart';

class TransactionHistoryBody extends StatelessWidget {
  final Query query;
  final String? selectedType;

  const TransactionHistoryBody({
    super.key,
    required this.query,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: query,
      reverse: true, // Membalik urutan agar transaksi terbaru berada di atas
      defaultChild: const Center(child: CircularProgressIndicator()),
      itemBuilder: (context, snapshot, animation, index) {
        if (!snapshot.exists) {
          return const Center(child: Text('Belum ada transaksi.'));
        }
        final transaction = Transaction.fromSnapshot(snapshot);

        // Terapkan filter tipe di sisi client
        if (selectedType != null && transaction.type.toUpperCase() != selectedType) {
          return const SizedBox.shrink();
        }

        return FadeTransition(
          opacity: animation,
          child: TransactionListItem(transaction: transaction),
        );
      },
    );
  }
}