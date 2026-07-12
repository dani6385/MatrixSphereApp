import 'package:flutter/material.dart';

const Color darkBlueBackground = Color(0xFF0D1B2A);
const Color neonCyan = Color(0xFF26C6DA);

class DailyTargetDialog extends StatefulWidget {
  final double currentTarget;
  const DailyTargetDialog({super.key, required this.currentTarget});

  @override
  _DailyTargetDialogState createState() => _DailyTargetDialogState();
}

class _DailyTargetDialogState extends State<DailyTargetDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentTarget.toInt().toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: darkBlueBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Atur Target Penjualan Harian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: neonCyan)),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Target Rp",
          prefixText: "Rp ",
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: neonCyan)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Batal", style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
        ),
        TextButton(
          onPressed: () {
            // In a real app: context.read<AppViewModel>().updateTodayTarget(newTarget);
            Navigator.of(context).pop();
          },
          child: const Text("Simpan", style: TextStyle(color: neonCyan, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
