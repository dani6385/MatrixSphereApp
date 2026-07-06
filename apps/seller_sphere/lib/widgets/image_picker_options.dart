import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Widget helper untuk menampilkan opsi pilihan gambar (kamera/galeri).
///
/// Widget ini dirancang untuk digunakan di dalam `showModalBottomSheet`.
class ImagePickerOptions extends StatelessWidget {
  /// Callback yang dipanggil dengan [ImageSource] yang dipilih (kamera atau galeri).
  final Function(ImageSource) onPick;

  const ImagePickerOptions({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Ambil Foto'),
            onTap: () {
              Navigator.of(context).pop();
              onPick(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Pilih dari Galeri'),
            onTap: () {
              Navigator.of(context).pop();
              onPick(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Batal'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}