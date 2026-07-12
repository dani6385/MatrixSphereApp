import 'package:flutter/material.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';

class DailyTargetDialog extends StatefulWidget {
  final AppViewModel viewModel;
  final double currentTarget;

  const DailyTargetDialog(
      {super.key, required this.viewModel, required this.currentTarget});

  @override
  _DailyTargetDialogState createState() => _DailyTargetDialogState();
}

class _DailyTargetDialogState extends State<DailyTargetDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.currentTarget.toInt().toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      title: const Text("Atur Target Penjualan Harian"),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          prefixText: "Rp ",
          labelText: "Target Rp",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () {
            final amount = double.tryParse(_controller.text) ?? 0.0;
            widget.viewModel.updateTodayTarget(amount);
            Navigator.of(context).pop();
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
