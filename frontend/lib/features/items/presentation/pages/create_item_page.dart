import 'package:aie/features/items/data/item_service.dart';
import 'package:aie/features/items/domain/item.dart';
import 'package:flutter/material.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  String type = '';
  int price = 0;
  int weight = 0;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      await ItemService.createItem(
        Item(
          id: 0,
          name: name,
          description: description,
          type: type,
          price: price,
          weight: weight,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Przedmiot utworzony')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj przedmiot')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nazwa'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Wpisz nazwę' : null,
                onSaved: (v) => name = v!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Typ'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Wpisz typ' : null,
                onSaved: (v) => type = v!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Opis'),
                minLines: 2,
                maxLines: 5,
                onSaved: (v) => description = (v ?? '').trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cena'),
                keyboardType: TextInputType.number,
                validator: (v) => int.tryParse(v ?? '') == null ? 'Wpisz liczbę' : null,
                onSaved: (v) => price = int.tryParse(v ?? '') ?? 0,
              ),
              TextFormField(
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
