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
  _DailyTargetDialogState createState() => _DailyTargetDialogState();
}

class _DailyTargetDialogState extends State<DailyTargetDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentTarget.toStringAsFixed(0));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Target Hari Ini'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Target Penjualan',
          prefixText: 'Rp. ',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            final newTarget = double.tryParse(_controller.text);
            if (newTarget != null) {
              widget.viewModel.updateTodayTarget(newTarget);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
