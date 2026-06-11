import 'package:flutter/material.dart';

import '../../app/aurae_app.dart';
import '../../app/aurae_theme.dart';
import '../../core/models/aurae_models.dart';
import '../../core/stylist/rule_based_stylist.dart';
import '../../core/widgets/aurae_widgets.dart';

class StylistScreen extends StatefulWidget {
  const StylistScreen({super.key});

  @override
  State<StylistScreen> createState() => _StylistScreenState();
}

class _StylistScreenState extends State<StylistScreen> {
  String occasion = 'Dinner';
  String aesthetic = 'Quiet Luxury';
  OutfitRecommendation? recommendation;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final Indonesian = controller.isIndonesian;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 8),
            child: Row(
              children: [
                const AuraeBrand(compact: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Stylist',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        Indonesian
                            ? 'Rule-based · Online'
                            : 'Rule-based · Online',
                        style: const TextStyle(color: AuraeColors.muted),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * .78,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AuraeColors.rose,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                        bottomLeft: Radius.circular(26),
                      ),
                    ),
                    child: Text(
                      Indonesian
                          ? 'Aku akan makan malam di rooftop. Aku ingin terlihat elegan tetapi tetap santai.'
                          : 'I am heading to a rooftop dinner. I want something elegant but still relaxed.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Casual', 'Work', 'Dinner', 'Event']
                      .map(
                        (value) => ChoiceChip(
                          label: Text(value),
                          selected: occasion == value,
                          onSelected: (_) => setState(() => occasion = value),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: ['Quiet Luxury', 'Minimalist', 'Classic']
                      .map(
                        (value) => ChoiceChip(
                          label: Text(value),
                          selected: aesthetic == value,
                          onSelected: (_) => setState(() => aesthetic = value),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => setState(() {
                    recommendation = RuleBasedStylist.recommend(
                      wardrobe: controller.wardrobe,
                      occasion: occasion,
                      aesthetic: aesthetic,
                      Indonesian: Indonesian,
                    );
                  }),
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(
                    Indonesian ? 'Susun rekomendasi' : 'Create recommendation',
                  ),
                ),
                if (recommendation != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AuraeColors.surface,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: AuraeColors.outline),
                    ),
                    child: Text(
                      recommendation!.explanation,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendation!.items.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final item = recommendation!.items[index];
                        return SizedBox(
                          width: 128,
                          child: Column(
                            children: [
                              Expanded(
                                child: FashionImage(
                                  url: item.imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      controller.saveLook(
                        SavedLook(
                          id: '$occasion-$aesthetic',
                          name: '$occasion · $aesthetic',
                          itemIds: recommendation!.items
                              .map((item) => item.id)
                              .toList(),
                          explanation: recommendation!.explanation,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            Indonesian ? 'Look disimpan' : 'Look saved',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: Text(
                      Indonesian ? 'Simpan look ini' : 'Save this look',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
