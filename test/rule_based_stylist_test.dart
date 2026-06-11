import 'package:aurae_app/core/models/aurae_models.dart';
import 'package:aurae_app/core/stylist/rule_based_stylist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RuleBasedStylist', () {
    test('returns a complete ranked combination from the seed wardrobe', () {
      final result = RuleBasedStylist.recommend(
        wardrobe: seedWardrobe,
        occasion: 'Dinner',
        aesthetic: 'Quiet Luxury',
        Indonesian: false,
      );

      expect(result.items, isNotEmpty);
      expect(
        result.items.map((item) => item.category),
        containsAll([
          WardrobeCategory.tops,
          WardrobeCategory.bottoms,
          WardrobeCategory.outerwear,
          WardrobeCategory.shoes,
        ]),
      );
      expect(result.score, greaterThan(0));
      expect(result.explanation, contains('Dinner'));
    });

    test('returns an Indonesian explanation when requested', () {
      final result = RuleBasedStylist.recommend(
        wardrobe: seedWardrobe,
        occasion: 'Work',
        aesthetic: 'Minimalist',
        Indonesian: true,
      );

      expect(result.explanation, contains('Kombinasi'));
    });
  });
}
