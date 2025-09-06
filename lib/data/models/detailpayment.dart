import 'package:intl/intl.dart';

class PaymentDetail {
  final String description;
  final double amount;
  final String category;
  final DateTime dueDate;
  final List<PaymentHistoryItem> history; // List untuk riwayat pembayaran.

  PaymentDetail({
    required this.description,
    required this.amount,
    required this.category,
    required this.dueDate,
    required this.history,
  });

  // Dari JSON ke PaymentDetail.
  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    // Akses data dari dalam object 'message'
    final Map<String, dynamic> data = json['message'] ?? {};
    final List<dynamic> receipts = data['receipts'] ?? [];

    return PaymentDetail(
      description: data['remark'] ?? 'Tidak ada deskripsi',
      amount: (data['amount'] as num? ?? 0.0).toDouble(),
      category: data['fee_category'] ?? 'Tidak ada kategori',
      dueDate:
          DateTime.parse(data['due_date'] ?? DateTime.now().toIso8601String()),
      // Ubah setiap item di 'receipts' menjadi object PaymentHistoryItem
      history:
          receipts.map((item) => PaymentHistoryItem.fromJson(item)).toList(),
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

  // Dari JSON ke PaymentHistoryItem.
  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) {
    // Format tanggal dari 'posting_date'
    final DateTime parsedDate = DateTime.parse(
        json['posting_date'] ?? DateTime.now().toIso8601String());
    final String formattedDate =
        DateFormat('d MMMM yyyy', 'id_ID').format(parsedDate);

    return PaymentHistoryItem(
      date: formattedDate,
      amount: (json['paid_amount'] as num? ?? 0.0).toDouble(),
      description: json['remark'] ?? 'Tidak ada deskripsi pembayaran.',
    );
  }
}
