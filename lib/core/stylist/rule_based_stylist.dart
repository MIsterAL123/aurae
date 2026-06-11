import '../models/aurae_models.dart';

class OutfitRecommendation {
  const OutfitRecommendation({
    required this.items,
    required this.score,
    required this.explanation,
  });

  final List<WardrobeItem> items;
  final int score;
  final String explanation;
}

abstract final class RuleBasedStylist {
  static OutfitRecommendation recommend({
    required List<WardrobeItem> wardrobe,
    required String occasion,
    required String aesthetic,
    required bool Indonesian,
  }) {
    final desiredFormality = switch (occasion) {
      'Dinner' || 'Work' => 4,
      'Event' => 5,
      _ => 2,
    };

    int score(WardrobeItem item) {
      final formalityScore =
          10 - ((item.formality - desiredFormality).abs() * 2);
      final aestheticScore = item.aesthetics.contains(aesthetic) ? 10 : 4;
      return formalityScore + aestheticScore;
    }

    WardrobeItem? bestOf(WardrobeCategory category) {
      final items = wardrobe.where((item) => item.category == category).toList()
        ..sort((a, b) => score(b).compareTo(score(a)));
      return items.firstOrNull;
    }

    final selected = <WardrobeItem?>[
      bestOf(WardrobeCategory.tops),
      bestOf(WardrobeCategory.bottoms),
      bestOf(WardrobeCategory.outerwear),
      bestOf(WardrobeCategory.shoes),
    ].whereType<WardrobeItem>().toList();

    final total = selected.fold<int>(0, (value, item) => value + score(item));
    final explanation = Indonesian
        ? 'Kombinasi ini menyeimbangkan tingkat formalitas untuk $occasion '
              'dengan palet netral dan karakter $aesthetic yang kamu pilih.'
        : 'This combination balances the formality needed for $occasion with '
              'a neutral palette and your selected $aesthetic character.';

    return OutfitRecommendation(
      items: selected,
      score: total,
      explanation: explanation,
    );
  }
}
