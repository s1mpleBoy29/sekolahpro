import 'package:flutter/foundation.dart';
import 'package:guardian_app/data/api/payment.dart';
import 'package:guardian_app/data/models/bill.dart';
import 'package:guardian_app/data/models/mode_of_payment.dart';

class BillAction {
  static Future<Map<String, dynamic>> getBillAndMethod(
    String studentId,
    String academicYear,
  ) async {
    try {
      final payment = PaymentService();
      final response = await payment.getJadwalBayar(
        studentId: studentId,
        academicYear: academicYear,
      );

      if (response == null || response['message'] == null) {
        return {"bills": <Bill>[], "methods": <ModeOfPayment>[]};
      }

      // if (response == null || response['message'] == null) {
      //   return [];
      // }

      print('result from action : $response');
      // final List<dynamic> itemsJson = response['message']['lists'] ?? [];

      final List<dynamic> itemsJson = response['message']['lists'] ?? [];
      final List<dynamic> methodsJson = response['message']['methods'] ?? [];

      // return itemsJson.map((e) => Bill.fromJson(e)).toList();
      final bills = itemsJson.map((e) => Bill.fromJson(e)).toList();
      final methods =
          methodsJson.map((e) => ModeOfPayment.fromJson(e)).toList();

      return {"bills": bills, "methods": methods};
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      throw Exception('Error fetching items: $error');
    }
  }
}
