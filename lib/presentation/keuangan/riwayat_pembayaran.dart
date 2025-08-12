import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/presentation/keuangan/widgets/transaction_history_card.dart';
import 'package:guardian_app/widgets/search_card.dart';

class RiwayatPembayaran extends StatefulWidget {
  const RiwayatPembayaran({super.key});

  @override
  State<RiwayatPembayaran> createState() => _RiwayatPembayaranState();
}

class _RiwayatPembayaranState extends State<RiwayatPembayaran> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allTransactions = [
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

  List<Map<String, dynamic>> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _filteredTransactions = _allTransactions;
    _searchController.addListener(_filterTransactions);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTransactions);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTransactions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _allTransactions.where((transaction) {
        final description = transaction['description'].toString().toLowerCase();
        final date = transaction['date'].toString().toLowerCase();
        final amount = transaction['amount'].toString().toLowerCase();
        return description.contains(query) ||
            date.contains(query) ||
            amount.contains(query);
      }).toList();
    });
  }

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Column(
            children: [
              SearchCard(controller: _searchController),
              const SizedBox(height: 8.0),
              Expanded(
                child: _filteredTransactions.isEmpty
                    ? const Center(
                        child: Text("Tidak ada riwayat ditemukan."),
                      )
                    : ListView.builder(
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final item = _filteredTransactions[index];
                          return TransactionHistoryCard(
                            date: item['date'],
                            amount: item['amount'],
                            description: item['description'],
                            buttonText: item['buttonText'],
                            buttonColor: item['buttonColor'],
                            isRejected: item['isRejected'],
                            rejectionMessage: item['rejectionMessage'],
                            onPressed: () {
                              print(
                                  '${item['buttonText']} pressed for item ${index + 1}');
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
