import 'package:aie/features/campaigns/data/campaign_service.dart';
import 'package:aie/features/campaigns/domain/campaign_by_id.dart';
import 'package:aie/features/campaigns/presentation/pages/edit_campaign_page.dart';
import 'package:aie/features/characters/presentation/pages/create_playable_character_page.dart';
import 'package:aie/features/characters/presentation/pages/edit_playable_character_page.dart';
import 'package:aie/features/characters/domain/character.dart';
import 'package:aie/features/characters/data/character_service.dart';
import 'package:flutter/material.dart';

class CampaignPage extends StatefulWidget {
  final int campaignId;

  const CampaignPage({super.key, required this.campaignId});

  @override
  State<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  late Future<_CampaignViewData> _viewFuture;

  int _selectedCharactersTab = 0; // 0 = Playable, 1 = NPC

  @override
  void initState() {
    super.initState();
    _loadCampaign();
  }

  void _loadCampaign() {
    _viewFuture = _loadView();
  }

  Future<_CampaignViewData> _loadView() async {
    final campaign = await CampaignService.fetchCampaignById(widget.campaignId);

    // Preferujemy dedykowane endpointy (backend: /playable-characters i /npc-characters).
    // Jeśli backend zwraca pustki / błąd, fallbackujemy do starego pola campaign.characters.
    final playable = await CampaignService.fetchPlayableCharacters(widget.campaignId);
    final npcs = await CampaignService.fetchNpcCharacters(widget.campaignId);

    final hasNewData = playable.isNotEmpty || npcs.isNotEmpty;
    if (hasNewData) {
      return _CampaignViewData(campaign: campaign, playable: playable, npcs: npcs);
    }

    // Fallback na stare dane (często null w backendzie, ale niech działa na starszych buildach).
    final oldPlayable =
        campaign.characters.where((c) => _getCharacterType(c) == 0).toList();
    final oldNpcs =
        campaign.characters.where((c) => _getCharacterType(c) == 1).toList();
    return _CampaignViewData(
      campaign: campaign,
      playable: oldPlayable,
      npcs: oldNpcs,
    );
  }

  Future<void> _goToEditPage(CampaignById campaign) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditCampaignPage(campaign: campaign)),
    );
    if (updated == true) {
      setState(() => _loadCampaign());
    }
  }

  Future<void> _deleteCampaign(CampaignById campaign) async {
    try {
      final deleted = await CampaignService.deleteCampaign(campaign.id);

      if (deleted == true) {
        if (!mounted) return;
        // Po usunięciu wracamy na stronę startową i przekazujemy true, żeby odświeżyć listę
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd przy usuwaniu kampanii: $e')),
      );
    }
  }

  Future<void> _goToEditCharacter(int characterId) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditPlayableCharacterPage(characterId: characterId),
      ),
    );
    if (updated == true) {
      setState(() => _loadCampaign());
    }
  }

  Future<void> _goToCreateCharacter(int campaignId) async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => CreatePlayableCharacterPage(initialCampaignId: campaignId),
      ),
    );
    if (created == true) {
      setState(() => _loadCampaign());
    }
  }

  Future<void> _showAddCharacterSheet() async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Utwórz nową postać w tej kampanii'),
                onTap: () {
                  Navigator.pop(context);
                  _goToCreateCharacter(widget.campaignId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Dodaj istniejącą postać do kampanii'),
                subtitle: const Text('Przypina postać do tej kampanii'),
                onTap: () {
                  Navigator.pop(context);
                  _pickExistingCharacter();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickExistingCharacter() async {
    try {
      final all = await CharacterService.fetchCharacters();
      if (!mounted) return;

      final selected = await showDialog<Character>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Wybierz postać'),
            content: SizedBox(
              width: double.maxFinite,
              child:
                  all.isEmpty
                      ? const Text('Brak postaci do przypisania')
                      : ListView.builder(
                        shrinkWrap: true,
                        itemCount: all.length,
                        itemBuilder: (context, i) {
                          final ch = all[i];
                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(ch.name),
                            subtitle: Text('${ch.race} – ${ch.career}'),
                            onTap: () => Navigator.pop(context, ch),
                          );
                        },
                      ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Anuluj'),
              ),
            ],
          );
        },
      );

      if (selected == null) return;
      await CharacterService.assignCharacterToCampaign(
        characterId: selected.id,
        campaignId: widget.campaignId,
      );
      setState(() => _loadCampaign());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nie udało się dodać postaci: $e')),
      );
    }
  }

  // 0=Playable, 1=NPC (backend enum). Jeśli nie ma pola -> default 0.
  int _getCharacterType(Character ch) {
    try {
      final dyn = ch as dynamic;
      final v = dyn.characterType;
      if (v is int) return v;
      if (v == null) return 0;
      final s = v.toString().toLowerCase();
      if (s.contains('npc')) return 1;
      if (s.contains('template')) return 2;
      return int.tryParse(s) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Kampania"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCharacterSheet,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<_CampaignViewData>(
        future: _viewFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Błąd: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Brak danych kampanii"));
          }

          final data = snapshot.data!;
          final campaign = data.campaign;
          final playable = data.playable;
          final npcs = data.npcs;

          final shown = _selectedCharactersTab == 0 ? playable : npcs;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(campaign.description),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _goToEditPage(campaign),
                          child: const Text("Edytuj kampanię"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Wyświetlenie okna potwierdzenia
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Potwierdzenie'),
                                    content: const Text(
                                      'Czy na pewno chcesz usunąć tę kampanię?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(
                                              context,
                                            ).pop(false),
                                        child: const Text('Anuluj'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () =>
                                                Navigator.of(context).pop(true),
                                        child: const Text(
                                          'Usuń',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm == true) {
                              await _deleteCampaign(campaign);
                            }
                          },
                          child: const Text("Usuń kampanię"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Postacie",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Dwa kafle jak w menu głównym
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _CampaignTile(
                        icon: Icons.person,
                        title: 'Postacie graczy',
                        subtitle: '${playable.length} szt.',
                        isSelected: _selectedCharactersTab == 0,
                        onTap: () => setState(() => _selectedCharactersTab = 0),
                      ),
                      _CampaignTile(
                        icon: Icons.groups,
                        title: 'NPC',
                        subtitle: '${npcs.length} szt.',
                        isSelected: _selectedCharactersTab == 1,
                        onTap: () => setState(() => _selectedCharactersTab = 1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Text(
                    _selectedCharactersTab == 0
                        ? 'Postacie graczy w kampanii:'
                        : 'NPC w kampanii:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _buildCharacters(
                    shown,
                    emptyText:
                        _selectedCharactersTab == 0
                            ? 'Brak postaci graczy w tej kampanii'
                            : 'Brak NPC w tej kampanii',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCharacters(
    List<Character> characters, {
    String emptyText = "Brak postaci",
  }) {
    if (characters.isEmpty) return Text(emptyText);
    return Column(
      children:
          characters
              .map(
                (ch) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(ch.name),
                      subtitle: Text("${ch.race} - ${ch.career}"),
                      trailing: ElevatedButton(
                        onPressed: () => _goToEditCharacter(ch.id),
                        child: const Text("Edytuj"),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

class _CampaignViewData {
  final CampaignById campaign;
  final List<Character> playable;
  final List<Character> npcs;

  const _CampaignViewData({
    required this.campaign,
    required this.playable,
    required this.npcs,
  });
}

class _CampaignTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _CampaignTile({
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
