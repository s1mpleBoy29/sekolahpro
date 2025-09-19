import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/providers/bill_provider.dart';
import 'package:guardian_app/data/models/mode_of_payment.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/payment_steps.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/rekening_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/instruction_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/rincian_tagihan.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

class BayarDuaScreen extends StatefulWidget {
  const BayarDuaScreen({super.key});

  @override
  State<BayarDuaScreen> createState() => _BayarDuaScreenState();
}

class _BayarDuaScreenState extends State<BayarDuaScreen> {
  List<ModeOfPayment> modeOfPayments = [];
  ModeOfPayment? selectedModeOfPayment;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchModePayment();
  }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Nomor rekening disalin!"),
          backgroundColor: theme.colorScheme.primary,
          duration: const Duration(seconds: 1),
        ),
      );
    });
  }

  void fetchModePayment() {
    final billProvider = Provider.of<BillProvider>(context, listen: false);
    setState(() {
      modeOfPayments = billProvider.modeOfPayments;
      if (modeOfPayments.isNotEmpty) {
        selectedModeOfPayment = modeOfPayments[0];
      }
    });
  }

  void selectModeOfPayment(ModeOfPayment modePayment) {
    final billProvider = Provider.of<BillProvider>(context, listen: false);

    billProvider.setSelectedModeOfPayment(modePayment);
    setState(() {
      selectedModeOfPayment = modePayment;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments passed from the previous screen.
    final selectedItems = ModalRoute.of(context)!.settings.arguments
        as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
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
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text("Pilih Rekening Tujuan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: modeOfPayments.length,
                itemBuilder: (context, index) {
                  final modeOfPayment = modeOfPayments[index];
                  return RekeningCard(
                    bankName: modeOfPayment.method,
                    accountName: modeOfPayment.transferName,
                    accountNumber: modeOfPayment.transferAccount,
                    isSelected: _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      selectModeOfPayment(modeOfPayment);
                    },
                    onCopy: () {
                      _copyToClipboard(modeOfPayment.transferAccount);
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
      bottomNavigationBar: BottomBar(
          isNeeded: false,
          totalAmount:
              1, // TotalAmount tidak digunakan di sini, nilai 1 hanya example
          onContinuePressed: () {
            Navigator.pushNamed(context, AppRoutes.bayarTigaScreen,
                arguments: selectedItems);
          }),
    );
  }
}
