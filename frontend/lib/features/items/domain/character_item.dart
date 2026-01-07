class CharacterItem {
  final int characterId;
  final int itemId;
  final int count;
  final String name;
  final String description;
  final String type;
  final int price;
  final int weight;

  CharacterItem({
    required this.characterId,
    required this.itemId,
    required this.count,
    required this.name,
    required this.description,
    required this.type,
    required this.price,
    required this.weight,
  });

  factory CharacterItem.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? fallback;
      return fallback;
    }

    String parseString(dynamic v, [String fallback = '']) => v?.toString() ?? fallback;

    return CharacterItem(
      characterId: parseInt(json['characterId'] ?? json['CharacterId']),
      itemId: parseInt(json['itemId'] ?? json['ItemId']),
      count: parseInt(json['count'] ?? json['Count']),
      name: parseString(json['name'] ?? json['Name']),
      description: parseString(json['description'] ?? json['Description']),
      type: parseString(json['type'] ?? json['Type']),
      price: parseInt(json['price'] ?? json['Price']),
      weight: parseInt(json['weight'] ?? json['Weight']),
    );
  }
}
