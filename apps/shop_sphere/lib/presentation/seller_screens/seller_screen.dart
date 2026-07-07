import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/theme/app_colors.dart';
import './widgets/filter_chip.dart';
import './widgets/seller_card.dart';
import './providers/seller_provider.dart';
import './models/seller_model.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => SellerProvider(),
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GUARDIAN CONSOLE',
                style: theme.textTheme.bodySmall?.copyWith(color: primary, letterSpacing: 1.1),
              ),
              Text('SecurApp Admin', style: theme.textTheme.titleLarge?.copyWith(color: textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: textSecondary, size: 28),
                  onPressed: () {},
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: background, width: 2),
                    ),
                    child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                )
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari nama, toko, atau email...',
                        hintStyle: const TextStyle(color: textSecondary),
                        prefixIcon: const Icon(Icons.search, color: textSecondary),
                        filled: true,
                        fillColor: surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.person_add_alt_1_outlined, color: textPrimary),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  FilterChipWidget(label: 'Semua', isSelected: true, onSelected: (value) {}),
                  const SizedBox(width: 8),
                  FilterChipWidget(label: 'Aktif', isSelected: false, onSelected: (value) {}),
                  const SizedBox(width: 8),
                  FilterChipWidget(label: 'Tidak Aktif', isSelected: false, onSelected: (value) {}),
                  const SizedBox(width: 8),
                  FilterChipWidget(label: 'Banned', isSelected: false, onSelected: (value) {}),
                ],
              ),
              const SizedBox(height: 24),
              Consumer<SellerProvider>(
                builder: (context, provider, child) {
                  return Text('Ditemukan ${provider.sellers.length} Penjual', style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary));
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<SellerProvider>(
                  builder: (context, provider, child) {
                    return ListView.builder(
                      itemCount: provider.sellers.length,
                      itemBuilder: (context, index) {
                        Seller seller = provider.sellers[index];
                        return SellerCard(
                          initial: seller.initial,
                          name: seller.name,
                          store: seller.store,
                          email: seller.email,
                          phone: seller.phone,
                          status: seller.status,
                          reason: seller.reason,
                          isBanned: seller.isBanned,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
