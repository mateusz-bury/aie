import 'package:aie/features/items/data/item_service.dart';
import 'package:aie/features/items/domain/item.dart';
import 'package:aie/features/items/presentation/pages/create_item_page.dart';
import 'package:aie/features/items/presentation/pages/edit_item_page.dart';
import 'package:flutter/material.dart';
import 'package:aie/core/widgets/aie_background.dart';
import 'package:aie/core/theme/app_colors.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _itemsFuture = ItemService.fetchItems();
  }

  Future<void> _openCreate() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateItemPage()),
    );
    if (created == true) {
      setState(_reload);
    }
  }

  Future<void> _openEdit(Item item) async {
    final edited = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditItemPage(item: item)),
    );
    if (edited == true) {
      setState(_reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Przedmioty'),
        actions: [
          IconButton(onPressed: _openCreate, icon: const Icon(Icons.add)),
        ],
      ),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: FutureBuilder<List<Item>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          Widget content;
          if (snapshot.connectionState == ConnectionState.waiting) {
            content = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            content = Center(
              child: Text(
                'Błąd: ${snapshot.error}',
                style: const TextStyle(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final items = snapshot.data ?? const <Item>[];
            if (items.isEmpty) {
              content = const Center(
                child: Text('Brak przedmiotów', style: TextStyle(color: AppColors.textMuted)),
              );
            } else {
              content = ListView.separated(
                padding: const EdgeInsets.all(4),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final it = items[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.inventory_2, color: AppColors.accent),
                      title: Text(it.name),
                      subtitle: Text(
                        '${it.type} • ${it.price} • ${it.weight}',
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                      trailing: const Icon(Icons.edit, color: AppColors.textMuted),
                      onTap: () => _openEdit(it),
                    ),
                  );
                },
              );
            }
          }

          return AieBackground(
            child: Column(
              children: [
                const SizedBox(height: 56),
                Expanded(child: content),
              ],
            ),
          );
        },
      ),
    );
  }
}
