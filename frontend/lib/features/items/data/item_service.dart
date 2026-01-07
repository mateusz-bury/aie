import 'dart:convert';

import 'package:aie/core/api/api_config.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:aie/features/items/domain/item.dart';
import 'package:http/http.dart' as http;

class ItemService {
  static Uri _endpoint([String path = '']) => ApiConfig.uri('/api/item$path');

  static Future<Map<String, String>> _authHeaders({bool json = false}) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Brak tokena autoryzacyjnego – zaloguj się ponownie.');
    }
    return {
      'Authorization': 'Bearer $token',
      if (json) 'Content-Type': 'application/json',
    };
  }

  static Future<List<Item>> fetchItems() async {
    final headers = await _authHeaders();
    final response = await http.get(_endpoint(), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Błąd pobierania itemów: ${response.statusCode} ${response.body}');
  }

  static Future<Item> fetchItemById(int id) async {
    final headers = await _authHeaders();
    final response = await http.get(_endpoint('/$id'), headers: headers);
    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    }
    throw Exception('Błąd pobierania itemu: ${response.statusCode} ${response.body}');
  }

  static Future<int?> createItem(Item item) async {
    final headers = await _authHeaders(json: true);
    final response = await http.post(
      _endpoint(),
      headers: headers,
      body: jsonEncode(item.toCreateDtoJson()),
    );
    if (response.statusCode == 201) {
      final location = response.headers['location'];
      if (location == null) return null;
      final parts = location.split('/');
      return int.tryParse(parts.last);
    }
    throw Exception('Błąd tworzenia itemu: ${response.statusCode} ${response.body}');
  }

  static Future<void> updateItem(Item item) async {
    final headers = await _authHeaders(json: true);
    final response = await http.put(
      _endpoint('/${item.id}'),
      headers: headers,
      body: jsonEncode(item.toUpdateDtoJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Błąd edycji itemu: ${response.statusCode} ${response.body}');
    }
  }
}
