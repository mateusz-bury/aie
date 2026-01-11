class Character {
  final int id;
  final String name;
  final String career;
  final String race;

  /// 0 = Playable, 1 = NPC, 2 = Template
  /// (jeśli backend jeszcze nie zwraca – default 0)
  final int characterType;

  Character({
    required this.id,
    required this.name,
    required this.career,
    required this.race,
    this.characterType = 0,
  });

  static int _parseCharacterType(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;

    final s = v.toString().toLowerCase();
    final asInt = int.tryParse(s);
    if (asInt != null) return asInt;

    if (s.contains('npc')) return 1;
    if (s.contains('template')) return 2;
    if (s.contains('playable')) return 0;

    return 0;
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      name: (json['name'] ?? json['Name'] ?? '') as String,
      career: (json['career'] ?? json['Career'] ?? '') as String,
      race: (json['race'] ?? json['Race'] ?? '') as String,
      characterType: _parseCharacterType(
        json['characterType'] ?? json['CharacterType'],
      ),
    );
  }
}
