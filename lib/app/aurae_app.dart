import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/auth/welcome_screen.dart';
import '../features/moodboard/moodboard_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/shell/main_shell.dart';
import '../features/subscription/subscription_screen.dart';
import 'app_controller.dart';
import 'aurae_theme.dart';

class AuraeApp extends StatelessWidget {
  const AuraeApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return AppScope(
          controller: controller,
          child: MaterialApp(
            title: 'Aurae',
            debugShowCheckedModeBanner: false,
            theme: AuraeTheme.light(),
            locale: controller.locale,
            supportedLocales: const [Locale('id'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: !controller.authenticationReady
                ? const _AuthenticationSplash()
                : !controller.isAuthenticated
                ? const WelcomeScreen()
                : controller.onboardingCompleted
                ? const MainShell()
                : const OnboardingScreen(),
            routes: {
              MoodboardScreen.routeName: (_) => const MoodboardScreen(),
              SubscriptionScreen.routeName: (_) => const SubscriptionScreen(),
            },
          ),
        );
      },
    );
  }
}

class _AuthenticationSplash extends StatelessWidget {
  const _AuthenticationSplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    super.key,
    required AppController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this context.');
    return scope!.notifier!;
  }
}
