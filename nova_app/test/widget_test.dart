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

  testWidgets('Search shows suggestions and filters preview results', (tester) async {
    await tester.pumpWidget(const NovaTubeApp());
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Flutter');
    await tester.pumpAndSettle();
    expect(find.text('Flutter app development'), findsOneWidget);

    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.textContaining('Results for'), findsOneWidget);
    expect(find.text('Build a beautiful Flutter app from scratch'), findsOneWidget);
    expect(find.text('Artificial Intelligence explained simply'), findsNothing);
  });
}
