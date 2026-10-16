import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_ganadera/main.dart';

void main() {
  testWidgets('App should render without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GAVACApp());
    expect(find.text('GAVAC - Gestión Ganadera'), findsNothing);
  });
}
