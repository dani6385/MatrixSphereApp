
import 'dart:io';
import 'package:flutter/services.dart';

class MediaInfo {
  static const MethodChannel _channel = MethodChannel('media_info');

  Future<Map<String, dynamic>> getMediaInfo(String filePath) async {
    if (!File(filePath).existsSync()) {
      throw ArgumentError('File does not exist at path: $filePath');
    }
    final Map<String, dynamic>? result =
        await _channel.invokeMethod('getMediaInfo', {'filePath': filePath});
    return result ?? {};
  }
}
