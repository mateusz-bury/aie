// lib/pages/UserPage.dart
import 'package:flutter/material.dart';
import '../service/AuthService.dart';
import 'package:aie/pages/AccountSettingPage.dart';
import 'package:aie/layouts/LayoutContainer.dart';

class UserPage extends StatefulWidget {
  final User user;

  const UserPage({super.key, required this.user});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Map<String, dynamic>> campaigns = [];
  List<Map<String, dynamic>> characters = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // TODO: api kampanie

    setState(() {
      // placeholdery dla kampani i postaci
      campaigns = [
        {"name": "Kampania 1", "description": "Opis kampanii 1..."},
        {"name": "Kampania 2", "description": "Opis kampanii 2..."},
      ];
      characters = [
        {"name": "Postać 1", "class": "Wojownik", "level": 5},
        {"name": "Postać 2", "class": "Mag", "level": 3},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Witaj, ${widget.user.firstName}!'),
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
                //AuthService.logout();
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
                _buildCampaignsList(),
                const SizedBox(height: 20),
                _buildSectionTitle('Moje postacie'),
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
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/default_avatar.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.user.firstName} ${widget.user.lastName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.user.email,
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
    if (campaigns.isEmpty) {
      return const Text("Brak kampanii");
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children:
            campaigns.map((c) {
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: Text(c["name"]),
                    subtitle: Text(c["description"]),
                    onTap: () {
                      // TODO: api kampani
                    },
                  ),
                  const Divider(height: 0),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCharactersList() {
    if (characters.isEmpty) {
      return const Text("Brak postaci");
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children:
            characters.map((ch) {
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(ch["name"]),
                    subtitle: Text(
                      "Klasa: ${ch["class"]}, Poziom: ${ch["level"]}",
                    ),
                    onTap: () {
                      // TODO: api PlayableCharakter
                    },
                  ),
                  const Divider(height: 0),
                ],
              );
            }).toList(),
      ),
    );
  }
}
