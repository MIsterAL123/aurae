import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/aurae_app.dart';
import '../../app/aurae_theme.dart';
import '../../core/models/aurae_models.dart';
import '../../core/widgets/aurae_widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String category = 'All';

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final Indonesian = controller.isIndonesian;
    final products = category == 'All'
        ? seedProducts
        : seedProducts
              .where((product) => product.category == category)
              .toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
            sliver: SliverList.list(
              children: [
                const Center(child: AuraeBrand(compact: true)),
                const SizedBox(height: 30),
                Text(
                  Indonesian ? 'Pilihan untukmu' : 'Curated for you',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  Indonesian
                      ? 'Berdasarkan aura dan koleksimu'
                      : 'Based on your aura and closet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AuraeColors.muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Quiet Luxury', 'Minimalist', 'Coastal']
                        .map(
                          (value) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(value),
                              selected: category == value,
                              onSelected: (_) =>
                                  setState(() => category = value),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 18),
                ...products.map(
                  (product) => Padding(
                    padding: const EdgeInsets.only(bottom: 34),
                    child: _ProductCard(
                      product: product,
                      favorite: controller.favoriteProductIds.contains(
                        product.id,
                      ),
                      onFavorite: () =>
                          controller.toggleProductFavorite(product.id),
                      Indonesian: Indonesian,
                    ),
                  ),
                ),
                Text(
                  Indonesian
                      ? 'Aurae dapat menerima komisi dari tautan marketplace. Harga dan ketersediaan mengikuti marketplace.'
                      : 'Aurae may earn a commission from marketplace links. Price and availability are determined by the marketplace.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AuraeColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.favorite,
    required this.onFavorite,
    required this.Indonesian,
  });

  final ProductItem product;
  final bool favorite;
  final VoidCallback onFavorite;
  final bool Indonesian;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: .78,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FashionImage(url: product.imageUrl),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton.filledTonal(
                  onPressed: onFavorite,
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite ? Colors.red.shade700 : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 2,
                      color: AuraeColors.muted,
                    ),
                  ),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Text(product.price, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => launchUrl(
            Uri.parse(
              'https://www.tokopedia.com/search?q=${Uri.encodeComponent(product.name)}',
            ),
            mode: LaunchMode.externalApplication,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: AuraeColors.terracotta,
          ),
          child: Text(Indonesian ? 'Lihat di Tokopedia' : 'View on Tokopedia'),
        ),
      ],
    );
  }
}
