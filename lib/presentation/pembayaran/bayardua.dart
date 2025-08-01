import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/instruction_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/payment_steps.dart';

class BayarDuaScreen extends StatefulWidget {
  @override
  _BayarDuaState createState() => _BayarDuaState();
}

class _BayarDuaState extends State<BayarDuaScreen> {
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
      body: const Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  PaymentSteps(stepsekarang: 1),
                  SizedBox(
                    height: 12.0,
                  ),
                  InstructionCard(
                    number: '2',
                    teksInstruksi: 'Konfirmasi tagihan yang harus dibayar.',
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
