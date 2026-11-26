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
}
