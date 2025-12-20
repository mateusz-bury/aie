import 'package:aie/features/characters/domain/playable_character.dart';

class CampaignById {
  final int id;
  final String name;
  final String description;
  final DateTime createDate;
  final List<PlayableCharacter> playableCharacters;

  CampaignById({
    required this.id,
    required this.name,
    required this.description,
    required this.createDate,
    required this.playableCharacters,
  });

  factory CampaignById.fromJson(Map<String, dynamic> json) {
    return CampaignById(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createDate: DateTime.parse(json['createDate']),
      playableCharacters:
          (json['playableCharacters'] as List)
              .map((pc) => PlayableCharacter.fromJson(pc))
              .toList(),
    );
  }
}
