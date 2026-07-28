
import 'package:shared_ui/shared_ui.dart';
import 'package:flutter/material.dart';

class InventoryBody extends StatelessWidget {
  const InventoryBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.builder(
                  itemCount:10,
                  itemBuilder: (context, index) {
                    return Card(child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: kLightBackground,
                          borderRadius: BorderRadius.circular(AppSpacing.sm),
                        ),
                      ),
                      title: Text('Product Name $index'),                      subtitle: Text('Stock: ${10 + index}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: kLightTextPrimary),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}