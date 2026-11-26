import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novatube_app/app/nova_app.dart';

void main() {
  testWidgets('NovaTube opens with five-tab navigation', (tester) async {
    await tester.pumpWidget(const NovaTubeApp());
    expect(find.text('NovaTube'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Search shows suggestions and filters preview results',
      (tester) async {
    await tester.pumpWidget(const NovaTubeApp());
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Flutter');
    await tester.pumpAndSettle();
    expect(find.text('Flutter app development'), findsOneWidget);

    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.textContaining('Results for'), findsOneWidget);
    expect(find.text('Build a beautiful Flutter app from scratch'),
        findsOneWidget);
    expect(find.text('Artificial Intelligence explained simply'), findsNothing);
  });
  testWidgets('Search result opens responsive video details', (tester) async {
    await tester.view.physicalSize = const Size(900, 1600);
    await tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NovaTubeApp());
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Flutter');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Build a beautiful Flutter app from scratch'));
    await tester.pumpAndSettle();

    expect(find.text('Video details'), findsOneWidget);
    expect(find.text('About this video'), findsOneWidget);
    expect(find.text('Chapters'), findsOneWidget);
    expect(find.text('Up next'), findsOneWidget);
  });
}
