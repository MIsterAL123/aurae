import 'package:flutter/material.dart';

import '../../app/aurae_app.dart';
import '../../app/aurae_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final selectedAesthetics = <String>{'Quiet Luxury', 'Minimalist'};
  final selectedColors = <String>{'Cream', 'Espresso'};
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final Indonesian = controller.isIndonesian;
    final pages = [
      _SelectionStep(
        title: Indonesian
            ? 'Seperti apa auramu?'
            : 'What feels like your aura?',
        subtitle: Indonesian
            ? 'Pilih gaya yang paling menarik perhatianmu.'
            : 'Choose the styles that naturally draw your attention.',
        options: const [
          'Quiet Luxury',
          'Minimalist',
          'Coastal',
          'Cottagecore',
          'Classic',
          'Streetwear',
        ],
        selected: selectedAesthetics,
      ),
      _SelectionStep(
        title: Indonesian ? 'Palet favoritmu' : 'Your favorite palette',
        subtitle: Indonesian
            ? 'Kami akan memakai warna ini untuk menyusun rekomendasi.'
            : 'We will use these colors when composing recommendations.',
        options: const ['Cream', 'Espresso', 'Sage', 'Rose', 'Navy', 'Black'],
        selected: selectedColors,
      ),
      _OccasionStep(Indonesian: Indonesian),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${page + 1} / ${pages.length}'),
        titleTextStyle: Theme.of(context).textTheme.labelLarge,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: pages[page],
              ),
            ),
            Row(
              children: [
                if (page > 0)
                  IconButton(
                    onPressed: () => setState(() => page--),
                    icon: const Icon(Icons.arrow_back),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      if (page < pages.length - 1) {
                        setState(() => page++);
                        return;
                      }
                      await controller.completeOnboarding(
                        aesthetics: selectedAesthetics.toList(),
                        preferredColors: selectedColors.toList(),
                      );
                    },
                    child: Text(
                      page == pages.length - 1
                          ? (Indonesian
                                ? 'Mulai perjalanan'
                                : 'Start the journey')
                          : (Indonesian ? 'Lanjutkan' : 'Continue'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionStep extends StatefulWidget {
  const _SelectionStep({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
  });

  final String title;
  final String subtitle;
  final List<String> options;
  final Set<String> selected;

  @override
  State<_SelectionStep> createState() => _SelectionStepState();
}

class _SelectionStepState extends State<_SelectionStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(widget.title),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 10),
        Text(
          widget.subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AuraeColors.muted),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: widget.options
              .map(
                (option) => FilterChip(
                  label: Text(option),
                  selected: widget.selected.contains(option),
                  onSelected: (selected) => setState(() {
                    selected
                        ? widget.selected.add(option)
                        : widget.selected.remove(option);
                  }),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _OccasionStep extends StatelessWidget {
  const _OccasionStep({required this.Indonesian});

  final bool Indonesian;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('occasions'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Indonesian
              ? 'Kapan kamu butuh bantuan?'
              : 'When do you need styling help?',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        Text(
          Indonesian
              ? 'Kamu tetap bisa mengubah pilihan ini kapan saja.'
              : 'You can change these preferences at any time.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AuraeColors.muted),
        ),
        const SizedBox(height: 28),
        ...[
          (
            Icons.work_outline,
            Indonesian ? 'Kerja dan rapat' : 'Work and meetings',
          ),
          (Icons.restaurant_outlined, Indonesian ? 'Makan malam' : 'Dinner'),
          (
            Icons.celebration_outlined,
            Indonesian ? 'Acara spesial' : 'Special events',
          ),
          (
            Icons.wb_sunny_outlined,
            Indonesian ? 'Aktivitas santai' : 'Casual days',
          ),
        ].map(
          (item) => Card(
            elevation: 0,
            color: AuraeColors.surface,
            child: CheckboxListTile(
              value: true,
              onChanged: (_) {},
              secondary: Icon(item.$1),
              title: Text(item.$2),
            ),
          ),
        ),
      ],
    );
  }
}
