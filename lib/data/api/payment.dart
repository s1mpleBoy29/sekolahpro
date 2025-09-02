import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Fetches the payment schedule (Jadwal Pembayaran) for a specific student.
///
/// Dibutuhkan [studentId] dan [academicYear].
/// Optional parameters [search], [page], dan [limit].
/// untuk pencarian dan halaman.
///
/// Autentikasi admin menggunakan 'sid' dari SharedPreferences dan dikirim sebagai cookie.
Future<Map<String, dynamic>?> getJadwalBayar({
  required String studentId,
  required String academicYear,
  String? search,
  int? page,
  int? limit,
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

    if (search != null) {
      queryParameters['search'] = search;
    }
    if (page != null) {
      queryParameters['page'] = page.toString();
    }
    if (limit != null) {
      queryParameters['limit'] = limit.toString();
    }

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
      print('Response body: ${response.body}');
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
