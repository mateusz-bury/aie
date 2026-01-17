import 'package:flutter/material.dart';
import 'package:aie/core/widgets/warhammer_stats_legend_tile.dart';
import 'package:aie/features/characters/data/character_service.dart';
import 'package:aie/features/characters/domain/playable_character.dart';

class Profession {
  final int id;
  final String name;
  final Map<String, int> primaryScheme;
  final Map<String, int> secondaryScheme;

  const Profession({
    required this.id,
    required this.name,
    required this.primaryScheme,
    required this.secondaryScheme,
  });
}

class EditPlayableCharacterPage extends StatefulWidget {
  final int characterId;

  const EditPlayableCharacterPage({super.key, required this.characterId});

  @override
  State<EditPlayableCharacterPage> createState() =>
      _EditPlayableCharacterPageState();
}

class _EditPlayableCharacterPageState extends State<EditPlayableCharacterPage> {
  late Future<PlayableCharacter> _characterFuture;

  // Chroni przed nadpisywaniem danych formularza przy kolejnych rebuildach.
  bool _primed = false;

  final _formKey = GlobalKey<FormState>();

  // Basic
  String? _name;
  String? _race;
  String? _career;
  late final TextEditingController _careerCtrl;
  int? _age;
  int? _characterType;

  // Warhammer keys (dopasowane do Waszych pól w DTO)
  static const List<String> _primaryKeys = ['US', 'S', 'Wt', 'Zr', 'Int', 'SW', 'Ogd'];
  static const List<String> _secondaryKeys = ['A', 'Żyw', 'Ruch', 'Mag', 'PO', 'PP'];

  // Tables: initial / scheme / current
  late Map<String, int> _primaryInitial;
  late Map<String, int> _primaryScheme;
  late Map<String, int> _primaryCurrent;

  late Map<String, int> _secondaryInitial;
  late Map<String, int> _secondaryScheme;
  late Map<String, int> _secondaryCurrent;

  Profession? _selectedProfession;

  static const List<Profession> demoProfessions = [
    Profession(
      id: 1,
      name: 'Żołnierz',
      primaryScheme: {'US': 10, 'S': 10, 'Wt': 10, 'Zr': 5, 'Int': 0, 'SW': 5, 'Ogd': 0},
      secondaryScheme: {'A': 1, 'Żyw': 2, 'Ruch': 0, 'Mag': 0, 'PO': 0, 'PP': 0},
    ),
    Profession(
      id: 2,
      name: 'Złodziej',
      primaryScheme: {'US': 5, 'S': 0, 'Wt': 0, 'Zr': 15, 'Int': 10, 'SW': 0, 'Ogd': 5},
      secondaryScheme: {'A': 0, 'Żyw': 0, 'Ruch': 1, 'Mag': 0, 'PO': 0, 'PP': 0},
    ),
    Profession(
      id: 3,
      name: 'Akolita',
      primaryScheme: {'US': 0, 'S': 0, 'Wt': 5, 'Zr': 0, 'Int': 10, 'SW': 15, 'Ogd': 5},
      secondaryScheme: {'A': 0, 'Żyw': 0, 'Ruch': 0, 'Mag': 1, 'PO': 0, 'PP': 0},
    ),
  ];

  _spaced(Widget child) =>
      Padding(padding: const EdgeInsets.only(bottom: 16), child: child);

  @override
  void initState() {
    super.initState();
    _careerCtrl = TextEditingController();
    _loadCharacter();

    _primaryInitial = {for (final k in _primaryKeys) k: 0};
    _primaryScheme = {for (final k in _primaryKeys) k: 0};
    _primaryCurrent = {for (final k in _primaryKeys) k: 0};

    _secondaryInitial = {for (final k in _secondaryKeys) k: 0};
    _secondaryScheme = {for (final k in _secondaryKeys) k: 0};
    _secondaryCurrent = {for (final k in _secondaryKeys) k: 0};
  }

  void _loadCharacter() {
    _characterFuture = CharacterService.fetchCharacterById(widget.characterId);
  }

  int _parseInt(String s, int fallback) => int.tryParse(s.trim()) ?? fallback;


  void _recalcSchemeFromCurrent() {
    for (final k in _primaryKeys) {
      _primaryScheme[k] = (_primaryCurrent[k] ?? 0) - (_primaryInitial[k] ?? 0);
    }
    for (final k in _secondaryKeys) {
      _secondaryScheme[k] = (_secondaryCurrent[k] ?? 0) - (_secondaryInitial[k] ?? 0);
    }
  }

  Map<String, int> _statsMapFromCurrent() {
    return {
      'ballisticSkill': _primaryCurrent['US'] ?? 0,
      'strength': _primaryCurrent['S'] ?? 0,
      'toughness': _primaryCurrent['Wt'] ?? 0,
      'agility': _primaryCurrent['Zr'] ?? 0,
      'intelligence': _primaryCurrent['Int'] ?? 0,
      'willPower': _primaryCurrent['SW'] ?? 0,
      'fellowship': _primaryCurrent['Ogd'] ?? 0,
      'attacks': _secondaryCurrent['A'] ?? 0,
      'wounds': _secondaryCurrent['Żyw'] ?? 0,
      'movement': _secondaryCurrent['Ruch'] ?? 0,
      'magic': _secondaryCurrent['Mag'] ?? 0,
      'insanityPoints': _secondaryCurrent['PO'] ?? 0,
      'fatePoints': _secondaryCurrent['PP'] ?? 0,
    };
  }

  Map<String, int> _statsMapFromBase() {
    return {
      'ballisticSkill': _primaryInitial['US'] ?? 0,
      'strength': _primaryInitial['S'] ?? 0,
      'toughness': _primaryInitial['Wt'] ?? 0,
      'agility': _primaryInitial['Zr'] ?? 0,
      'intelligence': _primaryInitial['Int'] ?? 0,
      'willPower': _primaryInitial['SW'] ?? 0,
      'fellowship': _primaryInitial['Ogd'] ?? 0,
      'attacks': _secondaryInitial['A'] ?? 0,
      'wounds': _secondaryInitial['Żyw'] ?? 0,
      'movement': _secondaryInitial['Ruch'] ?? 0,
      'magic': _secondaryInitial['Mag'] ?? 0,
      'insanityPoints': _secondaryInitial['PO'] ?? 0,
      'fatePoints': _secondaryInitial['PP'] ?? 0,
    };
  }

  void _onProfessionSelected(Profession? p) {
    setState(() {
      _selectedProfession = p;

      if (p == null) {
        _primaryScheme = {for (final k in _primaryKeys) k: 0};
        _secondaryScheme = {for (final k in _secondaryKeys) k: 0};
        // Back to Base
        for (final k in _primaryKeys) {
          _primaryCurrent[k] = _primaryInitial[k] ?? 0;
        }
        for (final k in _secondaryKeys) {
          _secondaryCurrent[k] = _secondaryInitial[k] ?? 0;
        }
        _recalcSchemeFromCurrent();
        return;
      }

      // Wypełnij schemat rozwoju z profesji, ale nadal pozwól ręcznie edytować w tabeli.
      _primaryScheme = {for (final k in _primaryKeys) k: p.primaryScheme[k] ?? 0};
      _secondaryScheme = {for (final k in _secondaryKeys) k: p.secondaryScheme[k] ?? 0};

      // UX: wybór profesji ustawia też tekstową "career" (żeby nie trzeba było przepisywać).
      _career = p.name;
      _careerCtrl.text = p.name;

      // Apply Base + selected scheme
      for (final k in _primaryKeys) {
        _primaryCurrent[k] = (_primaryInitial[k] ?? 0) + (_primaryScheme[k] ?? 0);
      }
      for (final k in _secondaryKeys) {
        _secondaryCurrent[k] = (_secondaryInitial[k] ?? 0) + (_secondaryScheme[k] ?? 0);
      }
      _recalcSchemeFromCurrent();
    });
  }

  void _primeFromCharacter(PlayableCharacter c) {
    // Wcześniej było "??=" + mapy startowały od 0, więc staty nigdy się nie podstawiały.
    // Robimy inicjalizację JEDNORAZOWO, aby:
    // - na wejściu do edycji widać było realne statystyki
    // - nie nadpisywać zmian użytkownika podczas rebuildów
    if (_primed) return;
    _primed = true;

    _name = c.name;
    _race = c.race;
    _career = c.career;
    _careerCtrl.text = c.career;
    _age = c.age;
    _characterType = c.characterType;

    // Base i Current przychodzą z backendu w liście statistics.
    // UI: Początkowa = Base, Schemat = (Current - Base), Aktualna = Base + Schemat.
    _primaryInitial['US'] = c.baseBallisticSkill;
    _primaryInitial['S'] = c.baseStrength;
    _primaryInitial['Wt'] = c.baseToughness;
    _primaryInitial['Zr'] = c.baseAgility;
    _primaryInitial['Int'] = c.baseIntelligence;
    _primaryInitial['SW'] = c.baseWillPower;
    _primaryInitial['Ogd'] = c.baseFellowship;

    _secondaryInitial['A'] = c.baseAttacks;
    _secondaryInitial['Żyw'] = c.baseWounds;
    _secondaryInitial['Ruch'] = c.baseMovement;
    _secondaryInitial['Mag'] = c.baseMagic;
    _secondaryInitial['PO'] = c.baseInsanityPoints;
    _secondaryInitial['PP'] = c.baseFatePoints;

    // W edycji: Current jest edytowalne, a Schemat = (Current - Base) jest tylko podglądem.
    _primaryCurrent['US'] = c.ballisticSkill;
    _primaryCurrent['S'] = c.strength;
    _primaryCurrent['Wt'] = c.toughness;
    _primaryCurrent['Zr'] = c.agility;
    _primaryCurrent['Int'] = c.intelligence;
    _primaryCurrent['SW'] = c.willPower;
    _primaryCurrent['Ogd'] = c.fellowship;

    _secondaryCurrent['A'] = c.attacks;
    _secondaryCurrent['Żyw'] = c.wounds;
    _secondaryCurrent['Ruch'] = c.movement;
    _secondaryCurrent['Mag'] = c.magic;
    _secondaryCurrent['PO'] = c.insanityPoints;
    _secondaryCurrent['PP'] = c.fatePoints;

    _recalcSchemeFromCurrent();
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      final originalCharacter = await _characterFuture;

      final updatedCharacter = PlayableCharacter(
        id: originalCharacter.id,
        characterType: originalCharacter.characterType,
        campaignId: originalCharacter.campaignId,

        name: _name ?? originalCharacter.name,
        race: _race ?? originalCharacter.race,
        career: _career ?? originalCharacter.career,
        age: _age ?? originalCharacter.age,

        ballisticSkill: _primaryCurrent['US'] ?? 0,
        strength: _primaryCurrent['S'] ?? 0,
        toughness: _primaryCurrent['Wt'] ?? 0,
        agility: _primaryCurrent['Zr'] ?? 0,
        intelligence: _primaryCurrent['Int'] ?? 0,
        willPower: _primaryCurrent['SW'] ?? 0,
        fellowship: _primaryCurrent['Ogd'] ?? 0,

        attacks: _secondaryCurrent['A'] ?? 0,
        wounds: _secondaryCurrent['Żyw'] ?? 0,
        movement: _secondaryCurrent['Ruch'] ?? 0,
        magic: _secondaryCurrent['Mag'] ?? 0,
        insanityPoints: _secondaryCurrent['PO'] ?? 0,
        fatePoints: _secondaryCurrent['PP'] ?? 0,
      );

      // Backend rozdziela update danych podstawowych i statystyk.
      await CharacterService.updateCharacterBasic(updatedCharacter);
      // W edycji: Base jest read-only, więc aktualizujemy tylko Current.
      await CharacterService.updateCharacterStatsRaw(
        characterId: updatedCharacter.id,
        statisticType: 1,
        stats: _statsMapFromCurrent(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Postać została zaktualizowana")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Błąd podczas zapisu: $e")),
      );
    }
  }

  @override
  void dispose() {
    _careerCtrl.dispose();
    super.dispose();
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
          _primeFromCharacter(character);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                const WarhammerStatsLegendTile(),
                const SizedBox(height: 16),
                  _spaced(
                    DropdownButtonFormField<int>(
                      value: _characterType,
                      decoration: const InputDecoration(labelText: 'Typ postaci'),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Gracz (Playable)')),
                        DropdownMenuItem(value: 1, child: Text('NPC (Npc)')),
                        DropdownMenuItem(value: 2, child: Text('Szablon (Template)')),
                      ],
                      // Backend nie ma UpdateCharacterDto z CharacterType, więc na razie tylko podgląd.
                      onChanged: null,
                    ),
                  ),

                  _spaced(
                    TextFormField(
                      initialValue: _name,
                      decoration: const InputDecoration(labelText: 'Imię'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Wpisz imię' : null,
                      onSaved: (value) => _name = value,
                    ),
                  ),

                  _spaced(
                    TextFormField(
                      initialValue: _race,
                      decoration: const InputDecoration(labelText: 'Rasa'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Wpisz rasę' : null,
                      onSaved: (value) => _race = value,
                    ),
                  ),

                  // Profesja -> zmienia schemat rozwoju
                  _spaced(
                    DropdownButtonFormField<Profession>(
                      value: _selectedProfession,
                      decoration: const InputDecoration(labelText: 'Profesja (schemat rozwoju)'),
                      items: demoProfessions
                          .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                          .toList(),
                      // W edycji: Base jest read-only, a użytkownik zmienia tylko Current.
                      // Schemat pokazujemy jako różnicę (Current - Base), więc wybór profesji to tylko placeholder.
                      onChanged: null,
                    ),
                  ),

                  _spaced(
                    TextFormField(
                      controller: _careerCtrl,
                      decoration: const InputDecoration(labelText: 'Profesja / klasa (tekst)'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Wpisz profesję/klasę' : null,
                      onSaved: (_) => _career = _careerCtrl.text,
                    ),
                  ),

                  _spaced(
                    TextFormField(
                      initialValue: (_age ?? 0).toString(),
                      decoration: const InputDecoration(labelText: 'Wiek'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Wpisz Wiek';
                        if (int.tryParse(value) == null) return 'Wpisz poprawną liczbę';
                        return null;
                      },
                      onSaved: (value) => _age = int.tryParse(value ?? '') ?? 0,
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Atrybuty postaci (Warhammer 2e)",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),

                  StatsTable(
                    title: 'Cechy główne',
                    keys: _primaryKeys,
                    initial: _primaryInitial,
                    scheme: _primaryScheme,
                    current: _primaryCurrent,
                    onCurrentChanged: (k, v) => setState(() { _primaryCurrent[k] = v; _recalcSchemeFromCurrent(); }),
                    parseInt: _parseInt,
                  ),

                  const SizedBox(height: 16),

                  StatsTable(
                    title: 'Cechy drugorzędne',
                    keys: _secondaryKeys,
                    initial: _secondaryInitial,
                    scheme: _secondaryScheme,
                    current: _secondaryCurrent,
                    onCurrentChanged: (k, v) => setState(() { _secondaryCurrent[k] = v; _recalcSchemeFromCurrent(); }),
                    parseInt: _parseInt,
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveCharacter,
                      child: const Text("Zapisz"),
                    ),
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

class StatsTable extends StatelessWidget {
  final String title;
  final List<String> keys;

  final Map<String, int> initial;
  final Map<String, int> scheme;
  final Map<String, int> current;

  final void Function(String key, int value) onCurrentChanged;

  final int Function(String s, int fallback) parseInt;

  const StatsTable({
    super.key,
    required this.title,
    required this.keys,
    required this.initial,
    required this.scheme,
    required this.current,
    required this.onCurrentChanged,
    required this.parseInt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: const [
                SizedBox(width: 52),
                Expanded(child: _HeaderCell('Początkowa')),
                SizedBox(width: 8),
                Expanded(child: _HeaderCell('Schemat')),
                SizedBox(width: 8),
                Expanded(child: _HeaderCell('Aktualna')),
              ],
            ),
            const SizedBox(height: 8),
            ...keys.map(
              (k) => _StatRow(
                label: k,
                initialValue: initial[k] ?? 0,
                schemeValue: scheme[k] ?? 0,
                currentValue: current[k] ?? 0,
                onCurrentChanged: (v) => onCurrentChanged(k, v),
                parseInt: parseInt,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }
}

class _StatRow extends StatefulWidget {
  final String label;
  final int initialValue;
  final int schemeValue;
  final int currentValue;
  final ValueChanged<int> onCurrentChanged;
  final int Function(String s, int fallback) parseInt;

  const _StatRow({
    required this.label,
    required this.initialValue,
    required this.schemeValue,
    required this.currentValue,
    required this.onCurrentChanged,
    required this.parseInt,
  });

  @override
  State<_StatRow> createState() => _StatRowState();
}

class _StatRowState extends State<_StatRow> {
  late final TextEditingController _currentCtrl;

  @override
  void initState() {
    super.initState();
    _currentCtrl = TextEditingController(text: widget.currentValue.toString());
  }

  @override
  void didUpdateWidget(covariant _StatRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentValue != widget.currentValue &&
        _currentCtrl.text != widget.currentValue.toString()) {
      _currentCtrl.text = widget.currentValue.toString();
    }
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(widget.label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: _ReadOnlyBox(value: widget.initialValue.toString()),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ReadOnlyBox(value: widget.schemeValue.toString()),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _currentCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              ),
              onChanged: (s) => widget.onCurrentChanged(
                widget.parseInt(s, widget.currentValue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyBox extends StatelessWidget {
  final String value;
  const _ReadOnlyBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
