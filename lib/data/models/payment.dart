import 'package:flutter/material.dart';

class Payment {
  final String description;
  final double amount;
  final String status;
  final DateTime dueDate;
  final bool isOverdue;

  Payment({
    required this.description,
    required this.amount,
    required this.status,
    required this.dueDate,
    required this.isOverdue,
  });

  // Dari JSON ke Payment
  factory Payment.fromJson(Map<String, dynamic> json) {
    DateTime parsedDueDate = DateTime.parse(json['due_date']);
    bool overdue =
        parsedDueDate.isBefore(DateTime.now()) && json['status'] != 'Paid';

    //Variabel dari API
    return Payment(
      description: json['remark'] ?? 'No Description',
      amount: (json['amount'] as num).toDouble(),
      status: _mapStatus(json['status']),
      dueDate: parsedDueDate,
      isOverdue: overdue,
    );
  }

  static String _mapStatus(String apiStatus) {
    switch (apiStatus) {
      case 'Paid':
        return 'Lunas';
      case 'Unpaid':
        return 'Belum Lunas';
      case 'Overdue':
        return 'Belum Lunas';
      default:
        return 'Unknown';
    }
  }

  Color get statusColor {
    if (status == 'Lunas') {
      return Colors.green;
    }
    if (isOverdue) {
      return Colors.red;
    }
    return Colors.grey;
  }
}
