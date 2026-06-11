import 'package:flutter/material.dart';

enum WardrobeCategory { tops, bottoms, dresses, outerwear, shoes, bags }

class WardrobeItem {
  const WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.imageUrl,
    required this.formality,
    required this.aesthetics,
  });

  final String id;
  final String name;
  final WardrobeCategory category;
  final Color color;
  final String imageUrl;
  final int formality;
  final List<String> aesthetics;

  bool get hasLocalImage => imageUrl.startsWith('file://');

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'color': color.toARGB32(),
      'imageUrl': imageUrl,
      'formality': formality,
      'aesthetics': aesthetics,
    };
  }

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: WardrobeCategory.values.byName(json['category'] as String),
      color: Color(json['color'] as int),
      imageUrl: json['imageUrl'] as String? ?? '',
      formality: json['formality'] as int? ?? 3,
      aesthetics: (json['aesthetics'] as List<dynamic>? ?? const [])
          .cast<String>(),
    );
  }
}

class ProductItem {
  const ProductItem({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  final String id;
  final String brand;
  final String name;
  final String price;
  final String imageUrl;
  final String category;
}

class SavedLook {
  const SavedLook({
    required this.id,
    required this.name,
    required this.itemIds,
    required this.explanation,
  });

  final String id;
  final String name;
  final List<String> itemIds;
  final String explanation;
}

const seedWardrobe = [
  WardrobeItem(
    id: 'blazer',
    name: 'Almond Blazer',
    category: WardrobeCategory.outerwear,
    color: Color(0xFFC7B39C),
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBSxVe7jpNIqzGoj7a2BTQNkYbfdlVom_o98Yi2zVbw3aLwFuw9Uz3LZhbk-K8h7E0S5cMa6MVUP-BLAE5RmcTmSSjUQ-jcNuGn6V5iPMmTmOJfxnXPXDIBgMBwR820i87zzs6MqJDBwbHDjIj0CxMz1-4GtMaGBhILgnFBCkeaFNeo2O5yXzlklzFp2IJGASuCYw_femOaMHH6AiXlrvJzMi8xUzoN8jTSaXQXIaBt5EyNIaZzL3LsBU4kdtvxDjv5jpYCiDOniJk',
    formality: 4,
    aesthetics: ['Quiet Luxury', 'Minimalist'],
  ),
  WardrobeItem(
    id: 'sneakers',
    name: 'White Sneakers',
    category: WardrobeCategory.shoes,
    color: Color(0xFFF1F0EC),
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBYjTMaERoVpz7GPlqec3wWZdxEJGnikYzecmE_JbU_w-r1Z0mRNMoBVEeI_cXgMxI3TWO84OacQbOjnSLCJIzih6OSCGl6UdtovSKgR0xYVAq78M2xnpii4iVR5orXhczWSzxAJ2SyNPAPZQCKGMfqtF7mhHZje7kl9JSavMAqyvVzCOvWNPaj1X51ecXP1yW4YCPCLH8xsBUAtqgzfP_Scdiyf_pmc2MuRtNo8oM6cOzvATnPCgjNLOUVvBpqUhEVWBnheQ8ygpY',
    formality: 2,
    aesthetics: ['Minimalist', 'Casual'],
  ),
  WardrobeItem(
    id: 'denim',
    name: 'Dark Denim',
    category: WardrobeCategory.bottoms,
    color: Color(0xFF23313F),
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC0IGnHwic6dIzamKT__488BTYkGgIyhP7imY1W6berIbRuk1i7rAnSyzSvG8OphKMkofGV6SpAV2pV46IpS3NpXpeR8O4IoxqL775za16YM-Jetqb7nlRf1LofAC4NkBWgfeB1tB4KJpwe9ZF0WY9D-kJBdsJLXAMFbD39kuM6dLQVvJUiqs6cecXplSAQijsLfnByRGaVWq2fpSxdyXzQSwrmV_I5XgpNFVM8dq20ifCxrbHfQL7v3fwpLCboLVcttnIaTZXBTFs',
    formality: 2,
    aesthetics: ['Classic', 'Casual'],
  ),
  WardrobeItem(
    id: 'silk-shirt',
    name: 'Ivory Silk Shirt',
    category: WardrobeCategory.tops,
    color: Color(0xFFE8D8C5),
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBPD5kH2DzYeyc_rbBU1rf9bRxguhGdsKpVnfn3Myyvjz0Yx6i2BGoVvPf-HfKHaXF-6MR3_wRFRy6FBiQQqXn1nNZjs8kLYhuXrrhgFGLXzT2sG-Qa54kAQXL32X_Q507cciVBxht-5evQlifT68iZEUeVay337r32jLU87iYpMthlf8E8-lq12d750Q0iKBZi52H-LhoPdu0OGurA0DMxHXL5HkfX6pgBfsJnlK320wIxCbLAhcMglbo-ZbSg7wmpdju47A-kqI8',
    formality: 4,
    aesthetics: ['Quiet Luxury', 'Classic'],
  ),
  WardrobeItem(
    id: 'trench',
    name: 'Black Trench',
    category: WardrobeCategory.outerwear,
    color: Color(0xFF1D1D1D),
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD_f6CBXEaz0rrl7mr_pQiADXChDv2bhWWEC5lb9Y7O4Lsq3YvtjkAFxDNuDGlMvNl7xc59DMQTgjrc-1oH13REmBaz65zoVKKPkSJ4M_DktbgUTIsY2VwPsw2hZEM4up5-fz_fBqELvt1vc1lW5smCknRzyk8YEJ6NgubVlIYUJfyGYxep39EM4GVT79EpRrnTt3Lsz_V_-uPCZx0AT_jMOsfeUL9o5_d8ppLwTJk-z49h8QfWYBslYLNYPUq7fkp-wmgK3uS9guc',
    formality: 5,
    aesthetics: ['Minimalist', 'Classic'],
  ),
  WardrobeItem(
    id: 'white-tee',
    name: 'Organic White Tee',
    category: WardrobeCategory.tops,
    color: Color(0xFFF8F6F0),
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCDO_wYzGBU0-NbTa60dpqWmFwR9v5pwaldBTU0h3pbhD0k64KtQJcojREDw9zPjh3zKLELSA4rydedcEWkXTQLJWjyv9a9WAyBO3S71fzPPnPjmkqphmgePCoumfAhwx4Qa-dQyrUGYwTdaEzx89ecvWW3mk-g9DCqouQrpiQ9P7BhTTCjOHLKhotFLiXgC7RdaZj-xEBvdPfS_EhkGqh5blzxTfd2rNmsC0T4W1OlZflKaK7Shklhd3xKA4zJ_khIH8588gDPhoU',
    formality: 1,
    aesthetics: ['Minimalist', 'Casual'],
  ),
];

const seedProducts = [
  ProductItem(
    id: 'linen-blazer',
    brand: 'AESTHET',
    name: 'Linen Blend Blazer',
    price: 'Rp 1.499.000',
    category: 'Quiet Luxury',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCvXHzXV644LlG3MzwHzBBg71wOGfdkCOLjnM-ek9Nyn7RZDqxFQYIMtI834fBY20IOn5sE7E0ESFVPUOp1pvF-WueC4nsXFMMaUrHvUN-olx2Su3f-x20h6qThSdx83fxoKeHG6AGQqyhwq6kbwEUprFktHiB3Sl37F8dZkzWa7BZD7A8qBdD-HMal7SGt2Ro5RPnU8nLo2fKJIRRoEcccRnOEKVvWUVwL7FNt8ooJtPQY19OWE95pnHc4HN8NljkYBD3VKqVoMKM',
  ),
  ProductItem(
    id: 'silk-dress',
    brand: 'ORA STUDIO',
    name: 'Silk Slip Dress',
    price: 'Rp 899.000',
    category: 'Minimalist',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC0gV1GAS_cC_xC8IwXLpOHAsIc_4NtT5AQYyHPNbLw3zd-q1J5khSaVEHk4DxxitA7WitT-s0usN78gmKqg5y4IKkN3adKrit3f9QgVAhUh0mJ8ARALlD1DuCfiW9CVecgh-cJwHmSdYHFwJQrAauZgHE7urZnlBdba55-YfpRMuRfb4KMAYf1VuzKzhVfoIAn4JqRpJpYBYL1G1QZe6GjyFDY0qQoR8crddPMzvodItGqx_swcc1fxqc1KEZ_4TXAKBP7IKON2ZA',
  ),
  ProductItem(
    id: 'leather-slide',
    brand: 'NOMAD',
    name: 'Woven Leather Slide',
    price: 'Rp 1.250.000',
    category: 'Coastal',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCHXcKpSLeF_eKAg4nMlwvV7k70xgEMAiSbFYtDoF0glJblF1G7xrSpyJ9kSiGX6P4OGUc5YdT6cfYMwV7bscyNFSF-cTbRKiRNmIyrhdCf3JxMIU_G3QvhbXc4xe1wwLD3OkaaBJoofNuVNo8cb7Ked5HuDJ0Qbh164JlI3q4cubgAaZC7l39GOMkmb4DNz2cd4rjvzfk7lM-udy4sf75XMlzre7FIIbea8pfQCS6Ex8EbyWiCcGog5UGGe2ViP62lk4Fny46zL5A',
  ),
];
