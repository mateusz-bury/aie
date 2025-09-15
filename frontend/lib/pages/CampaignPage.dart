import 'package:flutter/material.dart';
import 'EditCampaignPage.dart';
import 'EditPlayableCharacterPage.dart'; // zakładam, że masz taką stronę
import '../service/CampaignService.dart';
import '../models/CampaignById.dart';

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

  Future<void> _goToEditCharacter(int characterId) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditPlayableCharacterPage(characterId: characterId),
      ),
    );

    if (updated == true) {
      // Odśwież dane po powrocie z edycji postaci
      setState(() {
        _loadCampaign();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kampania")),
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
                ElevatedButton(
                  onPressed: () => _goToEditPage(campaign),
                  child: const Text("Edytuj kampanię"),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Postacie w kampanii:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ...campaign.playableCharacters.map(
                  (pc) => ListTile(
                    title: Text(pc.name),
                    subtitle: Text("${pc.race} - ${pc.career}"),
                    trailing: ElevatedButton(
                      onPressed: () => _goToEditCharacter(pc.id),
                      child: const Text("Edytuj"),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
