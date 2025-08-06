import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/payment_steps.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/rekening_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/instruction_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/rincian_tagihan.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/bottom_bar.dart';

// This can now be a StatefulWidget to manage the selected bank index.
class BayarDuaScreen extends StatefulWidget {
  const BayarDuaScreen({super.key});

  @override
  State<BayarDuaScreen> createState() => _BayarDuaScreenState();
}

class _BayarDuaScreenState extends State<BayarDuaScreen> {
  final List<Map<String, String>> _rekeningList = [
    {
      "bankName": "BANK BCA",
      "accountName": "Yayasan ABC",
      "accountNumber": "1234567890",
    },
    {
      "bankName": "BANK MANDIRI",
      "accountName": "Yayasan ABC",
      "accountNumber": "0987654321",
    },
    {
      "bankName": "BANK BNI",
      "accountName": "Yayasan ABC",
      "accountNumber": "1122334455",
    },
  ];

  int _selectedIndex = 0;

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor rekening disalin!")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments passed from the previous screen.
    final selectedItems = ModalRoute.of(context)!.settings.arguments
        as List<Map<String, dynamic>>;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PaymentSteps(stepsekarang: 1),
              const SizedBox(height: 12),
              const InstructionCard(
                number: '2',
                teksInstruksi:
                    'Lakukan pembayaran sesuai total tagihan ke salah satu rekening di bawah ini.',
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Pilih Rekening Tujuan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _rekeningList.length,
                itemBuilder: (context, index) {
                  final rekening = _rekeningList[index];
                  return RekeningCard(
                    bankName: rekening['bankName']!,
                    accountName: rekening['accountName']!,
                    accountNumber: rekening['accountNumber']!,
                    isSelected: _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    onCopy: () {
                      _copyToClipboard(rekening['accountNumber']!);
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              RincianTagihan(selectedItems: selectedItems),
            ],
          ),
        ),
      ),
      // Navigasi ke layar berikutnya
      // Hanya aktif jika ada tagihan yang dipilih
      bottomNavigationBar: BottomBar(
          isNeeded: false,
          totalAmount: 1,
          onContinuePressed: () {
            Navigator.pushNamed(context, AppRoutes.bayarDuaScreen,
                arguments: selectedItems);
          }),
    );
  }
}
