import 'package:aurae_app/core/models/aurae_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wardrobe item survives local JSON serialization', () {
    const original = WardrobeItem(
      id: 'local-1',
      name: 'Local Linen Shirt',
      category: WardrobeCategory.tops,
      color: Color(0xFFE8D8C5),
      imageUrl: 'file:///data/user/0/com.aurae.aurae_app/shirt.jpg',
      formality: 3,
      aesthetics: ['Minimalist', 'Quiet Luxury'],
    );

    final restored = WardrobeItem.fromJson(original.toJson());

    expect(restored.id, original.id);
    expect(restored.name, original.name);
    expect(restored.category, original.category);
    expect(restored.color, original.color);
    expect(restored.imageUrl, original.imageUrl);
    expect(restored.formality, original.formality);
    expect(restored.aesthetics, original.aesthetics);
    expect(restored.hasLocalImage, isTrue);
  });
}
