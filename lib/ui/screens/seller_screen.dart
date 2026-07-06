import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'seller_screen.dart';
import '../view_model/app_view_model.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../main.dart';

class SellerScreen extends ConsumerWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(appViewModelProvider);
    final sellers = ref.watch(sellersProvider);
    final searchQuery = ref.watch(sellerSearchQueryProvider);
    final filterStatus = ref.watch(sellerFilterStatusProvider);

    final showAddSellerDialog = ref.watch(showAddSellerDialogProvider);
    final sellerToBan = ref.watch(sellerToBanProvider);

    // Filter and search computation
    final filteredSellers = sellers.where((seller) {
      final matchQuery = seller.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          seller.storeName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          seller.email.toLowerCase().contains(searchQuery.toLowerCase());

      final matchStatus = switch (filterStatus) {
        "Aktif" => seller.status == "Aktif" && !seller.isBanned,
        "Tidak Aktif" => seller.status == "Tidak Aktif" && !seller.isBanned,
        "Banned" => seller.isBanned,
        _ => true, // "Semua"
      };

      return matchQuery && matchStatus;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Search and Add Header Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: searchQuery),
                      onChanged: (value) => ref.read(sellerSearchQueryProvider.notifier).state = value,
                      decoration: InputDecoration(
                        hintText: "Cari nama, toko, atau email...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceVariant),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  FloatingActionButton(
                    onPressed: () => ref.read(showAddSellerDialogProvider.notifier).state = true,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(Icons.person_add),
                  ),
                ],
              ),
            ),

            // Filter chips list
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  for (final status in ["Semua", "Aktif", "Tidak Aktif", "Banned"])
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(status),
                        selected: filterStatus == status,
                        onSelected: (selected) {
                          if (selected) {
                            ref.read(sellerFilterStatusProvider.notifier).state = status;
                          }
                        },
                        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: filterStatus == status
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Seller list
            Expanded(
              child: ListView.builder(
                itemCount: filteredSellers.length,
                itemBuilder: (context, index) {
                  final seller = filteredSellers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          seller.name[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      title: Text(
                        seller.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(seller.storeName),
                          Text(seller.email),
                          Text(
                            seller.status,
                            style: TextStyle(
                              color: seller.status == "Aktif"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Handle edit action
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.block),
                            onPressed: () {
                              ref.read(sellerToBanProvider.notifier).state = seller;
                              // Show ban confirmation dialog
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}