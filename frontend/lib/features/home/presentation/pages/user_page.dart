import 'package:aie/features/auth/data/auth_service.dart';
import 'package:aie/features/auth/domain/user.dart';
import 'package:aie/features/auth/presentation/pages/account_settings_page.dart';
import 'package:aie/features/campaigns/data/campaign_service.dart';
import 'package:aie/features/characters/data/character_service.dart';
import 'package:aie/features/campaigns/presentation/pages/campaigns_page.dart';
import 'package:aie/features/characters/presentation/pages/characters_page.dart';
import 'package:aie/features/items/presentation/pages/items_page.dart';
import 'package:flutter/material.dart';
import 'package:aie/core/widgets/aie_background.dart';
import 'package:aie/core/theme/app_colors.dart';

class UserPage extends StatefulWidget {
  final User user;

  const UserPage({super.key, required this.user});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _campaignsCount = 0;
  int _charactersCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    setState(() => _loading = true);
    final campaigns = await CampaignService.fetchCampaigns();
    final characters = await CharacterService.fetchCharacters();
    if (!mounted) return;
    setState(() {
      _campaignsCount = campaigns.length;
      _charactersCount = characters.length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('AIE – ${widget.user.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCounts,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AccountSettingsPage(user: widget.user)),
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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: AieBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const SizedBox(height: 56),
            const Text('Menu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            if (_loading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _Tile(
                      icon: Icons.map,
                      title: 'Moje kampanie',
                      subtitle: '$_campaignsCount kampanii',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CampaignsPage()),
                        );
                        await _loadCounts();
                      },
                    ),
                    _Tile(
                      icon: Icons.group,
                      title: 'Moje postacie',
                      subtitle: '$_charactersCount postaci',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CharactersPage()),
                        );
                        await _loadCounts();
                      },
                    ),
                    _Tile(
                      icon: Icons.inventory_2,
                      title: 'Przedmioty',
                      subtitle: 'Katalog itemów',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ItemsPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(icon, size: 34, color: AppColors.accent),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
              const Spacer(),
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_forward, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
