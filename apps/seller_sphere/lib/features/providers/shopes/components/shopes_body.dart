import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/features/providers/shopes/providers/shopes_viewmodel.dart';
import 'shope_item_card.dart';

/// Komponen body untuk menampilkan daftar pelanggan.
class ShopesBody extends StatefulWidget {
  const ShopesBody({super.key});

  @override
  State<ShopesBody> createState() => _ShopesBodyState();
}

class _ShopesBodyState extends State<ShopesBody> {
  @override
  void initState() {
    super.initState();
    // Memuat data pelanggan saat widget pertama kali dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopesViewModel>().fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopesViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: viewModel.customers.length,
          itemBuilder: (context, index) => ShopeItemCard(user: viewModel.customers[index]),
        );
      },
    );
  }
}