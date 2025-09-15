import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String apiURL = '${dotenv.env['API_URL']}/api/method/gaAdsList';

Future<Map<String, dynamic>?> getAds(
  String size,
  int limit,
  String? today,
) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sid = prefs.getString('sid');

    final Uri url = Uri.parse(apiURL).replace(
      queryParameters: {
        'size': size,
        'limit': limit,
      },
    );

    final http.Response response = await http.get(
      url,
      headers: {
        'Cookie': 'sid=$sid',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Jika berhasil, parsing JSON ke Map
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return null;
  }
}
