class Ability {
  final int id;
  final String name;
  final String description;

  const Ability({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
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

    return Ability(
      id: parseInt(json['id'] ?? json['Id']),
      name: parseString(json['name'] ?? json['Name']),
      description: parseString(json['description'] ?? json['Description']),
    );
  }
}
