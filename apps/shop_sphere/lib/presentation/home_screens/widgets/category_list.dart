import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String iconAsset; // atau iconData jika menggunakan Icons

  CategoryModel({required this.id, required this.name, required this.iconAsset});
}

class CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(String) onCategorySelected;

  const CategoryList({
    super.key, 
    required this.categories, 
    required this.onCategorySelected
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Sesuaikan tinggi sesuai kebutuhan
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => onCategorySelected(category.id),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4)],
                  ),
                  child: Image.asset(category.iconAsset, width: 30, height: 30),
                ),
                const SizedBox(height: 8),
                Text(category.name, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}