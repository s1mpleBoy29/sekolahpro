import 'package:flutter/material.dart';

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

  // Dari JSON ke Payment.
  factory Payment.fromJson(Map<String, dynamic> json) {
    final double outstanding = (json['outstanding'] as num? ?? 0.0).toDouble();

    // Jika outstanding > 0, maka dianggap Belum Lunas.
    final String status = outstanding > 0 ? 'Belum Lunas' : 'Lunas';

    // Ambil dan parse tanggal jatuh tempo.
    final DateTime dueDate =
        DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String());

    // Cek apakah sudah lewat tanggal jatuh tempo dan belum lunas.
    final bool isOverdue = status == 'Belum Lunas' &&
        dueDate.isBefore(DateUtils.dateOnly(DateTime.now()));

    //Variabel dari API
    return Payment(
      description: json['remark'] ?? 'Tidak ada deskripsi',
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
      status: status,
      isOverdue: isOverdue,
      dueDate: dueDate,
    );
  }
}
