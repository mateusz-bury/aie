import 'package:flutter/material.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:aie/features/auth/domain/user.dart';
import 'package:aie/features/auth/presentation/pages/account_settings_page.dart';
import 'package:aie/features/campaigns/data/campaign_service.dart';
import 'package:aie/features/campaigns/domain/campaign.dart';
import 'package:aie/features/campaigns/presentation/pages/campaign_page.dart';
import 'package:aie/features/campaigns/presentation/pages/create_campaign_page.dart';
import 'package:aie/features/characters/data/character_service.dart';
import 'package:aie/features/characters/domain/character.dart';
import 'package:aie/features/characters/presentation/pages/create_playable_character_page.dart';
import 'package:aie/features/characters/presentation/pages/playable_character_page.dart';

class UserPage extends StatefulWidget {
  final User user;

  const UserPage({super.key, required this.user});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Campaign> campaigns = [];
  List<Character> characters = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final fetchedCampaigns = await CampaignService.fetchCampaigns();
    final fetchedCharacters = await CharacterService.fetchCharacters();

    setState(() {
      campaigns = fetchedCampaigns;
      characters = fetchedCharacters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Witaj, ${widget.user.username}!'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AccountSettingsPage(user: widget.user),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                AuthService.logOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(),
                const SizedBox(height: 20),
                _buildSectionTitle('Moje kampanie'),
                const SizedBox(height: 8),
                _buildCampaignsList(),
                const SizedBox(height: 20),
                _buildSectionTitle('Moje postacie'),
                const SizedBox(height: 8),
                _buildCharactersList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.user.username}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.user.username,
                    style: const TextStyle(color: Colors.transparent),
                  ),
                  Text(
                    '@${widget.user.username}',
                    style: const TextStyle(color: Colors.transparent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCampaignsList() {
    List<Widget> campaignWidgets =
        campaigns
            .map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: const Icon(Icons.flag),
                    title: Text(c.name),
                    subtitle: Text(c.description),
                    onTap: () async {
                      final created = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CampaignPage(campaignId: c.id),
                        ),
                      );

                      if (created == true) {
                        await _loadUserData();
                      }
                    },
                  ),
                ),
              ),
            )
            .toList();

    campaignWidgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.blue),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: const Icon(Icons.add),
            title: const Text(
              "Utwórz nową kampanię",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateCampaignPage()),
              );

              if (created == true) {
                await _loadUserData();
              }
            },
          ),
        ),
      ),
    );

    if (campaignWidgets.isEmpty) return const Text("Brak kampanii");

    return Column(children: campaignWidgets);
  }

 Widget _buildCharactersList() {
  List<Widget> characterWidgets = characters
      .map(
        (ch) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(ch.name),
              subtitle: Text("Klasa: ${ch.career}, Rasa: ${ch.race}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PlayableCharacterPage(characterId: ch.id),
                  ),
                );
              },
            ),
          ),
        ),
      )
      .toList();

    characterWidgets.add(
    Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.blue),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: const Icon(Icons.add),
          title: const Text(
            "Stwórz nową postać",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            final created = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePlayableCharacterPage(),
              ),
            );

            if (created == true) {
              await _loadUserData();
            }
          },
        ),
      ),
    ),
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: characterWidgets,
  );
}
}
