import 'package:flutter/foundation.dart';
import 'package:guardian_app/data/api/student.dart' as student;
import 'package:guardian_app/data/models/student.dart';

class StudentAction {
  static Future<List<Student>> getStudents(
      int limit, int start, String filters) async {
    try {
      print('test');
      final response = await student.getStudent(limit, start, filters);

      print('response: $response');

      if (response == null || response['data'] == null) {
        return [];
      }
      final List<dynamic> itemsJson = response['data'];
      return itemsJson.map((json) => Student.fromJson(json)).toList();
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      throw Exception('Error fetching items: $error');
    }
  }
}
