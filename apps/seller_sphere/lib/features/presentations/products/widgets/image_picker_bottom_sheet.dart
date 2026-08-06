// lib/features/products/presentation/widgets/image_picker_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBottomSheet {
  static void show(BuildContext context, Function(ImageSource source) onImageSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  onImageSelected(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () {
                  onImageSelected(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}