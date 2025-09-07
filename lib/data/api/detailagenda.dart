import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guardian_app/data/models/Agenda.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Fungsi untuk mendapatkan detail agenda berdasarkan student dan agenda ID
Future<AgendaDetail?> getAgendaDetail({
  required String studentId,
  required String agendaId,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? sid = prefs.getString('sid');

  if (sid == null) {
    if (kDebugMode) {
      print('Error (Agenda): SID not found in SharedPreferences. User may not be logged in.');
    }
    return null;
  }

  final String apiUrl = '${dotenv.env['API_URL']}/api/method/gaAgendaView';

  final Map<String, String> queryParameters = {
    'student': studentId,
    'agenda': agendaId,
  };

  final Uri url = Uri.parse(apiUrl).replace(queryParameters: queryParameters);

  if (kDebugMode) {
    print('Making API call to: $url');
    print('Student ID: $studentId');
    print('Agenda ID: $agendaId');
    print('Using SID: ${sid.substring(0, 10)}...'); // Only show first 10 chars for security
  }

  try {
    final http.Response response = await http.get(
      url,
      headers: {
        'Cookie': 'sid=$sid',
        'sekolahproapp': 'PA-1.0.0',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (kDebugMode) {
      print('Response Status Code: ${response.statusCode}');
      print('Agenda Detail API Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      // Check if the response contains an error message
      if (responseData['message'] is String && responseData['message'] == 'Invalid Request') {
        if (kDebugMode) {
          print('API returned "Invalid Request" - check student ID and agenda ID');
        }
        return null;
      }
      
      // Try to extract agenda data from different possible response structures
      Map<String, dynamic>? agendaData;
      
      if (responseData['message'] is Map<String, dynamic>) {
        final messageData = responseData['message'] as Map<String, dynamic>;
        
        // Structure 1: message.view (most likely based on endpoint name)
        if (messageData.containsKey('view') && messageData['view'] is Map<String, dynamic>) {
          agendaData = messageData['view'] as Map<String, dynamic>;
        }
        // Structure 2: message.data
        else if (messageData.containsKey('data') && messageData['data'] is Map<String, dynamic>) {
          agendaData = messageData['data'] as Map<String, dynamic>;
        }
        // Structure 3: message.agenda
        else if (messageData.containsKey('agenda') && messageData['agenda'] is Map<String, dynamic>) {
          agendaData = messageData['agenda'] as Map<String, dynamic>;
        }
        // Structure 4: message itself contains agenda data
        else if (messageData.containsKey('detail') || messageData.containsKey('from') || messageData.containsKey('to')) {
          agendaData = messageData;
        }
      }
      // Structure 5: Direct data in root level
      else if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
        agendaData = responseData['data'] as Map<String, dynamic>;
      }

      if (agendaData != null) {
        if (kDebugMode) {
          print('Found agenda data structure:');
          print('Keys available: ${agendaData.keys.toList()}');
          print('Raw agenda data: $agendaData');
        }
        
        try {
          return AgendaDetail.fromJson(agendaData);
        } catch (parseError) {
          if (kDebugMode) {
            print('Error parsing AgendaDetail from JSON: $parseError');
            print('Error type: ${parseError.runtimeType}');
            if (parseError is TypeError) {
              print('TypeError details: $parseError');
            }
            print('Raw agenda data keys: ${agendaData.keys.toList()}');
            print('Raw agenda data values: ${agendaData.values.toList()}');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print('No valid agenda data found in response');
          print('Full response structure: $responseData');
          print('Response keys: ${responseData.keys.toList()}');
          if (responseData['message'] is Map) {
            final msg = responseData['message'] as Map;
            print('Message keys: ${msg.keys.toList()}');
          }
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        print('Error fetching agenda detail: Status Code ${response.statusCode}');
        print('Response Headers: ${response.headers}');
        print('Response Body: ${response.body}');
      }
      return null;
    }
  } catch (error) {
    if (kDebugMode) {
      print('Exception occurred while fetching agenda detail: $error');
      print('Error type: ${error.runtimeType}');
      print('Stack trace: ${StackTrace.current}');
    }
    return null;
  }
}

// Helper function to validate agenda and student ID format
bool isValidAgendaFormat(String agendaId) {
  // AG-XXXX-XXXX-XXXX format
  RegExp agendaPattern = RegExp(r'^AG-[A-Z0-9]{4}-[0-9]{4}-[0-9]{4}$');
  return agendaPattern.hasMatch(agendaId);
}

bool isValidStudentFormat(String studentId) {
  // XXXX.XXXX format
  RegExp studentPattern = RegExp(r'^[A-Z0-9]{4}\.[0-9]{4}$');
  return studentPattern.hasMatch(studentId);
}

// Alternative function with validation
Future<AgendaDetail?> getAgendaDetailWithValidation({
  required String studentId,
  required String agendaId,
}) async {
  if (kDebugMode) {
    print('Validating input parameters:');
    print('Student ID: $studentId (Valid: ${isValidStudentFormat(studentId)})');
    print('Agenda ID: $agendaId (Valid: ${isValidAgendaFormat(agendaId)})');
  }

  if (!isValidStudentFormat(studentId)) {
    if (kDebugMode) {
      print('Warning: Student ID format might be incorrect. Expected format: XXXX.XXXX');
    }
  }

  if (!isValidAgendaFormat(agendaId)) {
    if (kDebugMode) {
      print('Warning: Agenda ID format might be incorrect. Expected format: AG-XXXX-XXXX-XXXX');
    }
  }

  return getAgendaDetail(studentId: studentId, agendaId: agendaId);
}