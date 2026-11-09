import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_ganadera/main.dart';
import 'package:gestion_ganadera/screens/login_screen.dart';
import 'package:gestion_ganadera/screens/reproduccion_screen.dart';
import 'package:gestion_ganadera/config/gavac_colors.dart';
import 'package:gestion_ganadera/config/gavac_theme.dart';

void main() {
  testWidgets('GAVACApp renders LoginScreen initially',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GAVACApp());

    // Verify that LoginScreen is rendered
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Entrar al Sistema'), findsOneWidget);
  });

  testWidgets('Reproduction screen renders without layout errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReproduccionScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Control de Eventos Reproductivos'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('login text remains readable when the system theme is dark',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: GavacTheme.darkTheme,
        home: const LoginScreen(),
      ),
    );

    final emailInput = find.byType(TextField).first;
    await tester.enterText(emailInput, 'ganadero@example.com');
    await tester.pump();

    final field = tester.widget<TextField>(emailInput);
    expect(field.style?.color, GavacColors.textPrimary);
    expect(field.cursorColor, GavacColors.primary);
  });
}
