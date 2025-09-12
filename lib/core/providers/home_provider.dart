import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider with ChangeNotifier {
  Map<String, dynamic> _home = {};
  Map<String, dynamic> get home => _home;

  Map<String, dynamic> _tuitions = {};
  Map<String, dynamic> get tuitions => _tuitions;

  List<dynamic> _agendas = [];
  List<dynamic> get agendas => _agendas;

  String _today = '';
  String get today => _today;

  HomeProvider() {
    loadHome();
  }

  Future<void> loadHome() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('home');

    if (jsonString != null) {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _home = jsonData as Map<String, dynamic>;
    }

    notifyListeners();
  }

  Future<void> saveHome(Map<String, dynamic> home) async {
    _home = home;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(home);
    await prefs.setString('home', jsonString);

    notifyListeners();
  }

  void setHome(Map<String, dynamic> newHome) {
    _home = newHome;
    _tuitions = newHome['tuitions'] ?? {};
    _agendas = newHome['agendas'] ?? [];
    _today = newHome['today'] ?? '';

    notifyListeners();
  }
}
