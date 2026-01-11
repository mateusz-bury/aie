import 'package:flutter/material.dart';
import 'package:aie/core/theme/app_colors.dart';

/// Mały kafelek (pod nagłówkiem strony), który otwiera legendę skrótów Warhammera.
/// Cel: szybka "ściąga" bez rozwijania elementów listy.
class WarhammerStatsLegendTile extends StatelessWidget {
  const WarhammerStatsLegendTile({super.key});

  static const Map<String, String> _descriptions = {
    'US': 'Umiejętność Strzelecka – celność ataków dystansowych',
    'S': 'Siła – obrażenia w walce wręcz i testy siłowe',
    'Wt': 'Wytrzymałość – odporność na obrażenia i choroby',
    'Zr': 'Zręczność – refleks, uniki, testy manualne',
    'Int': 'Inteligencja – wiedza, nauka, rozumowanie',
    'SW': 'Siła Woli – odporność psychiczna, magia',
    'Ogd': 'Ogłada – charyzma, interakcje społeczne',
    'A': 'Ataki – liczba ataków w rundzie',
    'Żyw': 'Żywotność / Rany – ile obrażeń postać może przyjąć',
    'Ruch': 'Ruch – dystans poruszania się',
    'Mag': 'Magia – poziom mocy magicznej',
    'PO': 'Punkty Obłędu – wpływ Chaosu i szaleństwa',
    'PP': 'Punkty Przeznaczenia – ratunek przed śmiercią',
  };

  static const List<String> _primaryKeys = ['US','S','Wt','Zr','Int','SW','Ogd'];
  static const List<String> _secondaryKeys = ['A','Żyw','Ruch','Mag','PO','PP'];

  static const Map<String, IconData> _icons = {
    'US': Icons.gps_fixed, // celownik
    'S': Icons.sports_martial_arts, // walka
    'Wt': Icons.shield, // odporność
    'Zr': Icons.back_hand, // zręczność/manual
    'Int': Icons.menu_book, // wiedza
    'SW': Icons.psychology_alt, // wola/umysł
    'Ogd': Icons.record_voice_over, // gadka
    'A': Icons.flash_on, // ataki
    'Żyw': Icons.favorite, // rany
    'Ruch': Icons.directions_run, // ruch
    'Mag': Icons.auto_fix_high, // magia
    'PO': Icons.warning_amber_rounded, // obłęd
    'PP': Icons.star, // przeznaczenie
  };

  void _openLegend(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.accent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Legenda skrótów (Warhammer 2e)',
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      _SectionHeader(title: 'Cechy główne'),
                      const SizedBox(height: 6),
                      ..._primaryKeys.map((k) => _LegendRow(
                            keyLabel: k,
                            icon: _icons[k] ?? Icons.help_outline,
                            description: _descriptions[k] ?? '',
                          )),
                      const SizedBox(height: 14),
                      _SectionHeader(title: 'Cechy drugorzędne'),
                      const SizedBox(height: 6),
                      ..._secondaryKeys.map((k) => _LegendRow(
                            keyLabel: k,
                            icon: _icons[k] ?? Icons.help_outline,
                            description: _descriptions[k] ?? '',
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openLegend(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.accent.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.background2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withOpacity(0.35)),
              ),
              child: const Icon(Icons.menu_book, color: AppColors.accent, size: 18),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skróty cech – ściąga',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Tapnij, żeby zobaczyć wyjaśnienia (US, Wt, Żyw, PP...)',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final String keyLabel;
  final IconData icon;
  final String description;

  const _LegendRow({
    required this.keyLabel,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background2.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.accent.withOpacity(0.35)),
            ),
            child: Icon(icon, size: 18, color: AppColors.accent),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 44,
            child: Text(
              keyLabel,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                color: AppColors.textMuted,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
