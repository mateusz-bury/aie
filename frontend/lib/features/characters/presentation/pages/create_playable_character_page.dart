import 'package:flutter/material.dart';
import 'package:aie/core/widgets/warhammer_stats_legend_tile.dart';
import 'package:aie/features/campaigns/data/campaign_service.dart';
import 'package:aie/features/campaigns/domain/campaign.dart';
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

class CreatePlayableCharacterPage extends StatefulWidget {
  // formularz będzie tworzył postać bezpośrednio w tej kampanii.
  final int? initialCampaignId;

  const CreatePlayableCharacterPage({super.key, this.initialCampaignId});

  @override
  State<CreatePlayableCharacterPage> createState() =>
      _CreatePlayableCharacterPageState();
}

class _CreatePlayableCharacterPageState
    extends State<CreatePlayableCharacterPage> {
  final _formKey = GlobalKey<FormState>();

  List<Campaign> _campaigns = [];
  int? _selectedCampaignId;

  // 0 = playable, 1 = npc
  int _characterType = 0;

  final TextEditingController _careerCtrl = TextEditingController();

  String? _name;
  String? _race;
  String? _career; // zostaje jako tekst, ale wybór profesji może ją wypełniać
  int? _age;

  // --- Warhammer 2e klucze 
  static const List<String> _primaryKeys = [
    'US', // Umiejętność strzelecka
    'S',  // Siła
    'Wt', // Wytrzymałość
    'Zr', // Zręczność
    'Int',// Inteligencja
    'SW', // Siła woli
    'Ogd' // Ogłada/Charyzma
  ];

  static const List<String> _secondaryKeys = [
    'A',   // Ataki
    'Żyw', // Rany/Żywotność
    'Ruch',
    'Mag',
    'PO',  // Punkty obłędu / szaleństwa
    'PP',  // Punkty przeznaczenia / losu
  ];

  // Mapy: początkowa / schemat / aktualna
  late Map<String, int> _primaryInitial;
  late Map<String, int> _primaryScheme;
  late Map<String, int> _primaryCurrent;

  late Map<String, int> _secondaryInitial;
  late Map<String, int> _secondaryScheme;
  late Map<String, int> _secondaryCurrent;

  Profession? _selectedProfession;

  // Demo profesje potem słownik z backendu
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

  Widget _spaced(Widget child) {
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: child);
  }

  @override
  void initState() {
    super.initState();
    _selectedCampaignId = widget.initialCampaignId;
    _loadCampaigns();

    _primaryInitial = {for (final k in _primaryKeys) k: 0};
    _primaryScheme = {for (final k in _primaryKeys) k: 0};
    _primaryCurrent = {for (final k in _primaryKeys) k: 0};

    _secondaryInitial = {for (final k in _secondaryKeys) k: 0};
    _secondaryScheme = {for (final k in _secondaryKeys) k: 0};
    _secondaryCurrent = {for (final k in _secondaryKeys) k: 0};
  }

  Future<void> _loadCampaigns() async {
    final campaigns = await CampaignService.fetchCampaigns();
    setState(() => _campaigns = campaigns);
  }

  void _onProfessionSelected(Profession? p) {
    setState(() {
      _selectedProfession = p;
      if (p != null) {
        // Schemat rozwoju = podgląd. Nie ruszam narazie current/initial.
        _primaryScheme = {for (final k in _primaryKeys) k: p.primaryScheme[k] ?? 0};
        _secondaryScheme = {for (final k in _secondaryKeys) k: p.secondaryScheme[k] ?? 0};

        // Opcjonalnie: uzupełniam _career z profesji 
        _career ??= p.name;
      } else {
        _primaryScheme = {for (final k in _primaryKeys) k: 0};
        _secondaryScheme = {for (final k in _secondaryKeys) k: 0};
      }
    });
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCampaignId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Wybierz kampanię")));
      return;
    }
    _formKey.currentState!.save();

    // UI liczy: Aktualna = Początkowa (Base) + Schemat.
    _recalcCurrent();

    final newCharacter = PlayableCharacter(
      id: 0, // API powinno nadać ID
      characterType: _characterType,
      campaignId: _selectedCampaignId!,
      name: _name ?? '',
      race: _race ?? '',
      career: _careerCtrl.text.isNotEmpty ? _careerCtrl.text : (_selectedProfession?.name ?? ''),
      age: _age ?? 0,

      // Current
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

      // Base
      baseBallisticSkill: _primaryInitial['US'] ?? 0,
      baseStrength: _primaryInitial['S'] ?? 0,
      baseToughness: _primaryInitial['Wt'] ?? 0,
      baseAgility: _primaryInitial['Zr'] ?? 0,
      baseIntelligence: _primaryInitial['Int'] ?? 0,
      baseWillPower: _primaryInitial['SW'] ?? 0,
      baseFellowship: _primaryInitial['Ogd'] ?? 0,
      baseAttacks: _secondaryInitial['A'] ?? 0,
      baseWounds: _secondaryInitial['Żyw'] ?? 0,
      baseMovement: _secondaryInitial['Ruch'] ?? 0,
      baseMagic: _secondaryInitial['Mag'] ?? 0,
      baseInsanityPoints: _secondaryInitial['PO'] ?? 0,
      baseFatePoints: _secondaryInitial['PP'] ?? 0,
    );

    try {
      await CharacterService.createCharacter(newCharacter);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Postać została utworzona")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Błąd podczas tworzenia: $e")),
      );
    }
  }

  int _parseInt(String s, int fallback) => int.tryParse(s.trim()) ?? fallback;

  void _recalcCurrent() {
    for (final k in _primaryKeys) {
      _primaryCurrent[k] = (_primaryInitial[k] ?? 0) + (_primaryScheme[k] ?? 0);
    }
    for (final k in _secondaryKeys) {
      _secondaryCurrent[k] = (_secondaryInitial[k] ?? 0) + (_secondaryScheme[k] ?? 0);
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
      appBar: AppBar(title: const Text("Utwórz postać")),
      body: _campaigns.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const WarhammerStatsLegendTile(),
                    const SizedBox(height: 16),
                    if (widget.initialCampaignId == null)
                      _spaced(
                        DropdownButtonFormField<int>(
                          initialValue: _selectedCampaignId,
                          items: _campaigns
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                ),
                              )
                              .toList(),
                          decoration: const InputDecoration(labelText: 'Kampania'),
                          onChanged: (value) =>
                              setState(() => _selectedCampaignId = value),
                          validator: (value) =>
                              value == null ? "Wybierz kampanię" : null,
                        ),
                      ),

                    _spaced(
                      DropdownButtonFormField<int>(
                        value: _characterType,
                        decoration: const InputDecoration(labelText: 'Typ postaci'),
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('Gracz (Playable)')),
                          DropdownMenuItem(value: 1, child: Text('NPC (Npc)')),
                        ],
                        onChanged: (v) => setState(() => _characterType = v ?? 0),
                      ),
                    ),

                    _spaced(
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Imię'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Wpisz imię' : null,
                        onSaved: (value) => _name = value,
                      ),
                    ),

                    // RASA – na razie tekst, potem podmieni na select z backendu
                    _spaced(
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Rasa'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Wpisz rasę' : null,
                        onSaved: (value) => _race = value,
                      ),
                    ),

                    // PROFESJA – select, który zmienia "schemat rozwoju"
                    _spaced(
                      DropdownButtonFormField<Profession>(
                        value: _selectedProfession,
                        decoration: const InputDecoration(labelText: 'Profesja'),
                        items: demoProfessions
                            .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                            .toList(),
                        onChanged: _onProfessionSelected,
                        validator: (p) => p == null ? 'Wybierz profesję' : null,
                      ),
                    ),

                    _spaced(
                      TextFormField(
                        controller: _careerCtrl,
                        decoration: const InputDecoration(labelText: 'Profesja / klasa (tekst)'),
                        onSaved: (_) => _career = _careerCtrl.text,
                      ),
                    ),

                    _spaced(
                      TextFormField(
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
                      onInitialChanged: (k, v) => setState(() { _primaryInitial[k] = v; _recalcCurrent(); }),
                      onSchemeChanged: (k, v) => setState(() { _primaryScheme[k] = v; _recalcCurrent(); }),
                      parseInt: _parseInt,
                    ),

                    const SizedBox(height: 16),

                    StatsTable(
                      title: 'Cechy drugorzędne',
                      keys: _secondaryKeys,
                      initial: _secondaryInitial,
                      scheme: _secondaryScheme,
                      current: _secondaryCurrent,
                      onInitialChanged: (k, v) => setState(() { _secondaryInitial[k] = v; _recalcCurrent(); }),
                      onSchemeChanged: (k, v) => setState(() { _secondaryScheme[k] = v; _recalcCurrent(); }),
                      parseInt: _parseInt,
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveCharacter,
                        child: const Text("Utwórz"),
                      ),
                    ),
                  ],
                ),
              ),
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

  final void Function(String key, int value) onInitialChanged;
  final void Function(String key, int value) onSchemeChanged;

  final int Function(String s, int fallback) parseInt;

  const StatsTable({
    super.key,
    required this.title,
    required this.keys,
    required this.initial,
    required this.scheme,
    required this.current,
    required this.onInitialChanged,
    required this.onSchemeChanged,
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
                onInitialChanged: (v) => onInitialChanged(k, v),
                onSchemeChanged: (v) => onSchemeChanged(k, v),
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
  final ValueChanged<int> onInitialChanged;
  final ValueChanged<int> onSchemeChanged;
  final int Function(String s, int fallback) parseInt;

  const _StatRow({
    required this.label,
    required this.initialValue,
    required this.schemeValue,
    required this.currentValue,
    required this.onInitialChanged,
    required this.onSchemeChanged,
    required this.parseInt,
  });

  @override
  State<_StatRow> createState() => _StatRowState();
}

class _StatRowState extends State<_StatRow> {
  late final TextEditingController _initialCtrl;
  late final TextEditingController _schemeCtrl;

  @override
  void initState() {
    super.initState();
    _initialCtrl = TextEditingController(text: widget.initialValue.toString());
    _schemeCtrl = TextEditingController(text: widget.schemeValue.toString());
  }

  @override
  void didUpdateWidget(covariant _StatRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    // jeśli stan z zewnątrz się zmienia, aktualizujemy kontrolery
    if (oldWidget.initialValue != widget.initialValue &&
        _initialCtrl.text != widget.initialValue.toString()) {
      _initialCtrl.text = widget.initialValue.toString();
    }
    if (oldWidget.schemeValue != widget.schemeValue &&
        _schemeCtrl.text != widget.schemeValue.toString()) {
      _schemeCtrl.text = widget.schemeValue.toString();
    }
  }

  @override
  void dispose() {
    _initialCtrl.dispose();
    _schemeCtrl.dispose();
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
            child: TextFormField(
              controller: _initialCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              ),
              onChanged: (s) =>
                  widget.onInitialChanged(widget.parseInt(s, widget.initialValue)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _schemeCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              ),
              onChanged: (s) =>
                  widget.onSchemeChanged(widget.parseInt(s, widget.schemeValue)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.currentValue.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
