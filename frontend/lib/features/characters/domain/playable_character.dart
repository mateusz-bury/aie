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
  });

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
    final stats = {
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
        {'statisticType': _statisticTypeToApiValue(0), ...stats},
        {'statisticType': _statisticTypeToApiValue(1), ...stats},
      ],
    };
  }

  /// Payload zgodny z backendowym UpdateCharacterDto.
  Map<String, dynamic> toUpdateDtoJson() {
    return {
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
    Map<String, dynamic> pickStats(Map<String, dynamic> root) {
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

        // Preferuj Current (statisticType=Current/1), w przeciwnym razie pierwszy
        final current = raw
            .cast<dynamic>()
            .whereType<Map>()
            .cast<Map<String, dynamic>>()
            .firstWhere(
              (m) => parseEnum(m['statisticType'] ?? m['StatisticType'], mapping) == 1,
              orElse: () {
                final first = raw.cast<dynamic>().whereType<Map>().cast<Map<String, dynamic>>().toList();
                return first.isNotEmpty ? first.first : <String, dynamic>{};
              },
            );
        return Map<String, dynamic>.from(current);
      }
      // fallback - czasem ktoś zwraca jako mapę
      if (raw is Map<String, dynamic>) return raw;
      return <String, dynamic>{};
    }

    final stats = pickStats(json);
    int stat(String key) => parseInt(stats[key]);

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
      ballisticSkill: stat('ballisticSkill'),
      strength: stat('strength'),
      toughness: stat('toughness'),
      agility: stat('agility'),
      intelligence: stat('intelligence'),
      willPower: stat('willPower'),
      fellowship: stat('fellowship'),
      attacks: stat('attacks'),
      wounds: stat('wounds'),
      movement: stat('movement'),
      magic: stat('magic'),
      insanityPoints: stat('insanityPoints'),
      fatePoints: stat('fatePoints'),
    );
  }
}
