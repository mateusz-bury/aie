import 'package:aie/features/items/data/character_item_service.dart';
import 'package:aie/features/items/data/item_service.dart';
import 'package:aie/features/items/domain/character_item.dart';
import 'package:aie/features/items/domain/item.dart';
import 'package:aie/features/items/presentation/pages/edit_item_page.dart';
import 'package:flutter/material.dart';

class CharacterInventoryPage extends StatefulWidget {
  final int characterId;
  final String characterName;

  const CharacterInventoryPage({
    super.key,
    required this.characterId,
    required this.characterName,
  });

  @override
  State<CharacterInventoryPage> createState() => _CharacterInventoryPageState();
}

class _CharacterInventoryPageState extends State<CharacterInventoryPage> {
  late Future<List<CharacterItem>> _inventoryFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _inventoryFuture = CharacterItemService.fetchInventory(widget.characterId);
  }

  Future<void> _remove(CharacterItem ci) async {
    try {
      await CharacterItemService.removeItem(
        characterId: widget.characterId,
        itemId: ci.itemId,
      );
      if (!mounted) return;
      setState(_reload);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  Future<void> _add() async {
    try {
      final items = await ItemService.fetchItems();
      if (!mounted) return;

      Item? selected = items.isNotEmpty ? items.first : null;
      int count = 1;

      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Dodaj przedmiot'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Item>(
                  value: selected,
                  items: items
                      .map(
                        (it) => DropdownMenuItem<Item>(
                          value: it,
                          child: Text(it.name),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => selected = v,
                  decoration: const InputDecoration(labelText: 'Przedmiot'),
                ),
                TextFormField(
                  initialValue: '1',
                  decoration: const InputDecoration(labelText: 'Ilość'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => count = int.tryParse(v) ?? 1,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Anuluj')),
              ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Dodaj')),
            ],
          );
        },
      );

      if (ok != true || selected == null) return;

      await CharacterItemService.addItem(
        characterId: widget.characterId,
        itemId: selected!.id,
        count: count,
      );
      if (!mounted) return;
      setState(_reload);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  Future<void> _openEditItem(int itemId) async {
    try {
      final item = await ItemService.fetchItemById(itemId);
      if (!mounted) return;
      final edited = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EditItemPage(item: item)),
      );
      if (edited == true) {
        setState(_reload);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ekwipunek: ${widget.characterName}'),
        actions: [
          IconButton(onPressed: _add, icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder<List<CharacterItem>>(
        future: _inventoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          }

          final inv = snapshot.data ?? const <CharacterItem>[];
          if (inv.isEmpty) {
            return const Center(child: Text('Brak przedmiotów w ekwipunku'));
          }

          return ListView.separated(
            itemCount: inv.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final ci = inv[i];
              return ListTile(
                leading: const Icon(Icons.inventory_2),
                title: Text(ci.name),
                subtitle: Text('${ci.type} • x${ci.count}'),
                onTap: () => _openEditItem(ci.itemId),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _remove(ci),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
