import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String apiURLALL = '${dotenv.env['API_URL']}/api/method/gaStudentList';

Future<Map<String, dynamic>?> getAllStudents() async {
  try {
    // Ambil SID dari Hive
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sid = prefs.getString('sid');
    final Uri url = Uri.parse(apiURLALL);
    final http.Response response = await http.get(
      url,
      headers: {
        'Cookie': 'sid=$sid',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      if (kDebugMode) {
        print('Error: ${response.body}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return null;
  }
}

Future<Map<String, dynamic>?> getStudent(
    int limit, int start, String filter) async {
  try {
    // Ambil SID dari Hive
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sid = prefs.getString('sid');
    prefs.getString('selected_outlet');
    String apiUrl = '';

    apiUrl = '${dotenv.env['API_URL']}/api/method/gaStudentList';

    // final Uri url = Uri.parse(apiUrl).replace(queryParameters: {
    //   'fields': '["*"]',
    //   'limit_page_length': limit.toString(),
    //   'limit_start': start.toString(),
    //   // 'filters': '[["name", "=", "Monroe Pos"]]'
    // });

    final Uri url = Uri.parse(apiUrl);

    final http.Response response = await http.get(
      url,
      headers: {
        'Cookie': 'sid=$sid',
        'Content-Type': 'application/json',
        'sekolahproapp': 'PA-1.0.0'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      if (kDebugMode) {
        print('Error: ${response.body}');
      }
      return null;
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error: $error');
    }
    return null;
  }
}
