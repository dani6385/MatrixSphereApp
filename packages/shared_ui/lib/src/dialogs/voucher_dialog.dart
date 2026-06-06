import 'package:flutter/material.dart';

void showVoucherDialog(BuildContext context) {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Masukkan Kode Voucher"),
        content: TextField(controller: controller, decoration: const InputDecoration(border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(onPressed: () {
            debugPrint("Voucher: ${controller.text}");
            Navigator.pop(context);
          }, child: const Text("Gunakan")),
        ],
      );
    },
  );
}