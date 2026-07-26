import 'package:flutter/material.dart';

class InventoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<String> onSearchChanged;

  const InventoryAppBar({
    super.key,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Inventaris'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(68.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: SizedBox(
            height: 52,
            child: TextField(
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                hintText: "Cari berdasarkan nama atau SKU...",
                hintStyle: TextStyle(fontSize: 13),
                prefixIcon: Icon(Icons.search, size: 18),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 68.0);
}