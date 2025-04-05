import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:hr_app/screens/auth/login_screen.dart';
import 'package:hr_app/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('HR Self-Service'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
  });

  testWidgets('LoginScreen shows validation errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('LoginScreen calls auth service on valid form', (WidgetTester tester) async {
    when(mockAuthService.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) async => null);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    verify(mockAuthService.signInWithEmailAndPassword(
      'test@example.com',
      'password123',
    )).called(1);
  });

  testWidgets('LoginScreen shows loading indicator', (WidgetTester tester) async {
    when(mockAuthService.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return null;
    });

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}