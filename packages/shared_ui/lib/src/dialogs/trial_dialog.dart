import 'package:flutter/material.dart';

void showTrialDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Mulai Trial"),
        content: const Text("Akses internet gratis 15 menit. Lanjutkan?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(onPressed: () {
            debugPrint("Trial diaktifkan");
            Navigator.pop(context);
          }, child: const Text("Mulai")),
        ],
      );
    },
  );
}