import 'package:flutter/foundation.dart';
import 'package:guardian_app/data/api/ads.dart' as ads;

class AdsAction {
  static Future<Map<String, dynamic>> getAds(
    String size,
    int limit,
    String? today,
  ) async {
    try {
      final response = await ads.getAds(size, limit, today);

      if (response == null || response['message'] == null) {
        return {};
      }
      final Map<String, dynamic> itemsJson = response['message'] ?? {};

      return itemsJson;
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      throw Exception('Error fetching items: $error');
    }
  }
}
