import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/instruction_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/payment_steps.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/due_card_small.dart';
// import 'package:guardian_app/presentation/pembayaran/widgets/bottom_bar.dart';

class BayarSatuScreen extends StatefulWidget {
  const BayarSatuScreen({super.key});
  @override
  _BayarSatuState createState() => _BayarSatuState();
}

class _BayarSatuState extends State<BayarSatuScreen> {
  final List<Map<String, dynamic>> _dueItems = [
    {
      "id": 1,
      "isOverdue": true,
      "harga": "Rp 300.000",
      "deskripsi": "Uang Sekolah Chandra Bulan Juli\nTahun Ajaran 2025 / 2026",
    },
    {
      "id": 2,
      "isOverdue": false,
      "harga": "Rp 1.200.000",
      "deskripsi": "Uang Buku & Seragam\nTahun Ajaran 2025 / 2026",
    },
    {
      "id": 3,
      "isOverdue": false,
      "harga": "Rp 300.000",
      "deskripsi":
          "Uang Sekolah Chandra Bulan Agustus\nTahun Ajaran 2025 / 2026",
    }
  ];

  final Set<int> _selectedCardIndices = {0};

  void _toggleCardSelection(int index) {
    setState(() {
      if (_selectedCardIndices.contains(index)) {
        _selectedCardIndices.remove(index);
      } else {
        _selectedCardIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const PaymentSteps(stepsekarang: 0),
                  const SizedBox(height: 12.0),
                  const InstructionCard(
                    number: '1',
                    teksInstruksi: 'Pilih kewajiban yang harus dibayar.',
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _dueItems.length,
                    itemBuilder: (context, index) {
                      final item = _dueItems[index];
                      return DueCard(
                        isOverdue: item['isOverdue'],
                        harga: item['harga'],
                        deskripsi: item['deskripsi'],
                        isSelected: _selectedCardIndices.contains(index),
                        onTap: () => _toggleCardSelection(index),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
