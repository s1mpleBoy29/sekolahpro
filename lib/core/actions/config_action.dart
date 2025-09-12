import 'package:flutter/foundation.dart';
import 'package:guardian_app/data/api/config.dart' as config;

class ConfigAction {
  static Future<Map<String, dynamic>> getConfig() async {
    print('check config action');
    try {
      final response = await config.getConfig();

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
