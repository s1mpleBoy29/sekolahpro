// lib/data/api/ads.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Make sure to import the Ad model you created earlier
import 'package:guardian_app/data/models/ad.dart';

/// Mengambil daftar jadwal pembayaran (gaAdsList).
/// Returns [Ad] sebagai object bila sukses, bila `null` ada error.
/// Autentikasi admin menggunakan 'sid' dari SharedPreferences dan dikirim sebagai cookie.
Future<Ad?> getAd() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sid = prefs.getString('sid');

    if (sid == null) {
      if (kDebugMode) {
        print(
            'Error: SID not found in SharedPreferences. User may not be logged in.');
      }
      return null;
    }

    final String apiUrl = '${dotenv.env['API_URL']}/api/method/gaAdsList';
    final Uri url = Uri.parse(apiUrl);

    final http.Response response = await http.get(
      url,
      headers: {
        'sekolahproapp': 'PA-1.0.0',
        'Cookie': 'sid=$sid',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Ad.fromJson(data);
    } else {
      if (kDebugMode) {
        print('Error fetching payment schedule: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      return null;
    }
  } catch (error) {
    if (kDebugMode) {
      print('An exception occurred while fetching payment schedule: $error');
    }
    return null;
  }
}
