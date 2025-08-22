import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/presentation/keuangan/widgets/transaction_history_card.dart';
import 'package:guardian_app/widgets/search_card.dart';
import 'package:guardian_app/widgets/dropdown_card.dart';
import 'package:guardian_app/widgets/date_filter.dart'; // 1. Import the date filter
import 'package:intl/intl.dart'; // 2. Import the intl package for date formatting

class RiwayatPembayaran extends StatefulWidget {
  const RiwayatPembayaran({super.key});

  @override
  State<RiwayatPembayaran> createState() => _RiwayatPembayaranState();
}

class _RiwayatPembayaranState extends State<RiwayatPembayaran> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy data for transaction history
  final List<Map<String, dynamic>> _allTransactions = [
    {
      "date": "1 Juli 2025",
      "rawDate": DateTime(2025, 7, 1),
      "amount": "Rp 200.000",
      "description": "Pembayaran Transfer ke BCA #90.00.00",
      "buttonText": "Detail",
      "buttonColor": Colors.grey[600]!,
      "isRejected": false,
    },
    {
      "date": "1 Juli 2025",
      "rawDate": DateTime(2025, 7, 1),
      "amount": "Rp 1.000.000",
      "description": "Pembayaran Transfer ke BCA #90.00.00",
      "buttonText": "Detail",
      "buttonColor": Colors.grey[600]!,
      "isRejected": true,
      "rejectionMessage": "Konfirmasi ditolak karena attachment tidak valid",
    },
    {
      "date": "30 Juni 2025",
      "rawDate": DateTime(2025, 6, 30),
      "amount": "Rp 1.000.000",
      "description": "Pembayaran Tunai ke Kasir #09.00.00",
      "buttonText": "Unduh Bukti",
      "buttonColor": const Color(0xFF7D5C86),
      "isRejected": false,
    },
    {
      "date": "22 Agustus 2025",
      "rawDate": DateTime(2025, 8, 22),
      "amount": "Rp 550.000",
      "description": "Pembayaran SPP Agustus",
      "buttonText": "Unduh Bukti",
      "buttonColor": const Color(0xFF7D5C86),
      "isRejected": false,
    }
  ];

  List<Map<String, dynamic>> _filteredTransactions = [];
  DateTime? _startDate;
  DateTime? _endDate;
  String _currentDateFilterText = 'Semua Tanggal';

  @override
  void initState() {
    super.initState();
    _filteredTransactions = _allTransactions;
    _searchController.addListener(_applyAllFilters);
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyAllFilters);
    _searchController.dispose();
    super.dispose();
  }

  // Semua filter aktif
  void _applyAllFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _allTransactions.where((transaction) {
        final transactionDate = transaction['rawDate'] as DateTime;
        bool dateMatches = false;
        if (_startDate == null) {
          dateMatches = true; // Default semua tanggal
        } else if (_endDate == null ||
            DateUtils.isSameDay(_startDate, _endDate)) {
          dateMatches = DateUtils.isSameDay(transactionDate, _startDate);
        } else {
          dateMatches = (transactionDate
                  .isAfter(_startDate!.subtract(const Duration(days: 1))) &&
              transactionDate.isBefore(_endDate!.add(const Duration(days: 1))));
        }

        bool searchMatches = true;
        if (query.isNotEmpty) {
          final description =
              transaction['description'].toString().toLowerCase();
          final date = transaction['date'].toString().toLowerCase();
          final amount = transaction['amount'].toString().toLowerCase();
          searchMatches = description.contains(query) ||
              date.contains(query) ||
              amount.contains(query);
        }

        return dateMatches && searchMatches;
      }).toList();
    });
  }

  // Show filter tanggal sebagai modal
  void _showDateFilter() async {
    final result = await showModalBottomSheet<Map<String, DateTime?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: DateFilter(
          initialStartDate: _startDate,
          initialEndDate: _endDate,
          onBack: () => Navigator.of(context).pop(),
          onApply: (newStartDate, newEndDate) {
            Navigator.of(context).pop({
              'startDate': newStartDate,
              'endDate': newEndDate,
            });
          },
        ),
      ),
    );
    print("Result from bottom sheet: $result");

    // Handle data saat kembali ke main screen
    if (result != null) {
      setState(() {
        _startDate = result['startDate'];
        _endDate = result['endDate'];

        // Update display teks
        if (_startDate != null) {
          final format = DateFormat('d MMM yyyy');
          if (_endDate == null || DateUtils.isSameDay(_startDate, _endDate)) {
            _currentDateFilterText = format.format(_startDate!);
          } else {
            _currentDateFilterText =
                '${format.format(_startDate!)} - ${format.format(_endDate!)}';
          }
        } else {
          _currentDateFilterText = 'Semua Tanggal';
        }
      });
      _applyAllFilters(); // Re-apply
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Riwayat Pembayaran"),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade200,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownCard(
                  message: _currentDateFilterText,
                  onTap: _showDateFilter,
                ),
              ),
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
                              // ignore: avoid_print
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
