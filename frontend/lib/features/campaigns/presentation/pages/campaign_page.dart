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
  late Future<CampaignById> _campaignFuture;

  @override
  void initState() {
    super.initState();
    _loadCampaign();
  }

  void _loadCampaign() {
    _campaignFuture = CampaignService.fetchCampaignById(widget.campaignId);
  }

  Future<void> _goToEditPage(CampaignById campaign) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditCampaignPage(campaign: campaign)),
    );
    if (updated == true) {
      setState(() {
        _loadCampaign();
      });
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
      setState(() {
        _loadCampaign();
      });
    }
  }

  Future<void> _goToCreateCharacter(int campaignId) async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePlayableCharacterPage(initialCampaignId: campaignId),
      ),
    );
    if (created == true) {
      setState(() {
        _loadCampaign();
      });
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
              child: all.isEmpty
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("Kampania"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddCharacterSheet,
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<CampaignById>(
          future: _campaignFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Błąd: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("Brak danych kampanii"));
            }

            final campaign = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                color: Colors.transparent,
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
                                              () => Navigator.of(
                                                context,
                                              ).pop(true),
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
                      "Postacie w kampanii:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCharacters(campaign.characters),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCharacters(List<Character> characters) {
    if (characters.isEmpty) return const Text("Brak postaci");
    return Column(
      children:
          characters.map(
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
