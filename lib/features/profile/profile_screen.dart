import 'package:flutter/material.dart';

import '../../app/aurae_app.dart';
import '../../app/aurae_theme.dart';
import '../../core/widgets/aurae_widgets.dart';
import '../subscription/subscription_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final Indonesian = controller.isIndonesian;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 110),
        children: [
          Row(
            children: [
              const Icon(Icons.menu),
              const Expanded(child: Center(child: AuraeBrand(compact: true))),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          const SizedBox(height: 42),
          const CircleAvatar(
            radius: 50,
            backgroundColor: AuraeColors.rose,
            child: Icon(Icons.person, size: 54, color: AuraeColors.espresso),
          ),
          const SizedBox(height: 18),
          Text(
            controller.displayName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          if (controller.email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              controller.email,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AuraeColors.muted),
            ),
          ],
          Text(
            Indonesian
                ? 'Merangkai aura digitalmu.'
                : 'Curating your digital aura.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AuraeColors.muted),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Metric(
                value: '${controller.wardrobe.length}',
                label: Indonesian ? 'ITEM' : 'ITEMS',
              ),
              _Metric(
                value: '${controller.savedLooks.length}',
                label: Indonesian ? 'TERSIMPAN' : 'SAVED',
              ),
              const _Metric(value: '156', label: 'INSPIRATION'),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            Indonesian ? 'Koleksi terbaru' : 'Latest closet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .82,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.wardrobe.take(4).length,
            itemBuilder: (context, index) =>
                FashionImage(url: controller.wardrobe[index].imageUrl),
          ),
          const SizedBox(height: 34),
          _SettingsTile(
            icon: Icons.star_outline,
            label: controller.isPremium
                ? (Indonesian ? 'Premium aktif' : 'Premium active')
                : (Indonesian
                      ? 'Berlangganan Premium'
                      : 'Premium subscription'),
            onTap: () =>
                Navigator.pushNamed(context, SubscriptionScreen.routeName),
          ),
          _SettingsTile(
            icon: Icons.language,
            label: Indonesian ? 'Bahasa: Indonesia' : 'Language: English',
            onTap: () => controller.setLocale(Locale(Indonesian ? 'en' : 'id')),
          ),
          _SettingsTile(
            icon: Icons.help_outline,
            label: Indonesian ? 'Pusat bantuan' : 'Help center',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.logout,
            label: Indonesian ? 'Keluar' : 'Sign out',
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    Indonesian ? 'Keluar dari Aurae?' : 'Sign out of Aurae?',
                  ),
                  content: Text(
                    Indonesian
                        ? 'Foto wardrobe lokal tetap tersimpan di perangkat ini.'
                        : 'Local wardrobe photos will remain on this device.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(Indonesian ? 'Batal' : 'Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(Indonesian ? 'Keluar' : 'Sign out'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) await controller.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(letterSpacing: 1.3),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      shape: const Border(bottom: BorderSide(color: AuraeColors.outline)),
    );
  }
}
