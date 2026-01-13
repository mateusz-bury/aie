class Skill {
  final int id;
  final String name;
  final String description;
  final String type;
  final String skillType;

  const Skill({
    required this.id,
    required this.name,
    required this.description,
    this.type = '',
    this.skillType = '',
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
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

    return Skill(
      id: parseInt(json['id'] ?? json['Id']),
      name: parseString(json['name'] ?? json['Name']),
      description: parseString(json['description'] ?? json['Description']),
      type: parseString(json['type'] ?? json['Type']),
      skillType: parseString(json['skillType'] ?? json['SkillType']),
    );
  }
}
