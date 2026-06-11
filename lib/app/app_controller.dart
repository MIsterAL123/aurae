import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/auth/firebase_account_service.dart';
import '../core/firebase/firebase_bootstrap.dart';
import '../core/models/aurae_models.dart';
import '../core/storage/local_wardrobe_storage.dart';

class AppController extends ChangeNotifier {
  static const _localeKey = 'locale';

  Locale locale = const Locale('id');
  bool onboardingCompleted = false;
  bool authenticationReady = false;
  bool authenticationBusy = false;
  bool isPremium = false;
  String? premiumPlanId;
  String? premiumTransactionId;
  AuraeUser? currentUser;
  String? authenticationError;
  final Set<String> favoriteProductIds = {};
  final List<SavedLook> savedLooks = [];
  final List<WardrobeItem> wardrobe = [...seedWardrobe];
  final LocalWardrobeStorage _wardrobeStorage = LocalWardrobeStorage();
  FirebaseAccountService? _accountService;

  bool get isIndonesian => locale.languageCode == 'id';
  bool get isAuthenticated => currentUser != null;
  String get displayName => currentUser?.displayName ?? 'Aura Putri';
  String get email => currentUser?.email ?? '';
  String get localStorageOwnerId => currentUser?.id ?? 'showcase';

  Future<void> restore() async {
    final preferences = await SharedPreferences.getInstance();
    locale = Locale(preferences.getString(_localeKey) ?? 'id');
    if (FirebaseBootstrap.initialized) {
      _accountService = FirebaseAccountService();
      try {
        currentUser = await _accountService!.restoreUser();
        if (currentUser != null) {
          onboardingCompleted = currentUser!.onboardingCompleted;
          locale = Locale(currentUser!.preferredLocale);
          await _loadWardrobeForCurrentUser();
        }
      } catch (error) {
        authenticationError = localizedAuthError(
          error,
          Indonesian: isIndonesian,
        );
      }
    }
    authenticationReady = true;
    notifyListeners();
  }

  Future<void> setLocale(Locale value) async {
    locale = value;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_localeKey, value.languageCode);
    await _accountService?.updateLocale(value.languageCode);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final service = _requireAccountService();
    await _runAuthentication(() async {
      currentUser = await service.register(
        name: name,
        email: email,
        password: password,
        locale: locale.languageCode,
      );
      onboardingCompleted = false;
      await _loadWardrobeForCurrentUser();
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    final service = _requireAccountService();
    await _runAuthentication(() async {
      currentUser = await service.signIn(email: email, password: password);
      onboardingCompleted = currentUser!.onboardingCompleted;
      locale = Locale(currentUser!.preferredLocale);
      await _loadWardrobeForCurrentUser();
    });
  }

  Future<void> completeOnboarding({
    required List<String> aesthetics,
    required List<String> preferredColors,
  }) async {
    await _accountService?.markOnboardingCompleted(
      aesthetics: aesthetics,
      preferredColors: preferredColors,
      locale: locale.languageCode,
    );
    onboardingCompleted = true;
    if (currentUser != null) {
      currentUser = AuraeUser(
        id: currentUser!.id,
        email: currentUser!.email,
        displayName: currentUser!.displayName,
        onboardingCompleted: true,
        preferredLocale: locale.languageCode,
      );
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _accountService?.signOut();
    currentUser = null;
    onboardingCompleted = false;
    isPremium = false;
    premiumPlanId = null;
    premiumTransactionId = null;
    authenticationError = null;
    wardrobe
      ..clear()
      ..addAll(seedWardrobe);
    notifyListeners();
  }

  Future<void> addWardrobeItem(WardrobeItem item) async {
    wardrobe.insert(0, item);
    notifyListeners();
    await _wardrobeStorage.saveItems(localStorageOwnerId, wardrobe);
  }

  Future<void> deleteWardrobeItem(WardrobeItem item) async {
    wardrobe.removeWhere((candidate) => candidate.id == item.id);
    notifyListeners();
    await _wardrobeStorage.deleteImage(item.imageUrl);
    await _wardrobeStorage.saveItems(localStorageOwnerId, wardrobe);
  }

  void toggleProductFavorite(String productId) {
    favoriteProductIds.contains(productId)
        ? favoriteProductIds.remove(productId)
        : favoriteProductIds.add(productId);
    notifyListeners();
  }

  void saveLook(SavedLook look) {
    if (savedLooks.any((item) => item.id == look.id)) return;
    savedLooks.insert(0, look);
    notifyListeners();
  }

  void activatePremium({
    required String planId,
    required String transactionId,
  }) {
    isPremium = true;
    premiumPlanId = planId;
    premiumTransactionId = transactionId;
    notifyListeners();
  }

  FirebaseAccountService _requireAccountService() {
    final service = _accountService;
    if (service == null) {
      throw StateError(
        isIndonesian
            ? 'Firebase belum siap. Jalankan ulang aplikasi dan periksa konfigurasi.'
            : 'Firebase is not ready. Restart the app and check its configuration.',
      );
    }
    return service;
  }

  Future<void> _runAuthentication(Future<void> Function() operation) async {
    authenticationBusy = true;
    authenticationError = null;
    notifyListeners();
    try {
      await operation();
    } catch (error) {
      authenticationError = error is StateError
          ? error.message.toString()
          : localizedAuthError(error, Indonesian: isIndonesian);
      rethrow;
    } finally {
      authenticationBusy = false;
      notifyListeners();
    }
  }

  Future<void> _loadWardrobeForCurrentUser() async {
    final localItems = await _wardrobeStorage.loadItems(localStorageOwnerId);
    wardrobe
      ..clear()
      ..addAll(localItems)
      ..addAll(seedWardrobe);
  }
}

class AppStrings {
  const AppStrings(this.id);

  final bool id;

  String get appTagline =>
      id ? 'Gaya personal, setiap hari.' : 'Personal style, every day.';
  String get continueLabel => id ? 'Lanjutkan' : 'Continue';
  String get signIn => id ? 'Masuk' : 'Sign in';
  String get register => id ? 'Daftar' : 'Register';
  String get home => id ? 'Beranda' : 'Home';
  String get closet => id ? 'Koleksi' : 'Closet';
  String get stylist => id ? 'Stylist' : 'Stylist';
  String get explore => id ? 'Jelajahi' : 'Explore';
  String get profile => id ? 'Profil' : 'Profile';
  String get savedLooks => id ? 'Look tersimpan' : 'Saved looks';
  String get viewAll => id ? 'Lihat semua' : 'View all';
  String get addItem => id ? 'Tambah item' : 'Add item';
  String get shopNow => id ? 'Lihat di marketplace' : 'View in marketplace';
}
