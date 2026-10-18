import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_ganadera/main.dart';
import 'package:gestion_ganadera/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('GAVACApp renders LoginScreen initially', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GAVACApp());

    // Verify that LoginScreen is rendered
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Entrar al Sistema'), findsOneWidget);
  });
}
