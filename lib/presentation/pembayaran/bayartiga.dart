import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/payment_steps.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/instruction_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/bottom_bar.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/upload_file.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/deskripsi_opsional.dart';

class BayarTigaScreen extends StatefulWidget {
  const BayarTigaScreen({super.key});

  @override
  State<BayarTigaScreen> createState() => _BayarTigaScreenState();
}

class _BayarTigaScreenState extends State<BayarTigaScreen> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

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
                      color: theme.colorScheme.onPrimaryContainer,
                    )),
              ),
              UploadFileCard(
                onTap: _pickFile,
              ),
              const SizedBox(height: 18),
              DeskripsiOpsional(
                controller: _descriptionController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
          isNeeded: false,
          totalAmount:
              1, // TotalAmount tidak digunakan di sini, nilai 1 hanya example
          onContinuePressed: () {
            print('Lanjutkan ditekan, lanjut ke Keuangan');
            Navigator.pushNamed(context,
                AppRoutes.agendaScreen); //Ganti dengan rute yang sesuai
          }),
    );
  }
}
