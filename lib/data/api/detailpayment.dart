import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Mengambil daftar jadwal pembayaran (gaTuitionList).
/// Dibutuhkan [studentId] dan [tuitionPlanId].
/// Autentikasi admin menggunakan 'sid' dari SharedPreferences dan dikirim sebagai cookie.
Future<Map<String, dynamic>?> getViewJadwalBayar({
  required String studentId,
  required String tuitionPlanId, // ID unik untuk satu jadwal pembayaran
}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sid = prefs.getString('sid');

    if (sid == null) {
      if (kDebugMode) {
        print(
            'Error: SID not found in SharedPreferences. User may not be logged in.');
      }
      return null; // Bila tidak ada SID, tidak bisa melakukan permintaan.
    }

    final String apiUrl = '${dotenv.env['API_URL']}/api/method/gaTuitionView';

    final Uri url = Uri.parse(apiUrl).replace(queryParameters: {
      'student': studentId,
      'tuition': tuitionPlanId,
    });

    final http.Response response = await http.get(
      url,
      headers: {
        'Cookie': 'sid=$sid', // Autentikasi
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      return jsonDecode(response.body);
    } else {
      debugPrint('Error - getViewJadwalBayar: ${response.body}');
      return jsonDecode(response.body);
    }
  } catch (error) {
    debugPrint('Exception - getViewJadwalBayar: $error');
    return null;
  }
}
