import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/payment_steps.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/instruction_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/bottom_bar.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/upload_file.dart'; // Import the new widget

class BayarTigaScreen extends StatefulWidget {
  const BayarTigaScreen({super.key});

  @override
  State<BayarTigaScreen> createState() => _BayarTigaScreenState();
}

class _BayarTigaScreenState extends State<BayarTigaScreen> {
  // Bisa ditambahkan depedensi seperti file_picker
  void _pickFile() {
    print("Upload file, buka file_picker");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Membuka..."),
        backgroundColor: theme.colorScheme.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pembayaran"),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
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
              const PaymentSteps(stepsekarang: 2),
              const SizedBox(height: 12),
              const InstructionCard(
                number: '3',
                teksInstruksi:
                    'Setelah melakukan transfer, silahkan unggah bukti pembayaran sebagai konfirmasi.',
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Unggah Bukti Pembayaran",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.outlineVariant,
                    )),
              ),
              UploadFileCard(
                onTap: _pickFile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
