import 'package:aie/features/characters/data/character_service.dart';
import 'package:aie/features/characters/domain/playable_character.dart';
import 'package:aie/features/characters/presentation/pages/edit_playable_character_page.dart';
import 'package:aie/features/abilities/data/ability_service.dart';
import 'package:aie/features/abilities/data/character_ability_service.dart';
import 'package:aie/features/abilities/domain/ability.dart';
import 'package:aie/features/items/presentation/pages/character_inventory_page.dart';
import 'package:aie/features/skills/data/character_skill_service.dart';
import 'package:aie/features/skills/data/skill_service.dart';
import 'package:aie/features/skills/domain/skill.dart';
import 'package:flutter/material.dart';

class PlayableCharacterPage extends StatefulWidget {
  final int characterId;

  const PlayableCharacterPage({super.key, required this.characterId});

  @override
  State<PlayableCharacterPage> createState() => _PlayableCharacterPageState();
}

class _PlayableCharacterPageState extends State<PlayableCharacterPage> {
  late Future<PlayableCharacter> _characterFuture;

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  void _loadCharacter() {
    _characterFuture = CharacterService.fetchCharacterById(widget.characterId);
  }

  void _reloadCharacter() {
    setState(_loadCharacter);
  }

  Future<void> _goToEditCharacter(int characterId) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditPlayableCharacterPage(characterId: characterId),
      ),
    );
    if (updated == true) {
      setState(() {
        _loadCharacter();
      });
    }
  }

  Future<void> _deleteCharacter(int characterId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Usunąć postać?'),
            content: const Text('Tej operacji nie da się cofnąć.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Anuluj'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Usuń'),
              ),
            ],
          ),
    );

    if (ok != true) return;

    try {
      await CharacterService.deleteCharacter(characterId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Postać usunięta')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd usuwania: $e')));
    }
  }

  Future<void> _showDetails({required String title, required String description}) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(description.isEmpty ? 'Brak opisu.' : description),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<T?> _pickFromList<T>({
    required String title,
    required List<T> items,
    required String Function(T) label,
    String Function(T)? subtitle,
  }) async {
    if (items.isEmpty) return null;

    String query = '';
    return await showDialog<T>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            final filtered = items
                .where((it) => label(it).toLowerCase().contains(query.toLowerCase()))
                .toList();

            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Szukaj',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (v) => setStateDialog(() => query = v),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 360,
                      child: filtered.isEmpty
                          ? const Center(child: Text('Brak wyników'))
                          : ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, i) {
                                final it = filtered[i];
                                final sub = subtitle?.call(it);
                                return ListTile(
                                  title: Text(label(it)),
                                  subtitle: sub == null || sub.isEmpty ? null : Text(sub),
                                  onTap: () => Navigator.pop<T>(ctx, it),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Anuluj')),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addSkill(PlayableCharacter c) async {
    try {
      final all = await SkillService.fetchSkills();
      final assignedIds = c.skills.map((e) => e.id).toSet();
      final available = all.where((s) => !assignedIds.contains(s.id)).toList();
      if (!mounted) return;

      if (available.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Brak nowych skilli do dodania.')));
        return;
      }

      final picked = await _pickFromList<Skill>(
        title: 'Dodaj skilla',
        items: available,
        label: (s) => s.name,
        subtitle: (s) => s.type.isEmpty && s.skillType.isEmpty ? s.description : '${s.type} • ${s.skillType}',
      );
      if (picked == null) return;

      await CharacterSkillService.addSkill(characterId: c.id, skillId: picked.id);
      if (!mounted) return;
      setState(_loadCharacter);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dodano skilla: ${picked.name}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  Future<void> _removeSkill(PlayableCharacter c, Skill s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usunąć skilla?'),
        content: Text(s.name),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Anuluj')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Usuń')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await CharacterSkillService.removeSkill(characterId: c.id, skillId: s.id);
      if (!mounted) return;
      setState(_loadCharacter);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usunięto skilla: ${s.name}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  Future<void> _addAbility(PlayableCharacter c) async {
    try {
      final all = await AbilityService.fetchAbilities();
      final assignedIds = c.abilities.map((e) => e.id).toSet();
      final available = all.where((a) => !assignedIds.contains(a.id)).toList();
      if (!mounted) return;

      if (available.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Brak nowych ability do dodania.')));
        return;
      }

      final picked = await _pickFromList<Ability>(
        title: 'Dodaj ability',
        items: available,
        label: (a) => a.name,
        subtitle: (a) => a.description,
      );
      if (picked == null) return;

      await CharacterAbilityService.addAbility(characterId: c.id, abilityId: picked.id);
      if (!mounted) return;
      setState(_loadCharacter);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dodano ability: ${picked.name}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  Future<void> _removeAbility(PlayableCharacter c, Ability a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usunąć ability?'),
        content: Text(a.name),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Anuluj')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Usuń')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await CharacterAbilityService.removeAbility(characterId: c.id, abilityId: a.id);
      if (!mounted) return;
      setState(_loadCharacter);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usunięto ability: ${a.name}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("Postać"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteCharacter(widget.characterId),
            ),
          ],
        ),
        body: FutureBuilder<PlayableCharacter>(
          future: _characterFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Błąd: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("Brak danych postaci"));
            }

            final c = snapshot.data!;

            String typeLabel(int t) {
              switch (t) {
                case 1:
                  return 'NPC';
                case 2:
                  return 'Template';
                case 0:
                default:
                  return 'Playable';
              }
            }

            IconData typeIcon(int t) {
              switch (t) {
                case 1:
                  return Icons.theater_comedy;
                case 2:
                  return Icons.copy;
                case 0:
                default:
                  return Icons.person;
              }
            }

            // "career" bywa wpisywane jako "Profesja / Klasa" – rozdzielamy heurystycznie, żeby ładnie to pokazać.
            (String profession, String klass) splitCareer(String career) {
              final raw = career.trim();
              if (raw.isEmpty) return ('', '');

              for (final sep in ['/', '|', ' - ', ' – ', '–', '-']) {
                if (raw.contains(sep)) {
                  final parts = raw.split(sep).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                  if (parts.length >= 2) return (parts[0], parts[1]);
                }
              }
              return (raw, '');
            }

            final (_, klass) = splitCareer(c.career);
            final profession = c.career;

            Widget infoTile({required IconData icon, required String label, required String value}) {
              return ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(icon),
                title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(value.isEmpty ? '—' : value),
                contentPadding: EdgeInsets.zero,
              );
              }
            final stats = {
              'Umiejętność strzelecka': c.ballisticSkill,
              'Siła': c.strength,
              'Wytrzymałość': c.toughness,
              'Zręczność': c.agility,
              'Inteligencja': c.intelligence,
              'Siła woli': c.willPower,
              'Charyzma': c.fellowship,
              'Ataki': c.attacks,
              'Rany': c.wounds,
              'Ruch': c.movement,
              'Magia': c.magic,
              'Punkty szaleństwa': c.insanityPoints,
              'Punkty losu': c.fatePoints,
            };

            return SingleChildScrollView(
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(typeIcon(c.characterType), size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    c.name,
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Chip(label: Text(typeLabel(c.characterType))),
                              ],
                            ),
                            const SizedBox(height: 8),

                            infoTile(icon: Icons.public, label: 'Rasa', value: c.race),
                            infoTile(icon: Icons.work, label: 'Profesja', value: profession),
                            infoTile(icon: Icons.shield, label: 'Klasa', value: klass),
                            infoTile(icon: Icons.cake, label: 'Wiek', value: c.age.toString()),
                            const Divider(height: 24),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _goToEditCharacter(c.id),
                                  child: const Text('Edytuj postać'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => CharacterInventoryPage(
                                              characterId: c.id,
                                              characterName: c.name,
                                            ),
                                      ),
                                    );
                                  },
                                  child: const Text('Ekwipunek'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Atrybuty postaci",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                          },
                          children:
                              stats.entries
                                  .map(
                                    (entry) => TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Text(
                                            entry.key,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Center(
                                            child: Text(entry.value.toString()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Skille',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Dodaj skilla',
                          icon: const Icon(Icons.add),
                          onPressed: () => _addSkill(c),
                        ),
                      ],
                    ),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: c.skills.isEmpty
                            ? const Text('Brak skilli')
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: c.skills
                                    .map(
                                      (s) => InputChip(
                                        label: Text(s.name),
                                        onPressed: () => _showDetails(title: s.name, description: s.description),
                                        onDeleted: () => _removeSkill(c, s),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Abilities',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Dodaj ability',
                          icon: const Icon(Icons.add),
                          onPressed: () => _addAbility(c),
                        ),
                      ],
                    ),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: c.abilities.isEmpty
                            ? const Text('Brak ability')
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: c.abilities
                                    .map(
                                      (a) => InputChip(
                                        label: Text(a.name),
                                        onPressed: () => _showDetails(title: a.name, description: a.description),
                                        onDeleted: () => _removeAbility(c, a),
                                      ),
                                    )
                                    .toList(),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
