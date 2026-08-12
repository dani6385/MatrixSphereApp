
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/cashier_bottom_panel.dart';
import '../widgets/cashier_sort_dropdown.dart';
import '../widgets/cashier_cart_list.dart';
import '../mixins/cashier_actions_mixin.dart';

class CashierBody extends StatefulWidget {
  const CashierBody({super.key});

  @override
  State<CashierBody> createState() => _CashierBodyState();
}

class _CashierBodyState extends State<CashierBody> with CashierActionsMixin {
  @override
  void initState() {
    super.initState();
    logic.init(() => setState(() {}));
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTotal = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(logic.totalAmount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CashierSortDropdown(
          currentSortOption: logic.currentSortOption,
          onChanged: (val) =>
              logic.changeSortOption(val, () => setState(() {})),
        ),
        Expanded(
          child: CashierCartList(
            cartItems: logic.cartItems,
            onQuantityChanged: (index, newQty) {
              final err = logic.updateQuantity(index, newQty);
              if (err != null) showMsg(context, err);
              setState(() {});
            },
            onRemove: (index) {
              logic.removeItem(index);
              setState(() {});
            },
          ),
        ),
        CashierBottomPanel(
          searchController: logic.searchController,
          onSearchTap: () =>
              showProductSelection(context, () => setState(() {})),
          onScanBarcode: () => scanBarcode(context, () => setState(() {})),
          formattedTotal: formattedTotal,
          onProcessPayment: (method) =>
              processPayment(context, method, () => setState(() {})),
        ),
      ],
    );
  }
}