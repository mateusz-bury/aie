import 'package:aie/features/characters/data/character_service.dart';
import 'package:aie/features/characters/domain/playable_character.dart';
import 'package:aie/features/characters/presentation/pages/edit_playable_character_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("Postać"),
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
                            Text(
                              c.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Rasa: ${c.race}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Klasa: ${c.career}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Wiek: ${c.age}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _goToEditCharacter(c.id),
                              child: const Text("Edytuj postać"),
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
