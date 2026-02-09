// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:time_tracker/main.dart';

void main() {
  testWidgets('App launches and navigates to add screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TimeTrackerApp());

    // Home screen should show "Time Entries" title and an add FAB
    expect(find.text('Time Entries'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap FAB to open Add Time Entry screen
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Add Time Entry'), findsOneWidget);
  });
}
