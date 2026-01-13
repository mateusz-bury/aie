import 'package:aie/features/abilities/domain/ability.dart';
import 'package:aie/features/skills/domain/skill.dart';

class PlayableCharacter {
  final int id;

  /// Backend: CharacterType enum (0=Playable, 1=Npc, 2=Template)
  final int characterType;

  final String name;
  final String race;
  final String career;
  final int age;
  final int campaignId;

  // Stats (w UI traktujemy jako "Current" jeśli istnieje)
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

  // Base stats (StatisticType=Base)
  final int baseBallisticSkill;
  final int baseStrength;
  final int baseToughness;
  final int baseAgility;
  final int baseIntelligence;
  final int baseWillPower;
  final int baseFellowship;
  final int baseAttacks;
  final int baseWounds;
  final int baseMovement;
  final int baseMagic;
  final int baseInsanityPoints;
  final int baseFatePoints;

  /// Przypięte do postaci (backend: CharacterDto.Skills/Abilities)
  final List<Skill> skills;
  final List<Ability> abilities;

  PlayableCharacter({
    required this.id,
    this.characterType = 0,
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
    int? baseBallisticSkill,
    int? baseStrength,
    int? baseToughness,
    int? baseAgility,
    int? baseIntelligence,
    int? baseWillPower,
    int? baseFellowship,
    int? baseAttacks,
    int? baseWounds,
    int? baseMovement,
    int? baseMagic,
    int? baseInsanityPoints,
    int? baseFatePoints,
    this.skills = const [],
    this.abilities = const [],
  })  : baseBallisticSkill = baseBallisticSkill ?? ballisticSkill,
        baseStrength = baseStrength ?? strength,
        baseToughness = baseToughness ?? toughness,
        baseAgility = baseAgility ?? agility,
        baseIntelligence = baseIntelligence ?? intelligence,
        baseWillPower = baseWillPower ?? willPower,
        baseFellowship = baseFellowship ?? fellowship,
        baseAttacks = baseAttacks ?? attacks,
        baseWounds = baseWounds ?? wounds,
        baseMovement = baseMovement ?? movement,
        baseMagic = baseMagic ?? magic,
        baseInsanityPoints = baseInsanityPoints ?? insanityPoints,
        baseFatePoints = baseFatePoints ?? fatePoints;


  static String _characterTypeToApiValue(int type) {
    switch (type) {
      case 1:
        return 'Npc';
      case 2:
        return 'Template';
      case 0:
      default:
        return 'Playable';
    }
  }

  static String _statisticTypeToApiValue(int type) {
    switch (type) {
      case 1:
        return 'Current';
      case 2:
        return 'Temporary';
      case 3:
        return 'Template';
      case 0:
      default:
        return 'Base';
    }
  }

  /// Payload zgodny z backendowym CreateCharacterDto.
  /// Backend wymaga listy Statistics min. 2 elementy.
  Map<String, dynamic> toCreateDtoJson() {

    return {
      // Backend ma JsonStringEnumConverter, więc najlepiej wysyłać enum jako string.
      'characterType': _characterTypeToApiValue(characterType),
      'name': name,
      'race': race,
      'career': career,
      'age': age,
      'campaignId': campaignId,
      // StatisticType enum (string): Base / Current / Temporary / Template
      'statistics': [
        {
          'statisticType': _statisticTypeToApiValue(0),
          'ballisticSkill': baseBallisticSkill,
          'strength': baseStrength,
          'toughness': baseToughness,
          'agility': baseAgility,
          'intelligence': baseIntelligence,
          'willPower': baseWillPower,
          'fellowship': baseFellowship,
          'attacks': baseAttacks,
          'wounds': baseWounds,
          'movement': baseMovement,
          'magic': baseMagic,
          'insanityPoints': baseInsanityPoints,
          'fatePoints': baseFatePoints,
        },
        {
          'statisticType': _statisticTypeToApiValue(1),
          'ballisticSkill': ballisticSkill,
          'strength': strength,
          'toughness': toughness,
          'agility': agility,
          'intelligence': intelligence,
          'willPower': willPower,
          'fellowship': fellowship,
          'attacks': attacks,
          'wounds': wounds,
          'movement': movement,
          'magic': magic,
          'insanityPoints': insanityPoints,
          'fatePoints': fatePoints,
        },
      ],
    };
  }

  /// Payload zgodny z backendowym UpdateCharacterDto.
  Map<String, dynamic> toUpdateDtoJson() {
    return {
      'campaignId': campaignId,
      'name': name,
      'race': race,
      'career': career,
      'age': age,
    };
  }

  /// Payload zgodny z backendowym UpdateStatisticDto.
  Map<String, dynamic> toUpdateStatisticDtoJson({required int statisticType}) {
    return {
      // Backend ma JsonStringEnumConverter, więc wysyłamy enum jako string.
      'statisticType': _statisticTypeToApiValue(statisticType),
      'ballisticSkill': ballisticSkill,
      'strength': strength,
      'toughness': toughness,
      'agility': agility,
      'intelligence': intelligence,
      'willPower': willPower,
      'fellowship': fellowship,
      'attacks': attacks,
      'wounds': wounds,
      'movement': movement,
      'magic': magic,
      'insanityPoints': insanityPoints,
      'fatePoints': fatePoints,
    };
  }

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

    int parseEnum(dynamic v, Map<String, int> mapping, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      final s = v.toString();
      // czasem przychodzi "Current" albo "1"
      final asInt = int.tryParse(s);
      if (asInt != null) return asInt;
      return mapping[s] ?? mapping[s.toLowerCase()] ?? fallback;
    }

    // Backend zwraca Statistics jako List<StatisticDto>
    Map<String, dynamic> pickStatsByType(Map<String, dynamic> root, int wantedType) {
      final raw = root['statistics'] ?? root['Statistics'];
      if (raw is List) {
        const mapping = {
          'base': 0,
          'current': 1,
          'temporary': 2,
          'template': 3,
          'Base': 0,
          'Current': 1,
          'Temporary': 2,
          'Template': 3,
        };

        final list = raw
            .cast<dynamic>()
            .whereType<Map>()
            .cast<Map<String, dynamic>>()
            .toList();

        final match = list.firstWhere(
          (m) => parseEnum(m['statisticType'] ?? m['StatisticType'], mapping) == wantedType,
          orElse: () => <String, dynamic>{},
        );

        if (match.isNotEmpty) return Map<String, dynamic>.from(match);
        return list.isNotEmpty ? Map<String, dynamic>.from(list.first) : <String, dynamic>{};
      }
      if (raw is Map<String, dynamic>) return raw;
      return <String, dynamic>{};
    }

    final baseStats = pickStatsByType(json, 0);
    final currentStats = pickStatsByType(json, 1);

    int statCurrent(String key) => parseInt(currentStats[key]);
    int statBase(String key) => parseInt(baseStats[key], statCurrent(key));

    List<Map<String, dynamic>> parseList(dynamic v) {
      if (v is List) {
        return v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return const <Map<String, dynamic>>[];
    }

    final rawSkills = json['skills'] ?? json['Skills'];
    final rawAbilities = json['abilities'] ?? json['Abilities'];
    final parsedSkills = parseList(rawSkills).map(Skill.fromJson).toList();
    final parsedAbilities = parseList(rawAbilities).map(Ability.fromJson).toList();

    return PlayableCharacter(
      id: parseInt(json['id'] ?? json['Id']),
      characterType: () {
        final v = json['characterType'] ?? json['CharacterType'];
        // CharacterType jest enumem i często wraca jako string (Playable/Npc/Template)
        const mapping = {
          'playable': 0,
          'npc': 1,
          'template': 2,
          'Playable': 0,
          'Npc': 1,
          'Template': 2,
        };
        return parseEnum(v, mapping);
      }(),
      name: parseString(json['name'] ?? json['Name']),
      race: parseString(json['race'] ?? json['Race']),
      career: parseString(json['career'] ?? json['Career']),
      age: parseInt(json['age'] ?? json['Age']),
      campaignId: parseInt(json['campaignId'] ?? json['CampaignId']),
      ballisticSkill: statCurrent('ballisticSkill'),
      strength: statCurrent('strength'),
      toughness: statCurrent('toughness'),
      agility: statCurrent('agility'),
      intelligence: statCurrent('intelligence'),
      willPower: statCurrent('willPower'),
      fellowship: statCurrent('fellowship'),
      attacks: statCurrent('attacks'),
      wounds: statCurrent('wounds'),
      movement: statCurrent('movement'),
      magic: statCurrent('magic'),
      insanityPoints: statCurrent('insanityPoints'),
      fatePoints: statCurrent('fatePoints'),
      baseBallisticSkill: statBase('ballisticSkill'),
      baseStrength: statBase('strength'),
      baseToughness: statBase('toughness'),
      baseAgility: statBase('agility'),
      baseIntelligence: statBase('intelligence'),
      baseWillPower: statBase('willPower'),
      baseFellowship: statBase('fellowship'),
      baseAttacks: statBase('attacks'),
      baseWounds: statBase('wounds'),
      baseMovement: statBase('movement'),
      baseMagic: statBase('magic'),
      baseInsanityPoints: statBase('insanityPoints'),
      baseFatePoints: statBase('fatePoints'),
      skills: parsedSkills,
      abilities: parsedAbilities,
    );
  }
}
