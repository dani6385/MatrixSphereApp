import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

void main() {
  testWidgets('should return package name from method channel', (WidgetTester tester) async {
    // Bind the framework to the test engine.
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock the MethodChannel.
    const MethodChannel channel = MethodChannel('getPackageName');
    
    // Set a mock method call handler.
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getPackageName') {
        return 'com.example'; // Return a mock package name.
      }
      return null;
    });

    // The code that uses the method channel.
    final String? packageName = await channel.invokeMethod<String>('getPackageName');

    // Verify that the method channel was called and returned the expected value.
    expect(packageName, 'com.example');
  });
}
