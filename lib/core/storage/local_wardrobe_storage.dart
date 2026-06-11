import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/aurae_models.dart';

class LocalWardrobeStorage {
  static String _itemsKey(String ownerId) => 'local_wardrobe_items_v1_$ownerId';

  Future<List<WardrobeItem>> loadItems(String ownerId) async {
    final preferences = await SharedPreferences.getInstance();
    final encodedItems = preferences.getString(_itemsKey(ownerId));
    if (encodedItems == null || encodedItems.isEmpty) return [];

    try {
      final decoded = jsonDecode(encodedItems) as List<dynamic>;
      return decoded
          .map(
            (item) => WardrobeItem.fromJson(
              Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
            ),
          )
          .where((item) {
            if (!item.hasLocalImage) return true;
            return File(Uri.parse(item.imageUrl).toFilePath()).existsSync();
          })
          .toList();
    } on FormatException {
      return [];
    }
  }

  Future<void> saveItems(String ownerId, List<WardrobeItem> items) async {
    final localItems = items.where((item) => item.hasLocalImage).toList();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _itemsKey(ownerId),
      jsonEncode(localItems.map((item) => item.toJson()).toList()),
    );
  }

  Future<String> importImage(XFile image, String itemId, String ownerId) async {
    final documents = await getApplicationDocumentsDirectory();
    final wardrobeDirectory = Directory(
      path.join(documents.path, 'aurae', ownerId, 'wardrobe'),
    );
    await wardrobeDirectory.create(recursive: true);

    final extension = path.extension(image.path).toLowerCase();
    final safeExtension = extension.isEmpty ? '.jpg' : extension;
    final destination = File(
      path.join(wardrobeDirectory.path, '$itemId$safeExtension'),
    );
    await File(image.path).copy(destination.path);
    return destination.uri.toString();
  }

  Future<void> deleteImage(String imageUrl) async {
    if (!imageUrl.startsWith('file://')) return;
    final file = File(Uri.parse(imageUrl).toFilePath());
    if (await file.exists()) await file.delete();
  }
}
