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
    return PlayableCharacter(
      id: json['id'],
      name: json['name'],
      race: json['race'],
      career: json['career'],
      age: json['age'],
      campaignId: json['campaignId'],
      ballisticSkill: json['ballisticSkill'],
      strength: json['strength'],
      toughness: json['toughness'],
      agility: json['agility'],
      intelligence: json['intelligence'],
      willPower: json['willPower'],
      fellowship: json['fellowship'],
      attacks: json['attacks'],
      wounds: json['wounds'],
      movement: json['movement'],
      magic: json['magic'],
      insanityPoints: json['insanityPoints'],
      fatePoints: json['fatePoints'],
    );
  }
}
