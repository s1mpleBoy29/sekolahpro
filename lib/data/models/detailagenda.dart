import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guardian_app/data/models/Agenda.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Fungsi untuk mendapatkan detail agenda berdasarkan nama (ID)
Future<AgendaDetail?> getAgendaDetail({
  required String agendaName,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? sid = prefs.getString('sid');

  if (sid == null) {
    if (kDebugMode) {
      print('Error (Agenda): SID not found in SharedPreferences. User may not be logged in.');
    }
    return null;
  }

  final String apiUrl = '${dotenv.env['API_URL']}/api/method/gaAgendaDetail';

  final Map<String, String> queryParameters = {
    'name': agendaName,
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
        print('Agenda Detail API Response Body: ${response.body}');
      }
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final dynamic messageData = responseData['message'];

      // Periksa apakah 'message' adalah Map dan memiliki 'view'
      if (messageData is Map<String, dynamic> && messageData.containsKey('view')) {
        final Map<String, dynamic>? viewData = messageData['view'];
        if (viewData != null) {
          return AgendaDetail.fromJson(viewData);
        }
      }
      // Jika respons tidak memiliki struktur yang diharapkan, kembalikan null
      return null;
    } else {
      if (kDebugMode) {
        print('Error fetching agenda detail: Status Code ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
      return null;
    }
  } catch (error) {
    if (kDebugMode) {
      print('Exception occurred while fetching agenda detail: $error');
    }
    return null;
  }
}
