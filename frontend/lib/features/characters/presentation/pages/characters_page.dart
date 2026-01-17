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

  int _selectedTab = 0; // 0 = Playable, 1 = NPC

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
    final playable = _characters.where((c) => c.characterType == 0).toList();
    final npcs = _characters.where((c) => c.characterType == 1).toList();
    final shown = _selectedTab == 0 ? playable : npcs;

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

            // DWA KAFLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _CharactersTile(
                    icon: Icons.person,
                    title: 'Postacie graczy',
                    subtitle: '${playable.length} szt.',
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                  _CharactersTile(
                    icon: Icons.groups,
                    title: 'NPC',
                    subtitle: '${npcs.length} szt.',
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: shown.isEmpty
                          ? ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                Text(
                                  _selectedTab == 0
                                      ? 'Brak postaci graczy.'
                                      : 'Brak NPC.',
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              itemCount: shown.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 6),
                              itemBuilder: (context, i) {
                                final ch = shown[i];
                                return Card(
                                  child: ListTile(
                                    dense: true,
                                    visualDensity: const VisualDensity(vertical: -2),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    leading: Icon(
                                      _selectedTab == 0
                                          ? Icons.person
                                          : Icons.groups,
                                      color: AppColors.accent,
                                    ),
                                    title: Text(ch.name),
                                    subtitle: Text(
                                      '${ch.race} • ${ch.career}',
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                      color: AppColors.textMuted,
                                    ),
                                    onTap: () async {
                                      // Na razie oba prowadzą do PlayableCharacterPage,
                                      // dopóki nie zrobicie osobnej strony NPC.
                                      final changed = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PlayableCharacterPage(
                                            characterId: ch.id,
                                          ),
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

class _CharactersTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _CharactersTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 36),
                  const Spacer(),
                  if (isSelected)
                    Icon(Icons.check_circle, color: theme.colorScheme.primary),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
              const Spacer(),
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
