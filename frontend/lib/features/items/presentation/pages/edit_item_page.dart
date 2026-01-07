import 'package:aie/features/items/data/item_service.dart';
import 'package:aie/features/items/domain/item.dart';
import 'package:flutter/material.dart';

class EditItemPage extends StatefulWidget {
  final Item item;
  const EditItemPage({super.key, required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();

  late String name;
  late String description;
  late String type;
  late int price;
  late int weight;

  @override
  void initState() {
    super.initState();
    name = widget.item.name;
    description = widget.item.description;
    type = widget.item.type;
    price = widget.item.price;
    weight = widget.item.weight;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    try {
      await ItemService.updateItem(
        Item(
          id: widget.item.id,
          name: name,
          description: description,
          type: type,
          price: price,
          weight: weight,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zapisano')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edytuj: ${widget.item.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Nazwa'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Wpisz nazwę' : null,
                onSaved: (v) => name = v!.trim(),
              ),
              TextFormField(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Typ'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Wpisz typ' : null,
                onSaved: (v) => type = v!.trim(),
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Opis'),
                minLines: 2,
                maxLines: 5,
                onSaved: (v) => description = (v ?? '').trim(),
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: const InputDecoration(labelText: 'Cena'),
                keyboardType: TextInputType.number,
                validator: (v) => int.tryParse(v ?? '') == null ? 'Wpisz liczbę' : null,
                onSaved: (v) => price = int.tryParse(v ?? '') ?? 0,
              ),
              TextFormField(
                initialValue: weight.toString(),
                decoration: const InputDecoration(labelText: 'Waga'),
                keyboardType: TextInputType.number,
                validator: (v) => int.tryParse(v ?? '') == null ? 'Wpisz liczbę' : null,
                onSaved: (v) => weight = int.tryParse(v ?? '') ?? 0,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _save, child: const Text('Zapisz')),
            ],
          ),
        ),
      ),
    );
  }
}
