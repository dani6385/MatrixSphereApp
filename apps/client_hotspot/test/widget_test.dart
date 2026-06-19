import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../main.dart';

void main() {
  testWidgets('HomeScreen displays error on connection failure', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // The app is initially in a loading state.
    expect(find.byType(CircularProgressIndicator), findsNWidgets(4));
    final initialFab = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
    expect(initialFab.onPressed, isNull);


    // Let the connection attempt fail.
    await tester.pumpAndSettle();

    // Verify that the error message is displayed.
    expect(find.textContaining('Connection Failed'), findsOneWidget);

    // Verify that the loading indicators are gone.
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify that the stat cards show 'N/A'.
    expect(find.text('N/A'), findsNWidgets(4));

    // The refresh button should be enabled now.
    final finalFab = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
    expect(finalFab.onPressed, isNotNull);
  });
}
