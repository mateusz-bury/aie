import 'package:aie/features/characters/domain/character.dart';

class CampaignById {
  final int id;
  final String name;
  final String description;
  final DateTime createDate;
  final List<Character> characters;

  CampaignById({
    required this.id,
    required this.name,
    required this.description,
    required this.createDate,
    required this.characters,
  });

  factory CampaignById.fromJson(Map<String, dynamic> json) {
    // Backend potrafi zwrócić listę postaci w różnych kształtach:
    // - "characters" / "playableCharacters" jako zwykła lista
    // - albo jako obiekt z "$values" (gdy włączone ReferenceHandler.Preserve)
    List<dynamic> _extractList(dynamic raw) {
      if (raw == null) return const [];
      if (raw is List) return raw;
      if (raw is Map) {
        // System.Text.Json z ReferenceHandler.Preserve używa klucza "$values" (bez backslasha).
        final v = raw[r'$values'] ?? raw['values'];
        if (v is List) return v;
      }
      return const [];
    }

    final rawCharacters =
        json['characters'] ??
        json['Characters'] ??
        json['playableCharacters'] ??
        json['PlayableCharacters'];

    final list = _extractList(rawCharacters);
    final createDateRaw = json['createDate'] ?? json['CreateDate'] ?? json['createdDate'] ?? json['createdAt'];

    return CampaignById(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      name: (json['name'] ?? json['Name'] ?? '') as String,
      description: (json['description'] ?? json['Description'] ?? '') as String,
      createDate:
          createDateRaw != null ? DateTime.parse(createDateRaw.toString()) : DateTime.fromMillisecondsSinceEpoch(0),
      characters: list
          .map((c) => Character.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
