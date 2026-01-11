import 'package:flutter/material.dart';
import 'package:aie/features/characters/data/character_service.dart';
import 'package:aie/features/characters/domain/playable_character.dart';

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
  int? _age;

  int? _characterType;
  int? _ballisticSkill;
  int? _strength;
  int? _toughness;
  int? _agility;
  int? _intelligence;
  int? _willPower;
  int? _fellowship;
  int? _attacks;
  int? _wounds;
  int? _movement;
  int? _magic;
  int? _insanityPoints;
  int? _fatePoints;

  _spaced(Widget child) {
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: child);
  }

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

    try {
      final originalCharacter = await _characterFuture;

      final updatedCharacter = PlayableCharacter(
        id: originalCharacter.id,
        characterType: originalCharacter.characterType,
        name: _name!,
        race: _race!,
        career: _career!,
        age: _age!,
        campaignId: originalCharacter.campaignId,
        ballisticSkill: _ballisticSkill!,
        strength: _strength!,
        toughness: _toughness!,
        agility: _agility!,
        intelligence: _intelligence!,
        willPower: _willPower!,
        fellowship: _fellowship!,
        attacks: _attacks!,
        wounds: _wounds!,
        movement: _movement!,
        magic: _magic!,
        insanityPoints: _insanityPoints!,
        fatePoints: _fatePoints!,
      );

      // Backend rozdziela update danych podstawowych i statystyk.
      await CharacterService.updateCharacterBasic(updatedCharacter);
      await CharacterService.updateCharacterStats(
        updatedCharacter,
        statisticType: 1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Postać została zaktualizowana")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Błąd podczas zapisu: $e")));
    }
  }

  Widget _buildNumberField(
    String label,
    int? initialValue,
    void Function(int?) onSaved,
  ) {
    return TextFormField(
      initialValue: initialValue?.toString(),
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Wpisz $label';
        if (int.tryParse(value) == null) return 'Wpisz poprawną liczbę';
        return null;
      },
      onSaved: (value) => onSaved(int.tryParse(value!)),
    );
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
          _age ??= character.age;
          _characterType ??= character.characterType;
          _ballisticSkill ??= character.ballisticSkill;
          _strength ??= character.strength;
          _toughness ??= character.toughness;
          _agility ??= character.agility;
          _intelligence ??= character.intelligence;
          _willPower ??= character.willPower;
          _fellowship ??= character.fellowship;
          _attacks ??= character.attacks;
          _wounds ??= character.wounds;
          _movement ??= character.movement;
          _magic ??= character.magic;
          _insanityPoints ??= character.insanityPoints;
          _fatePoints ??= character.fatePoints;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _spaced(
                    DropdownButtonFormField<int>(
                      value: _characterType,
                      decoration: const InputDecoration(
                        labelText: 'Typ postaci',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text('Gracz (Playable)'),
                        ),
                        DropdownMenuItem(value: 1, child: Text('NPC (Npc)')),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Szablon (Template)'),
                        ),
                      ],
                      // Backend nie ma UpdateCharacterDto z CharacterType, więc na razie tylko podgląd.
                      onChanged: null,
                    ),
                  ),
                  _spaced(
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
                  ),
                  _spaced(
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
                  ),
                  _spaced(
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
                  ),
                  _spaced(_buildNumberField('Wiek', _age, (v) => _age = v)),
                  const SizedBox(height: 16),
                  const Text(
                    "Atrybuty postaci",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _spaced(
                    _buildNumberField(
                      'Umiejętność strzelecka',
                      _ballisticSkill,
                      (v) => _ballisticSkill = v,
                    ),
                  ),
                  _spaced(
                    _buildNumberField('Siła', _strength, (v) => _strength = v),
                  ),
                  _spaced(
                    _buildNumberField(
                      'Wytrzymałość',
                      _toughness,
                      (v) => _toughness = v,
                    ),
                  ),
                  _spaced(
                    _buildNumberField(
                      'Zręczność',
                      _agility,
                      (v) => _agility = v,
                    ),
                  ),
                  _spaced(
                    _buildNumberField(
                      'Inteligencja',
                      _intelligence,
                      (v) => _intelligence = v,
                    ),
                  ),
                  _spaced(
                    _buildNumberField(
                      'Siła woli',
                      _willPower,
                      (v) => _willPower = v,
                    ),
                  ),
                  _spaced(
                    _buildNumberField(
                      'Charyzma',
                      _fellowship,
                      (v) => _fellowship = v,
                    ),
                  ),
                  _spaced(
                    _buildNumberField('Ataki', _attacks, (v) => _attacks = v),
                  ),
                  _spaced(
                    _buildNumberField('Rany', _wounds, (v) => _wounds = v),
                  ),
                  _spaced(
                    _buildNumberField('Ruch', _movement, (v) => _movement = v),
                  ),
                  _spaced(
                    _buildNumberField('Magia', _magic, (v) => _magic = v),
                  ),
                  _spaced(
                    _buildNumberField(
                      'Punkty szaleństwa',
                      _insanityPoints,
                      (v) => _insanityPoints = v,
                    ),
                  ),
                  _spaced(
                    _buildNumberField(
                      'Punkty losu',
                      _fatePoints,
                      (v) => _fatePoints = v,
                    ),
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
