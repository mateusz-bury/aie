import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aie/service/AuthService.dart';
import '../models/Character.dart';
import '../models/PlayableCharacter.dart';

class CharacterService {
  static const String baseUrl = 'https://localhost:7221/api/character';

  static Future<List<Character>> fetchCharacters() async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      print('Błąd pobierania postaci: ${response.statusCode}');
      return [];
    }
  }

  static Future<PlayableCharacter> fetchCharacterById(int id) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Brak tokena autoryzacyjnego');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PlayableCharacter.fromJson(data);
    } else {
      throw Exception(
        'Błąd pobierania postaci o id $id: ${response.statusCode}',
      );
    }
  }

  static Future<void> updateCharacter(PlayableCharacter character) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Brak tokena autoryzacyjnego');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${character.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': character.id,
        'name': character.name,
        'race': character.race,
        'career': character.career,
        'age': character.age,
        'campaignId': character.campaignId,
        'ballisticSkill': character.ballisticSkill,
        'strength': character.strength,
        'toughness': character.toughness,
        'agility': character.agility,
        'intelligence': character.intelligence,
        'willPower': character.willPower,
        'fellowship': character.fellowship,
        'attacks': character.attacks,
        'wounds': character.wounds,
        'movement': character.movement,
        'magic': character.magic,
        'insanityPoints': character.insanityPoints,
        'fatePoints': character.fatePoints,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Błąd aktualizacji postaci: ${response.statusCode} ${response.body}',
      );
    }
  }
}
