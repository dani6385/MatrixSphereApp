import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

/// Instrumented test, which will execute on an Android device.
///
/// See [Flutter testing documentation](https://docs.flutter.dev/testing)
void main() {
  test('useAppContext', () async {
    // Context of the app under test.
    final appContext = TestWidgetsFlutterBinding.ensureInitialized();
    final packageName = await const MethodChannel('getPackageName')
        .invokeMethod<String>('getPackageName');

    expect(packageName, 'com.example');
  });
}

MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "getPackageName").setMethodCallHandler { call, result ->
    if (call.method == "getPackageName") {
        result.success(packageName)
    }
}