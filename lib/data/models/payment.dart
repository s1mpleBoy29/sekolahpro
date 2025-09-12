import 'package:flutter/material.dart';

class PaymentSummary {
  final double totalKewajiban;
  final double totalTunggakan;

  PaymentSummary({
    required this.totalKewajiban,
    required this.totalTunggakan,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      totalKewajiban: (json['total_kewajiban'] as num? ?? 0.0).toDouble(),
      totalTunggakan: (json['total_tunggakan'] as num? ?? 0.0).toDouble(),
    );
  }
}

class PaymentData {
  final List<Payment> payments;
  final PaymentSummary summary;

  PaymentData({
    required this.payments,
    required this.summary,
  });
}

class Payment {
  final String description;
  final double amount;
  final String status;
  final bool isOverdue;
  final DateTime dueDate;

  Payment({
    required this.description,
    required this.amount,
    required this.status,
    required this.isOverdue,
    required this.dueDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    final double outstanding = (json['outstanding'] as num? ?? 0.0).toDouble();
    final String status = outstanding > 0 ? 'Belum Lunas' : 'Lunas';
    final DateTime dueDate =
        DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String());
    final bool isOverdue = status == 'Belum Lunas' &&
        dueDate.isBefore(DateUtils.dateOnly(DateTime.now()));

    return Payment(
      description: json['remark'] ?? 'Tidak ada deskripsi',
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
      status: status,
      isOverdue: isOverdue,
      dueDate: dueDate,
    );
  }
}
