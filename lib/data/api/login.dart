import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Gunakan dotenv untuk membaca URL API
  final String baseUrl = "${dotenv.env['API_URL']}/api/method/login";
  final String resetPasswordUrl =
      "${dotenv.env['API_URL']}/api/method/frappe.core.doctype.user.user.update_password";

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      // Data yang akan dikirim ke server
      final Map<String, dynamic> data = {
        "usr": username,
        "pwd": password,
      };

      // Header yang diperlukan
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      // Kirim request ke server
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        log(username.toString());

        // Ambil data dari respons API
        final String message = responseData["message"] ?? "No message";
        final String homePage = responseData["home_page"] ?? "/";
        final String fullName = responseData["full_name"] ?? "Anonymous";

        // Log hasil parsing
        print("Message: $message");
        print("Home Page: $homePage");
        print("Full Name: $fullName");

        final Map<String, dynamic> data = jsonDecode(response.body);
        String? cookie = response.headers['set-cookie'];
        if (cookie != null) {
          RegExp regex = RegExp(r'sid=([^;]+)');
          Match? match = regex.firstMatch(cookie);
          if (match != null) {
            String sid = match.group(1)!;

            final String url = "${dotenv.env['API_URL']}/api/method/gaWhoami";
            final Map<String, String> headers = {
              "Content-Type": "application/json",
              'Cookie': 'sid=$sid',
              'sekolahproapp': 'PA-1.0.0',
            };

            final responseUser = await http.get(
              Uri.parse(url),
              headers: headers,
            );

            print('check user, ${responseUser.body}');

            if (responseUser.statusCode == 200) {
              final Map<String, dynamic> responseData =
                  jsonDecode(responseUser.body);

              print('check responseData, ${responseData['message']['user']}');
              print(
                  'check responseData, ${responseData['message']['guardian']}');

              return {
                "message": message,
                "homePage": homePage,
                "fullName": fullName,
                "sid": sid,
                "role": responseData['message']['user'],
                "user": responseData['message']['user'],
                "guardian": responseData['message']['guardian'],
              };
            }
          }
        }
      } else {
        // Handle jika status code bukan 200
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      // Tangani error lain seperti jaringan atau parsing
      print("Exception: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "old_password": oldPassword,
        "new_password": newPassword,
      };

      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('sid');

      if (sid == null) {
        throw Exception('User not logged in');
      }

      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Cookie": "sid=$sid",
      };

      final response = await http.post(
        Uri.parse(resetPasswordUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "Password successfully updated",
        };
      } else {
        return {
          "success": false,
          "message": responseData["message"] ?? "Failed to update password",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}
