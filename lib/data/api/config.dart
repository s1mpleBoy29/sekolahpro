import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>?> getConfig() async {
  try {
    // Ambil SID dari Hive
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sid = prefs.getString('sid');
    // prefs.getString('selected_outlet');
    String apiUrl = '';

    apiUrl = '${dotenv.env['API_URL']}/api/method/gaSetting';

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
