import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  String _fullName = '';
  bool _isLoading = true;
  dynamic _user = {};
  dynamic _guardian = {};

  String get token => _token;
  String get fullName => _fullName;
  bool get isAuthenticated => _token.isNotEmpty;
  bool get isLoading => _isLoading;
  dynamic get user => _user;
  dynamic get guardian => _guardian;

  AuthProvider() {
    loadToken(); // Cek token saat provider dibuat
  }

  Future<void> setToken(String token, {String? fullName}) async {
    _token = token;
    if (fullName != null) _fullName = fullName; // Simpan fullName juga

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    if (fullName != null) await prefs.setString('auth_full_name', fullName);

    notifyListeners();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token') ?? '';
    _fullName = prefs.getString('auth_full_name') ?? ''; // Load fullName juga
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _user = prefs.getString('auth_user') ?? '';

    notifyListeners();
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    _user = user;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user);
    await prefs.setString('auth_user', jsonString);

    notifyListeners();
  }

  Future<void> loadGuardian() async {
    final prefs = await SharedPreferences.getInstance();
    _guardian = prefs.getString('auth_guardian') ?? '';

    notifyListeners();
  }

  Future<void> saveGuardian(Map<String, dynamic> guardian) async {
    _guardian = guardian;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(guardian);
    await prefs.setString('auth_guardian', jsonString);

    notifyListeners();
  }

  Future<void> login(String? token, {String? fullName}) async {
    if (token == null || token.isEmpty) return; // Cegah error jika token kosong

    _token = token;
    if (fullName != null) _fullName = fullName; // Simpan fullName jika ada

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    if (fullName != null) {
      await prefs.setString('auth_full_name', fullName); // Simpan fullName juga
    }

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_full_name'); // Hapus fullName juga
    _token = '';
    _fullName = '';
    notifyListeners();
  }
}
