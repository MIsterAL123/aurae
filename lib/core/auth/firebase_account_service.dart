import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuraeUser {
  const AuraeUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.onboardingCompleted,
    required this.preferredLocale,
  });

  final String id;
  final String email;
  final String displayName;
  final bool onboardingCompleted;
  final String preferredLocale;
}

class FirebaseAccountService {
  FirebaseAccountService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  User? get currentFirebaseUser => _auth.currentUser;

  Future<AuraeUser?> restoreUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return _loadOrCreateProfile(firebaseUser);
  }

  Future<AuraeUser> register({
    required String name,
    required String email,
    required String password,
    required String locale,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final firebaseUser = credential.user!;
    await firebaseUser.updateDisplayName(name.trim());

    final profile = AuraeUser(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? email.trim(),
      displayName: name.trim(),
      onboardingCompleted: false,
      preferredLocale: locale,
    );
    await _userDocument(firebaseUser.uid).set({
      'displayName': profile.displayName,
      'email': profile.email,
      'preferredLocale': locale,
      'onboardingCompleted': false,
      'subscriptionTier': 'free',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return profile;
  }

  Future<AuraeUser> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _loadOrCreateProfile(credential.user!);
  }

  Future<void> markOnboardingCompleted({
    required List<String> aesthetics,
    required List<String> preferredColors,
    required String locale,
  }) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return;

    final batch = _firestore.batch();
    batch.set(_userDocument(firebaseUser.uid), {
      'onboardingCompleted': true,
      'preferredLocale': locale,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    batch.set(
      _userDocument(firebaseUser.uid).collection('preferences').doc('main'),
      {
        'aesthetics': aesthetics,
        'preferredColors': preferredColors,
        'commonOccasions': ['work', 'dinner', 'event', 'casual'],
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    await batch.commit();
  }

  Future<void> updateLocale(String locale) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return;
    await _userDocument(firebaseUser.uid).set({
      'preferredLocale': locale,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> signOut() => _auth.signOut();

  Future<AuraeUser> _loadOrCreateProfile(User firebaseUser) async {
    final reference = _userDocument(firebaseUser.uid);
    final snapshot = await reference.get();
    final data = snapshot.data();

    if (data == null) {
      final profile = AuraeUser(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? 'Aurae User',
        onboardingCompleted: false,
        preferredLocale: 'id',
      );
      await reference.set({
        'displayName': profile.displayName,
        'email': profile.email,
        'preferredLocale': profile.preferredLocale,
        'onboardingCompleted': false,
        'subscriptionTier': 'free',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return profile;
    }

    return AuraeUser(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? data['email'] as String? ?? '',
      displayName:
          data['displayName'] as String? ??
          firebaseUser.displayName ??
          'Aurae User',
      onboardingCompleted: data['onboardingCompleted'] as bool? ?? false,
      preferredLocale: data['preferredLocale'] as String? ?? 'id',
    );
  }

  DocumentReference<Map<String, dynamic>> _userDocument(String userId) {
    return _firestore.collection('users').doc(userId);
  }
}

String localizedAuthError(Object error, {required bool Indonesian}) {
  if (error is! FirebaseAuthException) {
    return Indonesian
        ? 'Terjadi masalah. Periksa koneksi lalu coba lagi.'
        : 'Something went wrong. Check your connection and try again.';
  }

  return switch (error.code) {
    'invalid-email' =>
      Indonesian
          ? 'Format email tidak valid.'
          : 'The email address is invalid.',
    'email-already-in-use' =>
      Indonesian
          ? 'Email ini sudah digunakan.'
          : 'This email is already in use.',
    'weak-password' =>
      Indonesian
          ? 'Kata sandi minimal 6 karakter.'
          : 'The password must contain at least 6 characters.',
    'user-not-found' || 'wrong-password' || 'invalid-credential' =>
      Indonesian
          ? 'Email atau kata sandi salah.'
          : 'The email or password is incorrect.',
    'too-many-requests' =>
      Indonesian
          ? 'Terlalu banyak percobaan. Coba lagi nanti.'
          : 'Too many attempts. Try again later.',
    'network-request-failed' =>
      Indonesian
          ? 'Tidak dapat terhubung ke internet.'
          : 'Unable to connect to the internet.',
    'operation-not-allowed' =>
      Indonesian
          ? 'Email/Password belum diaktifkan di Firebase Console.'
          : 'Email/Password is not enabled in Firebase Console.',
    _ =>
      Indonesian
          ? 'Autentikasi gagal (${error.code}).'
          : 'Authentication failed (${error.code}).',
  };
}
