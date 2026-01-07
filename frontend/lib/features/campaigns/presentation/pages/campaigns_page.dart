import 'package:aie/features/campaigns/data/campaign_service.dart';
import 'package:aie/features/campaigns/domain/campaign.dart';
import 'package:aie/features/campaigns/presentation/pages/campaign_page.dart';
import 'package:aie/features/campaigns/presentation/pages/create_campaign_page.dart';
import 'package:flutter/material.dart';
import 'package:aie/core/widgets/aie_background.dart';
import 'package:aie/core/theme/app_colors.dart';

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({super.key});

  @override
  State<CampaignsPage> createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> {
  List<Campaign> _campaigns = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await CampaignService.fetchCampaigns();
    if (!mounted) return;
    setState(() {
      _campaigns = data;
      _loading = false;
    });
  }

  Future<void> _create() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateCampaignPage()),
    );
    if (created == true) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moje kampanie')),
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
                        itemCount: _campaigns.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final c = _campaigns[i];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.map, color: AppColors.accent),
                              title: Text(c.name),
                              subtitle: Text(
                                c.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.textMuted),
                              ),
                              trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                              onTap: () async {
                                final changed = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => CampaignPage(campaignId: c.id)),
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
