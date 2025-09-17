import 'package:flutter/foundation.dart';
import 'package:guardian_app/data/api/school.dart' as school;
import 'package:guardian_app/data/models/school.dart';

class SchoolAction {
  static Future<List<School>> getSchool() async {
    try {
      final response = await school.getAllSchool();

      if (response == null || response['message'] == null) {
        return [];
      }

      print('result from action : $response');
      final List<dynamic> itemsJson = response['message']['lists'] ?? [];

      return itemsJson.map((e) => School.fromJson(e)).toList();
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      throw Exception('Error fetching items: $error');
    }
  }
}
