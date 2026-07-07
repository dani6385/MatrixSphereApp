import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/seller.dart';
import '../viewmodels/app_view_model.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight - 20), // Top padding
            _SearchAndAddHeader(),
            const SizedBox(height: 8),
            _FilterChips(),
            const SizedBox(height: 12),
            _SellerCountIndicator(),
            const SizedBox(height: 12),
            Expanded(child: _SellerList()),
          ],
        ),
      ),
    );
  }
}

class _SearchAndAddHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context, listen: false);

    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: viewModel.setSellerSearchQuery,
            decoration: InputDecoration(
              hintText: "Cari nama, toko, atau email...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0), 
            ),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          onPressed: () => _showAddSellerDialog(context),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: const Icon(Icons.person_add),
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);
    const filters = ["Semua", "Aktif", "Tidak Aktif", "Banned"];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((status) {
          final selected = viewModel.sellerFilterStatus == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(status),
              selected: selected,
              onSelected: (isSelected) {
                if (isSelected) {
                  viewModel.setSellerFilterStatus(status);
                }
              },
              selectedColor: Theme.of(context).colorScheme.primary.withAlpha(15),
              labelStyle: TextStyle(
                color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SellerCountIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = Provider.of<AppViewModel>(context).sellers.length;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Ditemukan $count Penjual",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SellerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sellers = Provider.of<AppViewModel>(context).sellers;

    if (sellers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text("Tidak ada penjual yang cocok", style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: sellers.length,
      itemBuilder: (context, index) => _SellerRowItem(seller: sellers[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}



class _SellerRowItem extends StatelessWidget {
  final Seller seller;

  const _SellerRowItem({required this.seller});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tealColor = const Color(0xFF26A69A);

    final statusColor = seller.isBanned
        ? colorScheme.error
        : seller.status == "Aktif"
            ? tealColor
            : colorScheme.onSurfaceVariant;

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withAlpha(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: seller.isBanned ? colorScheme.error.withAlpha(3) : colorScheme.surfaceContainerHighest,
        ),
      ),
      color: seller.isBanned ? colorScheme.errorContainer.withAlpha(1) : colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: statusColor.withAlpha(15),
                  child: Text(
                    seller.name.isNotEmpty ? seller.name[0].toUpperCase() : '-',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(seller.name, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(Icons.storefront, size: 14, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(seller.storeName, style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildMenuButton(context, viewModel),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.email, seller.email, context),
                    const SizedBox(height: 4),
                    _buildInfoRow(Icons.phone, seller.contact, context),
                  ],
                ),
                _buildStatusBadge(context, statusColor),
              ],
            ),
            if (seller.isBanned && seller.banReason != null)
              _buildBanReason(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, AppViewModel viewModel) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'ban') {
          _showBanReasonDialog(context, seller);
        } else if (value == 'unban') {
          viewModel.unbanSeller(seller.id);
        } else if (value == 'delete') {
          viewModel.deleteSeller(seller.id);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        if (!seller.isBanned)
          PopupMenuItem<String>(
            value: 'ban',
            child: ListTile(
              leading: Icon(Icons.block, color: Theme.of(context).colorScheme.error),
              title: Text('Ban Seller', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          )
        else
          const PopupMenuItem<String>(
            value: 'unban',
            child: ListTile(
              leading: Icon(Icons.check_circle, color: Color(0xFF26A69A)),
              title: Text('Unban Seller', style: TextStyle(color: Color(0xFF26A69A))),
            ),
          ),
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
            title: Text('Hapus Permanen', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        seller.isBanned ? "BANNED" : seller.status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: statusColor),
      ),
    );
  }

  Widget _buildBanReason(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.error.withAlpha(5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, size: 14, color: colorScheme.error),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "Alasan: ${seller.banReason}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11, color: colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Dialogs
void _showAddSellerDialog(BuildContext context) {
  showDialog(context: context, builder: (ctx) => _AddSellerDialog());
}

class _AddSellerDialog extends StatefulWidget {
  @override
  __AddSellerDialogState createState() => __AddSellerDialogState();
}

class __AddSellerDialogState extends State<_AddSellerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _storeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Daftarkan Seller Baru", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Lengkap"), validator: (v) => v!.isEmpty ? "Wajib diisi" : null),
            TextFormField(controller: _storeController, decoration: const InputDecoration(labelText: "Nama Toko"), validator: (v) => v!.isEmpty ? "Wajib diisi" : null),
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email"), validator: (v) => v!.isEmpty ? "Wajib diisi" : null),
            TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: "Nomor Telepon")),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Batal")),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Provider.of<AppViewModel>(context, listen: false).addNewSeller({
                'name': _nameController.text,
                'storeName': _storeController.text,
                'email': _emailController.text,
                'contact': _phoneController.text,
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text("Daftarkan"),
        ),
      ],
    );
  }
}

void _showBanReasonDialog(BuildContext context, Seller seller) {
  showDialog(context: context, builder: (ctx) => _BanReasonDialog(seller: seller));
}

class _BanReasonDialog extends StatefulWidget {
  final Seller seller;
  const _BanReasonDialog({required this.seller});

  @override
  __BanReasonDialogState createState() => __BanReasonDialogState();
}

class __BanReasonDialogState extends State<_BanReasonDialog> {
  final _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tangguhkan Seller", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Konfirmasi pemblokiran toko '${widget.seller.storeName}'. Berikan alasan pemblokiran."),
          TextField(controller: _reasonController, decoration: const InputDecoration(labelText: "Alasan Pelanggaran")),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Batal")),
        ElevatedButton(
          onPressed: () {
            if (_reasonController.text.isNotEmpty) {
              Provider.of<AppViewModel>(context, listen: false).banSeller(widget.seller.id, _reasonController.text);
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          child: const Text("Tangguhkan"),
        ),
      ],
    );
  }
}
