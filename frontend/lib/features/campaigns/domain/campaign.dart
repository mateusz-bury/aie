class Campaign {
  final int id;
  final String name;
  final String description;

  Campaign({required this.id, required this.name, required this.description});

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
