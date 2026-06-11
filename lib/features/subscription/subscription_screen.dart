import 'package:flutter/material.dart';

import '../../app/aurae_app.dart';
import '../../app/aurae_theme.dart';
import '../../core/payment/payment_models.dart';
import '../payment/payment_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  static const routeName = '/subscription';

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selected = 1;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final Indonesian = controller.isIndonesian;
    final features = [
      (
        Icons.auto_awesome,
        Indonesian ? 'Styling tanpa batas' : 'Unlimited styling',
      ),
      (
        Icons.diamond_outlined,
        Indonesian ? 'Koleksi eksklusif' : 'Exclusive collections',
      ),
      (Icons.trending_up, Indonesian ? 'Akses lebih awal' : 'Early access'),
      (
        Icons.block,
        Indonesian ? 'Pengalaman bebas iklan' : 'Ad-free experience',
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('AURAE')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        children: [
          Text(
            Indonesian ? 'Buka seluruh auramu' : 'Unlock your full aura',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 12),
          Text(
            Indonesian
                ? 'Nikmati perjalanan gaya yang lebih personal dan tanpa batas.'
                : 'Experience a more personal and limitless style journey.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AuraeColors.muted),
          ),
          const SizedBox(height: 38),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Row(
                children: [
                  Icon(feature.$1),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      feature.$2,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            Indonesian ? 'Pilih paketmu' : 'Select your plan',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 18),
          ...List.generate(
            premiumPlans.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => setState(() => selected = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: selected == index
                        ? AuraeColors.rose
                        : AuraeColors.surface,
                    border: Border.all(
                      color: selected == index
                          ? AuraeColors.ink
                          : AuraeColors.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          premiumPlans[index].name.toUpperCase(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Text(
                        '${premiumPlans[index].formattedPrice}${premiumPlans[index].periodLabel(Indonesian)}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: controller.isPremium
                ? null
                : () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          PaymentScreen(plan: premiumPlans[selected]),
                    ),
                  ),
            child: Text(
              controller.isPremium
                  ? (Indonesian ? 'Premium aktif' : 'Premium active')
                  : (Indonesian
                        ? 'Lanjut ke pembayaran'
                        : 'Continue to payment'),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            Indonesian
                ? 'Metode pembayaran produksi akan mengikuti kebijakan distribusi Android dan konfigurasi gateway.'
                : 'Production payment methods will follow Android distribution policy and gateway configuration.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AuraeColors.muted),
          ),
        ],
      ),
    );
  }
}
