import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  final String paymentListURL =
      '${dotenv.env['API_URL']}/api/method/gaTuitionList';
  final String makePaymentURL =
      '${dotenv.env['API_URL']}/api/method/gaIrecDraft';

  Future<Map<String, dynamic>?> getJadwalBayar({
    required String studentId,
    required String academicYear,
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sid = prefs.getString('sid');

      if (sid == null) {
        if (kDebugMode) {
          print(
              'Error: SID not found in SharedPreferences. User may not be logged in.');
        }
        return null;
      }

      final Map<String, String> queryParameters = {
        'student': studentId,
        'academic_year': academicYear,
      };

      if (page != null) {
        queryParameters['page'] = page.toString();
      }
      if (limit != null) {
        queryParameters['limit'] = limit.toString();
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      final Uri url =
          Uri.parse(paymentListURL).replace(queryParameters: queryParameters);

      final http.Response response = await http.get(
        url,
        headers: {
          'Cookie': 'sid=$sid', // Autentikasi
          'sekolahproapp': 'PA-1.0.0',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> makePayment({
    required String student,
    required List<dynamic> tuitionPlans,
    required String methodOfPayment,
    String? filePath,
  }) async {
    print('cgecje');
    try {
      final Map<String, dynamic> data = {
        "student": student,
        "tuition_plans": tuitionPlans,
        "method": methodOfPayment,
        "proof": filePath,
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
        "sekolahproapp": "PA-1.0.0",
      };

      final response = await http.post(
        Uri.parse(makePaymentURL),
        headers: headers,
        body: jsonEncode(data),
      );

      print('Response status: ${response.statusCode}');

      final responseData = jsonDecode(response.body);
    } catch (e) {
      // Tangani error lain seperti jaringan atau parsing
      print("Exception: $e");
      return {};
    }
    return {};
  }
}
