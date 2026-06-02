import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manajemen User"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.sports_esports), text: "Paket Game"),
              Tab(icon: Icon(Icons.language), text: "Paket Web"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserList(category: 'game'),
            UserList(category: 'web'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddVoucherDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddVoucherDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quotaController = TextEditingController();
    String selectedCategory = 'game';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        // StatefulBuilder agar dropdown bisa update
        builder: (context, setState) => AlertDialog(
          title: const Text("Tambah Voucher Baru"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama User"),
              ),
              TextField(
                controller: quotaController,
                decoration: const InputDecoration(
                  labelText: "Total Kuota (MB)",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                // Ganti 'value' menjadi 'initialValue'
                initialValue: selectedCategory,
                items: ['game', 'web']
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // 1. Validasi input agar tidak kosong
                  if (nameController.text.isEmpty) return;

                  // 2. Simpan ke Firestore
                  await FirebaseFirestore.instance.collection('users').add({
                    'name': nameController.text.trim(),
                    'category': selectedCategory,
                    'quota': int.tryParse(quotaController.text) ?? 0,
                    'usage': 0, // Inisialisasi awal
                    'createdAt':
                        FieldValue.serverTimestamp(), // Sangat disarankan
                  });

                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  print("DETAIL ERROR: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget terpisah untuk daftar agar lebih rapi
class UserList extends StatelessWidget {
  final String category;
  const UserList({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error memuat data"));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Center(child: Text("Belum ada user"));

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: InkWell(
                child: ListTile(
                  onTap: () {
                    print("DEBUG: User ${data['name']} diketuk!");
                  },
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(data['name'] ?? 'Tanpa Nama'),
                  // ... sisanya
                ),
              ),
            );
          },
        );
      },
    );
  }
}
