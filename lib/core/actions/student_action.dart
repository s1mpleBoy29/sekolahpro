import 'package:flutter/foundation.dart';
import 'package:guardian_app/data/api/student.dart' as student;
import 'package:guardian_app/data/models/student.dart';

class StudentAction {
  static Future<List<Student>> getStudents(
      int limit, int start, String filters) async {
    try {
      final response = await student.getStudent(limit, start, filters);

      if (response == null || response['message'] == null) {
        return [];
      }
      final List<dynamic> itemsJson = response['message']['lists'] ?? [];

      List<dynamic> itemsJsonNew = [];

      itemsJsonNew = itemsJson.map((json) {
        return {
          'name': json['student'] ?? '',
          'full_name': json['student_name'] ?? '',
          'school': json['school'] ?? '',
          'school_name': json['school_name'] ?? '',
          'grade': json['grade'] ?? '',
          'grade_name': json['grade_name'] ?? '',
          'academic_year': json['academic_year'] ?? '',
          'academic_year_name': json['academic_year_title'] ?? '',
        };
      }).toList();

      return itemsJsonNew.map((json) => Student.fromJson(json)).toList();
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      throw Exception('Error fetching items: $error');
    }
  }

  static List<Student> getStudentNoAcademicYear(List<Student> student) {
    List<Student> filteredStudents =
        student.where((s) => s.academicYear != '').toList();
    return filteredStudents;
  }

  void setStudentSelected(String student) {
    // selectedStudent = student;
    // notifyListeners();
  }
}
