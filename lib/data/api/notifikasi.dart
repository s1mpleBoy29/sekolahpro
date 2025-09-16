// services/api_service.dart (atau di mana pun Anda menyimpan fungsi API)
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Pastikan ini terinstal dan dikonfigurasi
import 'package:guardian_app/data/models/notifikasi.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<NotificationListResponse?> fetchNotifications() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? sid = prefs.getString('sid');

  if (sid == null) {
    if (kDebugMode) {
      print('Error (Notifications): SID not found. User may not be logged in.');
    }
    return null; // Pengguna belum login
  }

  final String apiUrl = '${dotenv.env['API_URL']}/api/method/gaNotifList'; // GANTI DENGAN ENDPOINT API SEBENARNYA

  try {
    final http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Cookie': 'sid=$sid',
        'sekolahproapp': 'PA-1.0.0', // Header lain yang mungkin diperlukan
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Notification API Response Body: ${response.body}');
      }
      // Parse respons ke model NotificationListResponse
      return NotificationListResponse.fromJson(jsonDecode(response.body));
    } else {
      if (kDebugMode) {
        print('Error fetching notifications: Status Code ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
      // Tangani error status code di sini jika perlu
      return null;
    }
  } catch (error) {
    if (kDebugMode) {
      print('Exception occurred while fetching notifications: $error');
    }
    return null;
  }
}