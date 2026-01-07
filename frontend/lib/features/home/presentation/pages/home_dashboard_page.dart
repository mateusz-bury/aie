import 'package:aie/features/auth/domain/user.dart';
import 'package:aie/features/campaigns/presentation/pages/campaigns_page.dart';
import 'package:aie/features/characters/presentation/pages/characters_page.dart';
import 'package:aie/features/items/presentation/pages/items_page.dart';
import 'package:flutter/material.dart';

class HomeDashboardPage extends StatelessWidget {
  final User user;
  const HomeDashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('AIE – ${user.username}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Menu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _Tile(
                    icon: Icons.flag,
                    title: 'Moje kampanie',
                    subtitle: 'Lista, tworzenie, edycja',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CampaignsPage()),
                      );
                    },
                  ),
                  _Tile(
                    icon: Icons.person,
                    title: 'Moje postacie',
                    subtitle: 'CRUD + przypisanie',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CharactersPage()),
                      );
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
              Icon(icon, size: 36),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
