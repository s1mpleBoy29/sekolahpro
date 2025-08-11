import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/presentation/keuangan/widgets/transaction_history_card.dart'; // Make sure to import your card

class RiwayatPembayaran extends StatelessWidget {
  final List<Map<String, dynamic>> _transactionHistory = [
    {
      "date": "1 Juli 2025",
      "amount": "Rp 200.000",
      "description": "Pembayaran Transfer ke BCA #90.00.00",
      "buttonText": "Detail",
      "buttonColor": Colors.grey[600]!,
      "isRejected": false,
    },
    {
      "date": "1 Juli 2025",
      "amount": "Rp 1.000.000",
      "description": "Pembayaran Transfer ke BCA #90.00.00",
      "buttonText": "Detail",
      "buttonColor": Colors.grey[600]!,
      "isRejected": true,
      "rejectionMessage": "Konfirmasi ditolak karena attachment tidak valid",
    },
    {
      "date": "30 Juni 2025",
      "amount": "Rp 1.000.000",
      "description": "Pembayaran Tunai ke Kasir #09.00.00",
      "buttonText": "Unduh Bukti",
      "buttonColor": theme.colorScheme.primary,
      "isRejected": false,
    }
  ];

  RiwayatPembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Riwayat Pembayaran"),
        shape: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        // Added SafeArea
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactionHistory.length,
              itemBuilder: (context, index) {
                final item = _transactionHistory[index];
                return TransactionHistoryCard(
                  date: item['date'],
                  amount: item['amount'],
                  description: item['description'],
                  buttonText: item['buttonText'],
                  buttonColor: item['buttonColor'],
                  isRejected: item['isRejected'],
                  rejectionMessage: item['rejectionMessage'],
                  onPressed: () {
                    // Handle button press
                    print(
                        '${item['buttonText']} pressed for item ${index + 1}');
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
