import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class VerificationTabSelector extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int> onTabSelected;
  const VerificationTabSelector({super.key, required this.activeTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          Expanded(flex: 12, child: _TabButton(text: "Kamera Real-time 📷", isActive: activeTab == 1, onTap: () => onTabSelected(1))),
          Expanded(flex: 10, child: _TabButton(text: "Manual & Simulasi", isActive: activeTab == 0, onTap: () => onTabSelected(0))),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;
  const _TabButton({required this.text, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: isActive ? const Color(0xFF334155) : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(vertical: 6)
      ),
      child: Text(text, style: TextStyle(color: isActive ? kNeonCyan : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
