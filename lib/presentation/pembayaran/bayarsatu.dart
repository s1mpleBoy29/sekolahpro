import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/utils/number_format.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/bottom_bar.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/instruction_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/payment_steps.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/due_card_small.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/search_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/dropdown_card.dart';

class BayarSatuScreen extends StatefulWidget {
  const BayarSatuScreen({super.key});
  @override
  _BayarSatuState createState() => _BayarSatuState();
}

class _BayarSatuState extends State<BayarSatuScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allDueItems = [
    {
      "id": 1,
      "isOverdue": true,
      "due_date": "2025-07-10",
      "amount": 300000,
      "deskripsi": "Uang Sekolah Chandra Bulan Juli\nTahun Ajaran 2025 / 2026",
    },
    {
      "id": 2,
      "isOverdue": false,
      "due_date": "2025-08-10",
      "amount": 1200000,
      "deskripsi": "Uang Buku & Seragam\nTahun Ajaran 2025 / 2026",
    },
    {
      "id": 3,
      "isOverdue": false,
      "due_date": "2025-09-10",
      "amount": 300000,
      "deskripsi":
          "Uang Sekolah Chandra Bulan Agustus\nTahun Ajaran 2025 / 2026",
    }
  ];

  List<Map<String, dynamic>> _filteredDueItems = [];
  final Set<int> _selectedItemIds = {};

  @override
  void initState() {
    super.initState();
    _filteredDueItems = _allDueItems;
    // Listener input user
    _searchController.addListener(_filterDueItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterDueItems);
    _searchController.dispose();
    super.dispose();
  }

  // Filter untuk cari tagihan
  void _filterDueItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDueItems = _allDueItems.where((item) {
        final description = item['deskripsi'].toString().toLowerCase();
        return description.contains(query);
      }).toList();
    });
  }

  // Toggle seleksi untuk due card
  void _toggleCardSelection(int itemId) {
    setState(() {
      if (_selectedItemIds.contains(itemId)) {
        _selectedItemIds.remove(itemId);
      } else {
        _selectedItemIds.add(itemId);
      }
    });
  }

  // Menghitung total dari item yang dipilih
  int _calculateTotal() {
    int total = 0;
    // Pengulangan untuk kepastian perhitungan
    for (var item in _allDueItems) {
      if (_selectedItemIds.contains(item['id'])) {
        total += item['amount'] as int;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final int totalAmount = _calculateTotal();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pembayaran"),
        shape: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
              child: Column(
                children: [
                  const PaymentSteps(stepsekarang: 0),
                  const SizedBox(height: 12.0),
                  const InstructionCard(
                    number: '1',
                    teksInstruksi: 'Konfirmasi kewajiban yang harus dibayar.',
                  ),
                  // Controller untuk pencarian tagihan
                  const DropdownCard(),
                  SearchCard(controller: _searchController),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredDueItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredDueItems[index];
                      final itemId = item['id'] as int;
                      return DueCard(
                        isOverdue: item['isOverdue'],
                        harga: numberFormat('rp_fixed', item['amount']),
                        deskripsi: item['deskripsi'],
                        isSelected: _selectedItemIds.contains(itemId),
                        onTap: () => _toggleCardSelection(itemId),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        totalAmount: totalAmount,
        onContinuePressed: () {
          if (totalAmount > 0) {
            Navigator.pushNamed(context, AppRoutes.bayarDuaScreen);
          }
        },
      ),
    );
  }
}
