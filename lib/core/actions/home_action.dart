import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:guardian_app/data/api/home.dart' as home;
import 'package:guardian_app/data/models/home.dart';

class HomeAction {
  static Future<Map<String, dynamic>?> getHome(String student) async {
    try {
      final response = await home.getHome(student);

      if (response == null || response['message'] == null) {
        return null;
      }

      final Map<String, dynamic> itemsJson = response['message'] ?? {};

      print('check home: $itemsJson');

      return itemsJson;
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      throw Exception('Error fetching items: $error');
    }
  }
}
