import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guardian_app/data/models/school.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolProvider with ChangeNotifier {
  List<School> _schools = [];
  List<School> get schools => _schools;

  // Student? _selectedStudent;
  // Student? get selectedStudent => _selectedStudent;

  SchoolProvider() {
    loadSchool();
  }

  Future<void> saveSchool(List<School> schools) async {
    _schools = schools;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_schools.map((e) => e.toJson()).toList());
    await prefs.setString('schools', jsonString);

    notifyListeners();
  }

  Future<void> loadSchool() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('schools');

    if (jsonString != null) {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _schools = jsonData.map((e) => School.fromJson(e)).toList();
    }

    notifyListeners();
  }

  void setSelectedStudent(School student) async {
    // _selectedStudent = student;
    notifyListeners();
  }
}
