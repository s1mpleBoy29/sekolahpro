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
    final Map<String, dynamic> viewData = json['view'] ?? {};
    final List<dynamic> historyData =
        json['incoming_receipt'] is List ? json['incoming_receipt'] : [];

    String category = 'Tidak ada kategori';
    if (viewData['articles'] is List &&
        (viewData['articles'] as List).isNotEmpty) {
      final article = (viewData['articles'] as List).first;
      category = (article['article'] as String?)?.split(' - ').last ?? category;
    }

    return PaymentDetail(
      description: viewData['remark'] ?? 'Tidak ada deskripsi',
      amount: (viewData['amount'] as num? ?? 0.0).toDouble(),
      category: category,
      dueDate: DateTime.parse(
          viewData['due_date'] ?? DateTime.now().toIso8601String()),
      history: historyData
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
      if (json['date'] != null && json['date'].toString().isNotEmpty) {
        parsedDate = DateTime.parse(json['date']);
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
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
      description: json['remark'] ?? 'Tidak ada deskripsi pembayaran.',
    );
  }
}
