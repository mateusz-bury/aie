import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aie/service/AuthService.dart';
import '../models/Campaign.dart';
import '../models/CampaignById.dart';

class CampaignService {
  static const String baseUrl = 'https://localhost:7221/api/campaign';

  static Future<List<Campaign>> fetchCampaigns() async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Campaign.fromJson(json)).toList();
    } else {
      print('Błąd pobierania kampanii: ${response.statusCode}');
      return [];
    }
  }

  static Future<CampaignById> fetchCampaignById(int campaignId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("Brak tokena - użytkownik nie jest zalogowany");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$campaignId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final campaign = CampaignById.fromJson(data);
        return campaign;
      } catch (e) {
        throw Exception("Błąd parsowania danych kampanii: $e");
      }
    } else {
      throw Exception(
        "Nie udało się pobrać kampanii (status ${response.statusCode})",
      );
    }
  }
}
