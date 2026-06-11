import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/app_controller.dart';
import '../../app/aurae_app.dart';
import '../../app/aurae_theme.dart';
import '../../core/models/aurae_models.dart';
import '../../core/storage/local_wardrobe_storage.dart';
import '../../core/widgets/aurae_widgets.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  WardrobeCategory? filter;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final Indonesian = controller.isIndonesian;
    final items = filter == null
        ? controller.wardrobe
        : controller.wardrobe.where((item) => item.category == filter).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              child: Row(
                children: [
                  const Icon(Icons.menu),
                  Expanded(
                    child: Center(
                      child: Text(
                        'AURAE',
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: AuraeColors.rose,
                    child: Icon(Icons.person_outline),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 52,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                    label: Indonesian ? 'Semua' : 'All',
                    selected: filter == null,
                    onTap: () => setState(() => filter = null),
                  ),
                  ...WardrobeCategory.values.map(
                    (category) => _FilterChip(
                      label: _categoryLabel(category, Indonesian),
                      selected: filter == category,
                      onTap: () => setState(() => filter = category),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? EmptyState(
                      icon: Icons.checkroom_outlined,
                      title: Indonesian ? 'Belum ada item' : 'No items yet',
                      message: Indonesian
                          ? 'Tambahkan pakaian agar Stylist dapat menyusun outfit.'
                          : 'Add clothing so Stylist can compose an outfit.',
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .68,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                      itemCount: items.length,
                      itemBuilder: (context, index) => _WardrobeCard(
                        item: items[index],
                        Indonesian: Indonesian,
                        onDelete: () =>
                            controller.deleteWardrobeItem(items[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItem(context, controller),
        backgroundColor: AuraeColors.rose,
        foregroundColor: AuraeColors.ink,
        icon: const Icon(Icons.add),
        label: Text(Indonesian ? 'Tambah item' : 'Add item'),
      ),
    );
  }

  Future<void> _showAddItem(
    BuildContext context,
    AppController controller,
  ) async {
    final Indonesian = controller.isIndonesian;
    final nameController = TextEditingController();
    final imagePicker = ImagePicker();
    final localStorage = LocalWardrobeStorage();
    var category = WardrobeCategory.tops;
    XFile? selectedImage;
    var saving = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            24,
            20,
            MediaQuery.viewInsetsOf(context).bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Indonesian ? 'Tambah item baru' : 'Add a new item',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AuraeColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: selectedImage == null
                    ? Center(
                        child: TextButton.icon(
                          onPressed: () async {
                            final source = await _chooseImageSource(
                              context,
                              Indonesian,
                            );
                            if (source == null) return;
                            final image = await imagePicker.pickImage(
                              source: source,
                              imageQuality: 82,
                              maxWidth: 1600,
                            );
                            if (image != null) {
                              setModalState(() => selectedImage = image);
                            }
                          },
                          icon: const Icon(Icons.add_a_photo_outlined),
                          label: Text(
                            Indonesian ? 'Pilih foto' : 'Choose photo',
                          ),
                        ),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(
                              File(selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: IconButton.filledTonal(
                              onPressed: () =>
                                  setModalState(() => selectedImage = null),
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: Indonesian ? 'Nama item' : 'Item name',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<WardrobeCategory>(
                initialValue: category,
                decoration: InputDecoration(
                  labelText: Indonesian ? 'Kategori' : 'Category',
                ),
                items: WardrobeCategory.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_categoryLabel(value, Indonesian)),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setModalState(() => category = value ?? category),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: saving
                    ? null
                    : () async {
                        setModalState(() => saving = true);
                        final id = DateTime.now().microsecondsSinceEpoch
                            .toString();
                        final imageUrl = selectedImage == null
                            ? ''
                            : await localStorage.importImage(
                                selectedImage!,
                                id,
                                controller.localStorageOwnerId,
                              );
                        await controller.addWardrobeItem(
                          WardrobeItem(
                            id: id,
                            name: nameController.text.trim().isEmpty
                                ? (Indonesian ? 'Item baru' : 'New item')
                                : nameController.text.trim(),
                            category: category,
                            color: AuraeColors.rose,
                            imageUrl: imageUrl,
                            formality: 3,
                            aesthetics: const ['Minimalist'],
                          ),
                        );
                        if (context.mounted) Navigator.pop(context);
                      },
                child: saving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(Indonesian ? 'Simpan item' : 'Save item'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ImageSource?> _chooseImageSource(
    BuildContext context,
    bool Indonesian,
  ) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(
                Indonesian ? 'Pilih dari galeri' : 'Choose from gallery',
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(Indonesian ? 'Ambil foto' : 'Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }
}

String _categoryLabel(WardrobeCategory category, bool Indonesian) {
  return switch (category) {
    WardrobeCategory.tops => Indonesian ? 'Atasan' : 'Tops',
    WardrobeCategory.bottoms => Indonesian ? 'Bawahan' : 'Bottoms',
    WardrobeCategory.dresses => Indonesian ? 'Gaun' : 'Dresses',
    WardrobeCategory.outerwear => 'Outerwear',
    WardrobeCategory.shoes => Indonesian ? 'Sepatu' : 'Shoes',
    WardrobeCategory.bags => Indonesian ? 'Tas' : 'Bags',
  };
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _WardrobeCard extends StatelessWidget {
  const _WardrobeCard({
    required this.item,
    required this.Indonesian,
    required this.onDelete,
  });
  final WardrobeItem item;
  final bool Indonesian;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: item.hasLocalImage
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(Indonesian ? 'Hapus item?' : 'Delete item?'),
          content: Text(
            Indonesian
                ? 'Foto dan data item akan dihapus dari perangkat ini.'
                : 'The photo and item data will be deleted from this device.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(Indonesian ? 'Batal' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(Indonesian ? 'Hapus' : 'Delete'),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AuraeColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D221A18),
              blurRadius: 22,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FashionImage(
                url: item.imageUrl,
                fit: BoxFit.contain,
                borderRadius: 12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(
              _categoryLabel(item.category, Indonesian).toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AuraeColors.muted,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
