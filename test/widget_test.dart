import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_routing_demo/pages/sample_page.dart';

void main() {
  testWidgets('Sample page loads items and deletes them', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SamplePage(
          fetchItems: () async => [
            SampleItem(id: 1, title: 'First item', completed: false),
            SampleItem(id: 2, title: 'Second item', completed: true),
          ],
          deleteItem: (itemId) async {
            // no-op for a deterministic widget test
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('First item'), findsOneWidget);
    expect(find.text('Second item'), findsOneWidget);
    expect(find.text('Delete'), findsNWidgets(2));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Delete').first);
    await tester.pumpAndSettle();

    expect(find.text('Second item'), findsOneWidget);
    expect(find.text('First item'), findsNothing);
  });
}
