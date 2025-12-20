class Character {
  final int id;
  final String name;
  final String career;
  final String race;

  Character({
    required this.id,
    required this.name,
    required this.career,
    required this.race,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      career: json['career'] ?? '',
      race: json['race'] ?? 0,
    );
  }
}
