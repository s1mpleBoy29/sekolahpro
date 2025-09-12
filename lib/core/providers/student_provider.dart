import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardian_app/data/models/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProvider with ChangeNotifier {
  List<Student> _students = [];
  List<Student> get students => _students;

  Student? _selectedStudent;
  Student? get selectedStudent => _selectedStudent;

  StudentProvider() {
    loadStudent();
  }

  Future<void> saveStudents(List<Student> students) async {
    _students = students;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(students.map((e) => e.toJson()).toList());
    await prefs.setString('students', jsonString);

    notifyListeners();
  }

  Future<void> loadStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('students');

    if (jsonString != null) {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _students = jsonData.map((e) => Student.fromJson(e)).toList();
    }

    notifyListeners();
  }

  void setSelectedStudent(Student student) async {
    _selectedStudent = student;
    notifyListeners();
  }
}
