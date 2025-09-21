import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guardian_app/data/models/Agenda.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Ubah fungsi agar bisa menerima parameter filter baru
Future<AgendaListResponse?> getAgendaList({
  required String studentId,
  String? tahunAjaran, // Tambahkan parameter baru
  String? tanggalMulai, // Tambahkan parameter baru
  String? tanggalAkhir, // Tambahkan parameter baru
  String? pengirim, // Tambahkan parameter baru
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? sid = prefs.getString('sid');

  if (sid == null) {
    if (kDebugMode) {
      print('Error (Agenda): SID not found in SharedPreferences. User may not be logged in.');
    }
    return null;
  }

  final String apiUrl = '${dotenv.env['API_URL']}/api/method/gaAgendaList';

  // Siapkan query parameters
  final Map<String, String> queryParameters = {
    'student': studentId,
  };

  // Tambahkan filter jika tidak null
  if (tahunAjaran != null) {
    queryParameters['academic_year'] = tahunAjaran;
  }
  if (tanggalMulai != null) {
    queryParameters['start_date'] = tanggalMulai;
  }
  if (tanggalAkhir != null) {
    queryParameters['end_date'] = tanggalAkhir;
  }
  if (pengirim != null && pengirim != 'semua') {
    // Ubah nilai enum menjadi string yang sesuai dengan API
    // Asumsi API menggunakan nama yang lebih standar, e.g., 'Wali Kelas 5A'
    queryParameters['sender'] = pengirim;
  }

  final Uri url = Uri.parse(apiUrl).replace(queryParameters: queryParameters);

  try {
    // Lakukan panggilan API seperti biasa
    final http.Response response = await http.get(
      url,
      headers: {
        'Cookie': 'sid=$sid',
        'sekolahproapp': 'PA-1.0.0',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Agenda API Response Body: ${response.body}');
      }
      return AgendaListResponse.fromJson(jsonDecode(response.body));
    } else {
      if (kDebugMode) {
        print('Error fetching agenda list: Status Code ${response.statusCode}');
        print('Response Body: ${response.body}');
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