import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Mengambil daftar jadwal pembayaran (gaTuitionList).
/// Dibutuhkan [studentId] dan [academicYear].
/// Autentikasi admin menggunakan 'sid' dari SharedPreferences dan dikirim sebagai cookie.
Future<Map<String, dynamic>?> getJadwalBayar({
  required String studentId,
  required String academicYear,
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

    final String apiUrl = '${dotenv.env['API_URL']}/api/method/gaTuitionList';

    final Map<String, String> queryParameters = {
      'student': studentId,
      'academic_year': academicYear,
    };

    final Uri url = Uri.parse(apiUrl).replace(queryParameters: queryParameters);

    final http.Response response = await http.get(
      url,
      headers: {
        'Cookie': 'sid=$sid', // Autentikasi
        'sekolahproapp': 'PA-1.0.0',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // print('Response body: ${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
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
