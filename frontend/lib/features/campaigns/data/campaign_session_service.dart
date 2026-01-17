import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:aie/core/api/api_config.dart';
import 'package:aie/features/auth/data/auth_service.dart';
import 'package:aie/features/campaigns/domain/campaign_session.dart';

class CampaignSessionService {
  static Uri _endpoint(int campaignId, [String path = '']) {
    // Preferred: /api/campaign/{id}/sessions
    return ApiConfig.uri('/api/campaign/$campaignId/sessions$path');
  }

  static Future<List<CampaignSession>> fetchSessions(int campaignId) async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final res = await http.get(
      _endpoint(campaignId),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data
          .whereType<Map<String, dynamic>>()
          .map((j) => CampaignSession.fromJson(j))
          .toList();
    }

    throw Exception('Nie udało się pobrać sesji (status ${res.statusCode})');
  }

  static Future<CampaignSession> createSession({
    required int campaignId,
    required String title,
    String? description,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Brak tokena - użytkownik nie jest zalogowany');
    }

    final body = jsonEncode({'title': title, 'description': description});

    final res = await http.post(
      _endpoint(campaignId),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return CampaignSession.fromJson(data);
    }

    throw Exception('Nie udało się utworzyć sesji (status ${res.statusCode})');
  }

  static Future<CampaignSession> updateSession({
    required int campaignId,
    required int sessionId,
    required String title,
    String? description,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Brak tokena - użytkownik nie jest zalogowany');
    }

    final body = jsonEncode({'title': title, 'description': description});

    final res = await http.put(
      _endpoint(campaignId, '/$sessionId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return CampaignSession.fromJson(data);
    }

    throw Exception('Nie udało się zaktualizować sesji (status ${res.statusCode})');
  }

  static Future<void> deleteSession({
    required int campaignId,
    required int sessionId,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Brak tokena - użytkownik nie jest zalogowany');
    }

    final res = await http.delete(
      _endpoint(campaignId, '/$sessionId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 204) return;

    throw Exception('Nie udało się usunąć sesji (status ${res.statusCode})');
  }
}
