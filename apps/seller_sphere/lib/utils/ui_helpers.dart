import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_sphere/widgets/image_picker_options.dart';

/// Menampilkan modal bottom sheet dengan opsi untuk memilih gambar dari kamera atau galeri.
///
/// [context] adalah BuildContext dari widget yang memanggil.
/// [onPick] adalah callback yang akan dieksekusi dengan [ImageSource] yang dipilih.
Future<void> showImagePickerOptions(
  BuildContext context, {
  required Function(ImageSource) onPick,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (ctx) => ImagePickerOptions(onPick: onPick),
  );
}