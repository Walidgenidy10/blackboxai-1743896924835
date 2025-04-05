import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hr_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('Successful login navigates to employee dashboard', 
    (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on login screen
      expect(find.text('HR Self-Service'), findsOneWidget);

      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('email')), 
        'test@example.com'
      );
      await tester.enterText(
        find.byKey(const Key('password')), 
        'password123'
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify navigation to employee dashboard
      expect(find.text('Employee Dashboard'), findsOneWidget);
    });

    testWidgets('Invalid login shows error message', 
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Attempt login with empty fields
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });
  });
}