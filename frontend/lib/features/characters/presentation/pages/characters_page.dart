import 'package:aie/features/characters/data/character_service.dart';
import 'package:aie/features/characters/domain/character.dart';
import 'package:aie/features/characters/presentation/pages/create_playable_character_page.dart';
import 'package:aie/features/characters/presentation/pages/playable_character_page.dart';
import 'package:flutter/material.dart';
import 'package:aie/core/widgets/aie_background.dart';
import 'package:aie/core/theme/app_colors.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  bool _loading = true;
  List<Character> _characters = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final ch = await CharacterService.fetchCharacters();
    if (!mounted) return;
    setState(() {
      _characters = ch;
      _loading = false;
    });
  }

  Future<void> _create() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreatePlayableCharacterPage()),
    );
    if (created == true) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moje postacie')),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: _create,
        child: const Icon(Icons.add),
      ),
      body: AieBackground(
        child: Column(
          children: [
            const SizedBox(height: 56),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(4),
                        itemCount: _characters.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final ch = _characters[i];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.group, color: AppColors.accent),
                              title: Text(ch.name),
                              subtitle: Text(
                                '${ch.race} • ${ch.career}',
                                style: const TextStyle(color: AppColors.textMuted),
                              ),
                              trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                              onTap: () async {
                                final changed = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlayableCharacterPage(characterId: ch.id),
                                  ),
                                );
                                if (changed == true) {
                                  await _load();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
