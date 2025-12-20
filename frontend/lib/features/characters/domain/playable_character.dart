class PlayableCharacter {
  final int id;
  final String name;
  final String race;
  final String career;
  final int age;
  final int campaignId;
  final int ballisticSkill;
  final int strength;
  final int toughness;
  final int agility;
  final int intelligence;
  final int willPower;
  final int fellowship;
  final int attacks;
  final int wounds;
  final int movement;
  final int magic;
  final int insanityPoints;
  final int fatePoints;

  PlayableCharacter({
    required this.id,
    required this.name,
    required this.race,
    required this.career,
    required this.age,
    required this.campaignId,
    required this.ballisticSkill,
    required this.strength,
    required this.toughness,
    required this.agility,
    required this.intelligence,
    required this.willPower,
    required this.fellowship,
    required this.attacks,
    required this.wounds,
    required this.movement,
    required this.magic,
    required this.insanityPoints,
    required this.fatePoints,
  });

  factory PlayableCharacter.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? fallback;
      return fallback;
    }

    String parseString(dynamic v, [String fallback = '']) {
      if (v == null) return fallback;
      return v.toString();
    }

    return PlayableCharacter(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      race: parseString(json['race']),
      career: parseString(json['career']),
      age: parseInt(json['age']),
      campaignId: parseInt(json['campaignId']),
      ballisticSkill: parseInt(json['ballisticSkill']),
      strength: parseInt(json['strength']),
      toughness: parseInt(json['toughness']),
      agility: parseInt(json['agility']),
      intelligence: parseInt(json['intelligence']),
      willPower: parseInt(json['willPower']),
      fellowship: parseInt(json['fellowship']),
      attacks: parseInt(json['attacks']),
      wounds: parseInt(json['wounds']),
      movement: parseInt(json['movement']),
      magic: parseInt(json['magic']),
      insanityPoints: parseInt(json['insanityPoints']),
      fatePoints: parseInt(json['fatePoints']),
    );
  }
}
