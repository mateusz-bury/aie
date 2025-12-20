import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aie/core/utils/app_logger.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:aie/features/campaigns/domain/campaign.dart';
import 'package:aie/features/campaigns/domain/campaign_by_id.dart';

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
      AppLogger.w('Błąd pobierania kampanii: ${response.statusCode}');
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

  static Future<bool> updateCampaign(
    int campaignId,
    String name,
    String description,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("Brak tokena - użytkownik nie jest zalogowany");
    }

    final body = jsonEncode({'name': name, 'description': description});

    final response = await http.put(
      Uri.parse('$baseUrl/$campaignId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception("Nieprawidłowe dane wysłane do serwera (400)");
    } else if (response.statusCode == 401) {
      throw Exception("Brak autoryzacji – zaloguj się ponownie (401)");
    } else if (response.statusCode == 404) {
      throw Exception("Kampania o ID $campaignId nie istnieje (404)");
    } else {
      throw Exception(
        "Błąd podczas aktualizacji kampanii (status ${response.statusCode})",
      );
    }
  }

  static Future<int> createCampaign(String name, String description) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("Brak tokena - użytkownik nie jest zalogowany");
    }

    final body = jsonEncode({'name': name, 'description': description});

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Zakładamy, że serwer zwraca nową kampanię w body
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['id'] as int;
    } else if (response.statusCode == 400) {
      throw Exception("Nieprawidłowe dane wysłane do serwera (400)");
    } else if (response.statusCode == 401) {
      throw Exception("Brak autoryzacji – zaloguj się ponownie (401)");
    } else {
      throw Exception(
        "Błąd podczas tworzenia kampanii (status ${response.statusCode})",
      );
    }
  }

  static Future<bool> deleteCampaign(int campaignId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("Brak tokena - użytkownik nie jest zalogowany");
    }

    final response = await http.delete(
      Uri.parse('${baseUrl}/${campaignId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception("Nieprawidłowe dane wysłane do serwera (400)");
    } else if (response.statusCode == 401) {
      throw Exception("Brak autoryzacji – zaloguj się ponownie (401)");
    } else {
      throw Exception(
        "Błąd podczas usuwania kampanii (status ${response.statusCode})",
      );
    }
  }
}
