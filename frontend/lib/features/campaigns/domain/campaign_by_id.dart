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
    // Backend (na dziś) potrafi zwrócić:
    // - Characters (z CampaignByIdDto)
    // - albo PlayableCharacters (z encji Campaign, jeśli mapping nie mapuje na Characters)
    final list =
        (json['characters'] as List?) ??
        (json['Characters'] as List?) ??
        (json['playableCharacters'] as List?) ??
        (json['PlayableCharacters'] as List?) ??
        const [];
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
