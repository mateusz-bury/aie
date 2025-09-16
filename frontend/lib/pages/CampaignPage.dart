import 'package:flutter/material.dart';
import '../layouts/UserPageLeyout.dart';
import 'EditCampaignPage.dart';
import 'EditPlayableCharacterPage.dart';
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
      setState(() {
        _loadCampaign();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserPageLeyout(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("Kampania"),
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
                    ElevatedButton(
                      onPressed: () => _goToEditPage(campaign),
                      child: const Text("Edytuj kampanię"),
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
                    _buildPlayableCharacters(campaign.playableCharacters),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlayableCharacters(List<dynamic> characters) {
    if (characters.isEmpty) return const Text("Brak postaci");
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
