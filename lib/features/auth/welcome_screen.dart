import 'package:flutter/material.dart';

import '../../app/app_controller.dart';
import '../../app/aurae_app.dart';
import '../../app/aurae_theme.dart';
import '../../core/widgets/aurae_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool showForm = false;
  bool registerMode = false;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final strings = AppStrings(controller.isIndonesian);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height - 72,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: SegmentedButton<String>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(value: 'id', label: Text('ID')),
                        ButtonSegment(value: 'en', label: Text('EN')),
                      ],
                      selected: {controller.locale.languageCode},
                      onSelectionChanged: (value) =>
                          controller.setLocale(Locale(value.first)),
                    ),
                  ),
                  const Spacer(),
                  const AuraeBrand(),
                  const SizedBox(height: 26),
                  Text(
                    strings.appTagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    controller.isIndonesian
                        ? 'Atur koleksimu, temukan kombinasi baru, dan bangun aura yang benar-benar milikmu.'
                        : 'Organize your wardrobe, discover new combinations, and build an aura that is truly yours.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AuraeColors.muted),
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: showForm
                        ? _AuthForm(
                            key: ValueKey(registerMode),
                            registerMode: registerMode,
                            Indonesian: controller.isIndonesian,
                            controller: controller,
                          )
                        : Column(
                            children: [
                              FilledButton(
                                onPressed: () => setState(() {
                                  showForm = true;
                                  registerMode = true;
                                }),
                                child: Text(strings.register),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton(
                                onPressed: () => setState(() {
                                  showForm = true;
                                  registerMode = false;
                                }),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(54),
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(strings.signIn),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthForm extends StatefulWidget {
  const _AuthForm({
    super.key,
    required this.registerMode,
    required this.Indonesian,
    required this.controller,
  });

  final bool registerMode;
  final bool Indonesian;
  final AppController controller;

  @override
  State<_AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<_AuthForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    try {
      if (widget.registerMode) {
        await widget.controller.register(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        await widget.controller.signIn(
          email: emailController.text,
          password: passwordController.text,
        );
      }
    } catch (_) {
      // AppController exposes a localized error below the fields.
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = widget.controller.authenticationBusy;
    return Form(
      key: formKey,
      child: Column(
        children: [
          if (widget.registerMode) ...[
            TextFormField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              decoration: InputDecoration(
                labelText: widget.Indonesian ? 'Nama' : 'Name',
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) {
                if ((value ?? '').trim().length < 2) {
                  return widget.Indonesian
                      ? 'Masukkan nama minimal 2 karakter.'
                      : 'Enter at least 2 characters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
          ],
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.mail_outline),
            ),
            validator: (value) {
              final email = (value ?? '').trim();
              if (!email.contains('@') || !email.contains('.')) {
                return widget.Indonesian
                    ? 'Masukkan email yang valid.'
                    : 'Enter a valid email.';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            autofillHints: widget.registerMode
                ? const [AutofillHints.newPassword]
                : const [AutofillHints.password],
            onFieldSubmitted: (_) {
              if (!busy) submit();
            },
            decoration: InputDecoration(
              labelText: widget.Indonesian ? 'Kata sandi' : 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => obscurePassword = !obscurePassword),
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            validator: (value) {
              if ((value ?? '').length < 6) {
                return widget.Indonesian
                    ? 'Kata sandi minimal 6 karakter.'
                    : 'Password must contain at least 6 characters.';
              }
              return null;
            },
          ),
          if (widget.controller.authenticationError != null) ...[
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              child: Text(
                widget.controller.authenticationError!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
          const SizedBox(height: 18),
          FilledButton(
            onPressed: busy ? null : submit,
            child: busy
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    widget.registerMode
                        ? (widget.Indonesian ? 'Buat akun' : 'Create account')
                        : (widget.Indonesian ? 'Masuk' : 'Sign in'),
                  ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: null,
            icon: const Icon(Icons.g_mobiledata, size: 28),
            label: Text(
              widget.Indonesian
                  ? 'Google Sign-In segera hadir'
                  : 'Google Sign-In coming soon',
            ),
          ),
        ],
      ),
    );
  }
}
