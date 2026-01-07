class Item {
  final int id;
  final String name;
  final String description;
  final String type;
  final int price;
  final int weight;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.price,
    required this.weight,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? fallback;
      return fallback;
    }

    String parseString(dynamic v, [String fallback = '']) => v?.toString() ?? fallback;

    return Item(
      id: parseInt(json['id'] ?? json['Id']),
      name: parseString(json['name'] ?? json['Name']),
      description: parseString(json['description'] ?? json['Description']),
      type: parseString(json['type'] ?? json['Type']),
      price: parseInt(json['price'] ?? json['Price']),
      weight: parseInt(json['weight'] ?? json['Weight']),
    );
  }

  Map<String, dynamic> toCreateDtoJson() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'price': price,
      'weight': weight,
    };
  }

  Map<String, dynamic> toUpdateDtoJson() => toCreateDtoJson();
}
