import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('My app has a title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('Hello'),
      ),
    ));

    expect(find.text('Hello'), findsOneWidget);
  });
}
