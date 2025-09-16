import 'package:intl/intl.dart';

class PaymentDetail {
  final String description;
  final double amount;
  final DateTime dueDate;
  final List<PaymentHistoryItem> history;
  final String outgoingInvoiceId; // ID for "Unduh Faktur"
  final String outgoingInvoiceUrl; // Base URL for invoice
  final String incomingReceiptUrl; // Base URL for receipt

  PaymentDetail({
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.history,
    required this.outgoingInvoiceId,
    required this.outgoingInvoiceUrl,
    required this.incomingReceiptUrl,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> viewData = json['view'] ?? {};
    final List<dynamic> historyData =
        json['incoming_receipt'] is List ? json['incoming_receipt'] : [];
    final Map<String, dynamic> downloadUrls = json['download_url'] ?? {};

    return PaymentDetail(
      description: viewData['remark'] ?? 'Tidak ada deskripsi',
      amount: (viewData['amount'] as num? ?? 0.0).toDouble(),
      dueDate: DateTime.parse(
          viewData['due_date'] ?? DateTime.now().toIso8601String()),
      // As per your request, use 'view.name' for the main invoice download
      outgoingInvoiceId: viewData['name'] ?? '',
      outgoingInvoiceUrl: downloadUrls['outgoing_invoice'] ?? '',
      incomingReceiptUrl: downloadUrls['incoming_receipt'] ?? '',
      history: historyData
          .whereType<Map<String, dynamic>>()
          .map((item) => PaymentHistoryItem.fromJson(item))
          .toList(),
    );
  }
}

class PaymentHistoryItem {
  final String name; // The unique ID for the receipt, e.g., "IREC-..."
  final String date;
  final double amount;
  final String description;

  PaymentHistoryItem({
    required this.name,
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
      name: json['name'] ?? '', // Capture the receipt ID
      date: formattedDate,
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
      description: json['remark'] ?? 'Tidak ada deskripsi pembayaran.',
    );
  }
}
