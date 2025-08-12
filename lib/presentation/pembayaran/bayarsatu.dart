import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/utils/number_format.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/bottom_bar.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/instruction_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/payment_steps.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/due_card_small.dart';
import 'package:guardian_app/widgets/search_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/dropdown_card.dart';
import 'package:guardian_app/presentation/pilihanak/pilihanak.dart';

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
      "amount": 300000,
      "deskripsi": "Uang Sekolah Chandra Bulan Juli\nTahun Ajaran 2025 / 2026",
    },
    {
      "id": 2,
      "isOverdue": false,
      "amount": 1200000,
      "deskripsi": "Uang Buku & Seragam\nTahun Ajaran 2025 / 2026",
    },
    {
      "id": 3,
      "isOverdue": false,
      "amount": 300000,
      "deskripsi":
          "Uang Sekolah Chandra Bulan Agustus\nTahun Ajaran 2025 / 2026",
    },
    {
      "id": 4,
      "isOverdue": false,
      "amount": 600000,
      "deskripsi": "Kegiatan Tahunan Sekolah\nTahun Ajaran 2025 / 2026",
    }
  ];

  List<Map<String, dynamic>> _filteredDueItems = [];
  final Set<int> _selectedItemIds = {};
  String _currentStudentName = 'Candra Wijaya';

  // Listener input user
  @override
  void initState() {
    super.initState();
    _filteredDueItems = _allDueItems;
    _searchController.addListener(_filterDueItems);
  }

  // Listener input user dihapus
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

  void _navigateToAnakScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PilihAnakScreen(
          postSelectionAction: PostSelectionAction.goBack,
        ),
      ),
    );
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: Column(
                  children: [
                    const PaymentSteps(stepsekarang: 0),
                    const SizedBox(height: 12.0),
                    const InstructionCard(
                      number: '1',
                      teksInstruksi: 'Konfirmasi kewajiban yang harus dibayar.',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownCard(
                        studentName: _currentStudentName,
                        onTap: () {
                          _navigateToAnakScreen();
                        },
                      ),
                    ),
                    // Controller untuk pencarian tagihan
                    SearchCard(controller: _searchController),
                    // Card untuk menampilkan daftar tagihan
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
      ),
      // Navigasi ke layar berikutnya
      // Hanya aktif jika ada tagihan yang dipilih
      bottomNavigationBar: BottomBar(
        isNeeded: true,
        totalAmount: totalAmount,
        onContinuePressed: () {
          if (totalAmount > 0) {
            final selectedItems = _allDueItems
                .where((item) => _selectedItemIds.contains(item['id']))
                .toList();
            Navigator.pushNamed(context, AppRoutes.bayarDuaScreen,
                arguments: selectedItems);
          } else {
            //Memakai SnackBar, bisa juga Toast (Toast belum diinstall depndensi-nya)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Tidak ada tagihan yang dipilih"),
                backgroundColor: theme.colorScheme.primary,
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }
}
