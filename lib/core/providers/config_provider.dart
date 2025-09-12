import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider with ChangeNotifier {
  Map<String, dynamic> _config = {};
  Map<String, dynamic> get config => _config;

  ConfigProvider() {
    loadConfig();
  }

  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('config');

    if (jsonString != null) {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _config = jsonData as Map<String, dynamic>;
    }

    notifyListeners();
  }

  Future<void> saveConfig(Map<String, dynamic> config) async {
    _config = config;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(config);
    await prefs.setString('config', jsonString);

    notifyListeners();
  }

  void setConfig(Map<String, dynamic> newConfig) {
    _config = newConfig;
    notifyListeners();
  }
}
