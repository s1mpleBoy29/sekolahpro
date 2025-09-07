import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guardian_app/data/models/Agenda.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


Future<AgendaListResponse?> getAgendaList({
  required String studentId,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? sid = prefs.getString('sid');

  if (sid == null) {
    if (kDebugMode) {
      print('Error (Agenda): SID not found in SharedPreferences. User may not be logged in.');
    }
    // Jika SID tidak ditemukan, kembalikan null atau throw error yang sesuai.
    // Untuk konsistensi dengan keuangan, kita bisa mengembalikan null
    // dan membiarkan UI menangani pesan error "Silahkan login kembali".
    return null;
  }

  // Gunakan endpoint yang benar: gaAgendaList
  final String apiUrl = '${dotenv.env['API_URL']}/api/method/gaAgendaList';

  final Map<String, String> queryParameters = {
    'student': studentId,
  };

  final Uri url = Uri.parse(apiUrl).replace(queryParameters: queryParameters);

  try {
    final http.Response response = await http.get(
      url,
      headers: {
        'Cookie': 'sid=$sid', // Autentikasi menggunakan SID
        'sekolahproapp': 'PA-1.0.0', // Pastikan header ini relevan
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Agenda API Response Body: ${response.body}');
      }
      // Langsung parse ke AgendaListResponse
      return AgendaListResponse.fromJson(jsonDecode(response.body));
    } else {
      if (kDebugMode) {
        print('Error fetching agenda list: Status Code ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
      // Jika status code bukan 200, kembalikan null atau parse pesan error dari response
      // Jika response.body bisa di-decode ke Map dan ada pesan error di dalamnya:
      try {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        // Anda bisa memeriksa errorData['message'] atau field lain yang relevan.
        // Jika errornya adalah "Invalid Request" atau terkait session, kita bisa tangani.
        if (errorData.containsKey('message') && errorData['message'] == 'Invalid Request') {
           // Ini bisa terjadi jika SID tidak valid atau expired.
           // Anda mungkin ingin mengembalikan nilai khusus atau throw exception di sini.
           return null; // Mengembalikan null agar UI bisa menampilkan pesan login kembali.
        }
      } catch (_) {
        // Gagal decode atau format tidak sesuai, tetap kembalikan null.
      }
      return null;
    }
  } catch (error) {
    if (kDebugMode) {
      print('Exception occurred while fetching agenda list: $error');
    }
    return null;
  }
}