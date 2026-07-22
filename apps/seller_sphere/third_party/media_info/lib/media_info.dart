import 'dart:async';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class MediaInfo {
  static const MethodChannel _channel = MethodChannel('media_info');

  Future<Map<String, dynamic>> getMediaInfo(String filePath) async {
    try {
      final Map<String, dynamic>? result =
          await _channel.invokeMethod('getMediaInfo', {'filePath': filePath});
      return result ?? {};
    } on PlatformException catch (e) {
      logger.e("Failed to get media info: '${e.message}'.");
      return {};
    }
  }
}
