import 'package:flutter/material.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';

class DailyTargetDialog extends StatefulWidget {
  final AppViewModel viewModel;
  final double currentTarget;

  const DailyTargetDialog({
    super.key,
    required this.viewModel,
    required this.currentTarget,
  });

  @override
  State<DailyTargetDialog> createState() => _DailyTargetDialogState();
}

class _DailyTargetDialogState extends State<DailyTargetDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentTarget.toInt().toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text(
        "Atur Target Penjualan Harian",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Target Rp",
          prefixText: "Rp ",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () {
            final newTarget = double.tryParse(_controller.text) ?? widget.currentTarget;
            widget.viewModel.updateTodayTarget(newTarget);
            Navigator.of(context).pop();
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
