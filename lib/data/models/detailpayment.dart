import 'package:intl/intl.dart';

class PaymentDetail {
  final String description;
  final double amount;
  final String category;
  final DateTime dueDate;
  final List<PaymentHistoryItem> history;

  PaymentDetail({
    required this.description,
    required this.amount,
    required this.category,
    required this.dueDate,
    required this.history,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    final List<dynamic> receiptsData =
        json['receipts'] is List ? json['receipts'] : [];

    return PaymentDetail(
      description: json['remark'] ?? 'Tidak ada deskripsi',
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
      category: json['fee_category'] ?? 'Tidak ada kategori',
      dueDate:
          DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      history: receiptsData
          .whereType<Map<String, dynamic>>()
          .map((item) => PaymentHistoryItem.fromJson(item))
          .toList(),
    );
  }
}

class PaymentHistoryItem {
  final String date;
  final double amount;
  final String description;

  PaymentHistoryItem({
    required this.date,
    required this.amount,
    required this.description,
  });

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      if (json['posting_date'] != null &&
          json['posting_date'].toString().isNotEmpty) {
        parsedDate = DateTime.parse(json['posting_date']);
      } else {
        parsedDate = DateTime.now();
      }
    } catch (e) {
      parsedDate = DateTime.now();
    }

    final String formattedDate =
        DateFormat('d MMMM yyyy', 'id_ID').format(parsedDate);

    return PaymentHistoryItem(
      date: formattedDate,
      amount: (json['paid_amount'] as num? ?? 0.0).toDouble(),
      description: json['remark'] ?? 'Tidak ada deskripsi pembayaran.',
    );
  }
}
