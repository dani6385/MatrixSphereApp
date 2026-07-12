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
    _controller = TextEditingController(text: widget.currentTarget.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Target Harian'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Target Penjualan Harian'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
        TextButton(
          onPressed: () {
            final newTarget = double.tryParse(_controller.text);
            if (newTarget != null) {
              widget.viewModel.setDailyTarget(newTarget);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
