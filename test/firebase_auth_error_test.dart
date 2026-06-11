import 'package:aurae_app/core/auth/firebase_account_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps Firebase invalid credentials to Indonesian copy', () {
    final message = localizedAuthError(
      FirebaseAuthException(code: 'invalid-credential'),
      Indonesian: true,
    );

    expect(message, 'Email atau kata sandi salah.');
  });

  test('explains disabled Email/Password provider', () {
    final message = localizedAuthError(
      FirebaseAuthException(code: 'operation-not-allowed'),
      Indonesian: false,
    );

    expect(message, contains('Firebase Console'));
  });
}
