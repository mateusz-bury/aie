import 'package:flutter/material.dart';
import 'package:aie/features/campaigns/data/campaign_service.dart';
import 'package:aie/features/campaigns/domain/campaign.dart';
import 'package:aie/features/characters/data/character_service.dart';
import 'package:aie/features/characters/domain/playable_character.dart';

class CreatePlayableCharacterPage extends StatefulWidget {
  const CreatePlayableCharacterPage({super.key});

  @override
  State<CreatePlayableCharacterPage> createState() =>
      _CreatePlayableCharacterPageState();
}

class _CreatePlayableCharacterPageState
    extends State<CreatePlayableCharacterPage> {
  final _formKey = GlobalKey<FormState>();

  List<Campaign> _campaigns = [];
  int? _selectedCampaignId;

  String? _name;
  String? _race;
  String? _career;
  int? _age;
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

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    final campaigns = await CampaignService.fetchCampaigns();
    setState(() {
      _campaigns = campaigns;
    });
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCampaignId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Wybierz kampanię")));
      return;
    }
    _formKey.currentState!.save();

    // Use safe defaults to avoid runtime exceptions when some fields are missing
    final newCharacter = PlayableCharacter(
      id: 0, // API powinno nadać ID
      campaignId: _selectedCampaignId!,
      name: _name ?? '',
      race: _race ?? '',
      career: _career ?? '',
      age: _age ?? 0,
      ballisticSkill: _ballisticSkill ?? 0,
      strength: _strength ?? 0,
      toughness: _toughness ?? 0,
      agility: _agility ?? 0,
      intelligence: _intelligence ?? 0,
      willPower: _willPower ?? 0,
      fellowship: _fellowship ?? 0,
      attacks: _attacks ?? 0,
      wounds: _wounds ?? 0,
      movement: _movement ?? 0,
      magic: _magic ?? 0,
      insanityPoints: _insanityPoints ?? 0,
      fatePoints: _fatePoints ?? 0,
    );

    try {
      await CharacterService.createCharacter(newCharacter);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Postać została utworzona")));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Błąd podczas tworzenia: $e")));
    }
  }

  Widget _buildNumberField(String label, void Function(int?) onSaved) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Wpisz $label';
        if (int.tryParse(value) == null) return 'Wpisz poprawną liczbę';
        return null;
      },
      onSaved: (value) => onSaved(int.tryParse(value ?? '') ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Utwórz postać")),
      body:
          _campaigns.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: _selectedCampaignId,
                        items:
                            _campaigns
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name),
                                  ),
                                )
                                .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Kampania',
                        ),
                        onChanged:
                            (value) =>
                                setState(() => _selectedCampaignId = value),
                        validator:
                            (value) =>
                                value == null ? "Wybierz kampanię" : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Imię'),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Wpisz imię'
                                    : null,
                        onSaved: (value) => _name = value,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Rasa'),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Wpisz rasę'
                                    : null,
                        onSaved: (value) => _race = value,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Klasa'),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Wpisz klasę'
                                    : null,
                        onSaved: (value) => _career = value,
                      ),
                      _buildNumberField('Wiek', (v) => _age = v),
                      const SizedBox(height: 16),
                      const Text(
                        "Atrybuty postaci",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      _buildNumberField(
                        'Umiejętność strzelecka',
                        (v) => _ballisticSkill = v,
                      ),
                      _buildNumberField('Siła', (v) => _strength = v),
                      _buildNumberField('Wytrzymałość', (v) => _toughness = v),
                      _buildNumberField('Zręczność', (v) => _agility = v),
                      _buildNumberField(
                        'Inteligencja',
                        (v) => _intelligence = v,
                      ),
                      _buildNumberField('Siła woli', (v) => _willPower = v),
                      _buildNumberField('Charyzma', (v) => _fellowship = v),
                      _buildNumberField('Ataki', (v) => _attacks = v),
                      _buildNumberField('Rany', (v) => _wounds = v),
                      _buildNumberField('Ruch', (v) => _movement = v),
                      _buildNumberField('Magia', (v) => _magic = v),
                      _buildNumberField(
                        'Punkty szaleństwa',
                        (v) => _insanityPoints = v,
                      ),
                      _buildNumberField('Punkty losu', (v) => _fatePoints = v),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _saveCharacter,
                        child: const Text("Utwórz"),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
