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
      id: (json['id'] ?? json['Id'] ?? 0) as int,
      name: (json['name'] ?? json['Name'] ?? '') as String,
      career: (json['career'] ?? json['Career'] ?? '') as String,
      race: (json['race'] ?? json['Race'] ?? '') as String,
      
    );
  }
}
