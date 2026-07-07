import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: surface,
      selectedColor: primary,
      labelStyle: TextStyle(color: isSelected ? textPrimary : textSecondary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: isSelected ? primary : border, width: 0.5),
      ),
      showCheckmark: false,
    );
  }
}
