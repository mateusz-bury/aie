import 'package:flutter/material.dart';
import '../service/CharacterService.dart';
import '../models/PlayableCharacter.dart';

class EditPlayableCharacterPage extends StatefulWidget {
  final int characterId;

  const EditPlayableCharacterPage({super.key, required this.characterId});

  @override
  State<EditPlayableCharacterPage> createState() =>
      _EditPlayableCharacterPageState();
}

class _EditPlayableCharacterPageState extends State<EditPlayableCharacterPage> {
  late Future<PlayableCharacter> _characterFuture;

  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _race;
  String? _career;

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  void _loadCharacter() {
    _characterFuture = CharacterService.fetchCharacterById(widget.characterId);
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    // Wywołanie serwisu do zapisania zmian
    // await CharacterService.updatePlayableCharacter(
    //   widget.characterId,
    //   name: _name!,
    //   race: _race!,
    //   career: _career!,
    // );

    // Powrót do poprzedniej strony i odświeżenie danych
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edytuj postać")),
      body: FutureBuilder<PlayableCharacter>(
        future: _characterFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Błąd: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Nie znaleziono postaci"));
          }

          final character = snapshot.data!;
          _name ??= character.name;
          _race ??= character.race;
          _career ??= character.career;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(labelText: 'Imię'),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Wpisz imię'
                                : null,
                    onSaved: (value) => _name = value,
                  ),
                  TextFormField(
                    initialValue: _race,
                    decoration: const InputDecoration(labelText: 'Rasa'),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Wpisz rasę'
                                : null,
                    onSaved: (value) => _race = value,
                  ),
                  TextFormField(
                    initialValue: _career,
                    decoration: const InputDecoration(labelText: 'Klasa'),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Wpisz klasę'
                                : null,
                    onSaved: (value) => _career = value,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saveCharacter,
                    child: const Text("Zapisz"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
