import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:guardian_app/data/models/ad.dart';

Future<List<Ad>?> getAds() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final sid = prefs.getString('sid');

    if (sid == null) {
      debugPrint('Error: SID not found.');
      return null;
    }

    final Map<String, String> queryParameters = {
      'size': '350x100',
      'limit': '10',
    };

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/method/gaAdsList')
        .replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'sekolahproapp': 'PA-1.0.0',
        'Cookie': 'sid=$sid',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('message') && data['message'] is Map) {
        final Map<String, dynamic> messageObject = data['message'];
        if (messageObject.containsKey('lists') &&
            messageObject['lists'] is List) {
          final List<dynamic> adList = messageObject['lists'];
          return adList
              .map((adJson) => Ad.fromJson(adJson as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } else {
      return null;
    }
  } catch (error) {
    debugPrint('An exception occurred in getAds(): $error');
    return null;
  }
}
