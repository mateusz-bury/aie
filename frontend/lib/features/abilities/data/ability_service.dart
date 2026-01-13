import 'dart:convert';

import 'package:aie/core/api/api_config.dart';
import 'package:aie/features/abilities/domain/ability.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:http/http.dart' as http;

class AbilityService {
  static Uri _endpoint([String path = '']) => ApiConfig.uri('/api/abilities$path');

  static Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Brak tokena autoryzacyjnego – zaloguj się ponownie.');
    }
    return {'Authorization': 'Bearer $token'};
  }

  static Future<List<Ability>> fetchAbilities() async {
    final headers = await _authHeaders();
    final response = await http.get(_endpoint(), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .whereType<Map>()
          .map((e) => Ability.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    throw Exception('Błąd pobierania ability: ${response.statusCode} ${response.body}');
  }
}
