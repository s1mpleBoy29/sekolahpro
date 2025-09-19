import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/providers/bill_provider.dart';
import 'package:guardian_app/core/providers/student_provider.dart';
import 'package:guardian_app/data/api/payment.dart';
import 'package:guardian_app/data/models/student.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/payment_steps.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/instruction_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/bottom_bar.dart';
import 'package:guardian_app/widgets/custom_dialog.dart';
import 'package:guardian_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class BayarTigaScreen extends StatefulWidget {
  const BayarTigaScreen({super.key});

  @override
  State<BayarTigaScreen> createState() => _BayarTigaScreenState();
}

class _BayarTigaScreenState extends State<BayarTigaScreen> {
  late TextEditingController _descriptionController;
  // File? _selectedFile;
  String? _fileName;

  Student? selectedChild;

  PlatformFile? _selectedFile;

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

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  makePayment() async {
    try {
      final studentProvider =
          Provider.of<StudentProvider>(context, listen: false);
      final billProvider = Provider.of<BillProvider>(context, listen: false);

      List<dynamic> bill = billProvider.selectedBills.map((e) {
        return {
          "name": e.plan,
          "remark": e.remark,
          "amount": e.amount,
        };
      }).toList();

      selectedChild = studentProvider.selectedStudent;
      final payment = PaymentService();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CustomDialog(
          title: "Memproses",
          message: "Mohon tunggu, pembayaran sedang diproses...",
          icon: Icons.hourglass_bottom,
          iconColor: theme.colorScheme.primary,
          isLoading: true,
        ),
      );

      final makePayment = await payment.makePayment(
        student: selectedChild!.name,
        tuitionPlans: bill,
        methodOfPayment: billProvider.selectedModeOfPayment!.name,
        filePath: _selectedFile?.path,
      );

      if (kDebugMode) {
        print("DEBUG: loginResponse = $makePayment");
      }

      if (makePayment.isEmpty || makePayment['message'] == null) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: "Pembayaran Gagal",
            message:
                "Silahkan coba lagi. ${makePayment['exception'] ?? 'Unknown error'}",
            icon: Icons.check_circle_rounded,
            iconColor: theme.colorScheme.error,
            actions: [
              DialogAction(
                label: "OK",
                onPressed: () => Navigator.pop(context),
                backgroundColor: theme.colorScheme.primary,
                textColor: theme.colorScheme.surface,
              ),
            ],
          ),
        );
        // Gagal
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       'Payment failed: ${makePayment['exception'] ?? 'Unknown error'}',
        //     ),
        //     backgroundColor: appTheme.red,
        //   ),
        // );
        return;
      }

      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: "Pembayaran Berhasil",
          message: "Terima kasih, pembayaran Anda sudah kami terima.",
          icon: Icons.check_circle_rounded,
          iconColor: appTheme.green600,
          actions: [
            DialogAction(
              label: "OK",
              onPressed: () => onSuccess(),
              backgroundColor: theme.colorScheme.primary,
              textColor: theme.colorScheme.surface,
            ),
          ],
        ),
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       'Payment success!\nNo: $receiptNo\nMethod: $method\nAmount: Rp $amount',
      //     ),
      //     backgroundColor: appTheme.green600,
      //   ),
      // );
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: "Pembayaran Gagal",
          message: "Error occurred: $e",
          icon: Icons.check_circle_rounded,
          iconColor: appTheme.green600,
          actions: [
            DialogAction(
              label: "OK",
              onPressed: () => Navigator.pop(context),
              backgroundColor: theme.colorScheme.primary,
              textColor: theme.colorScheme.surface,
            ),
          ],
        ),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error: $e'),
      //     backgroundColor: appTheme.red,
      //   ),
      // );
    }
  }

  void onNextStage() async {
    await makePayment();
  }

  void onSuccess() {
    Navigator.pop(context);
    Navigator.of(context, rootNavigator: true)
        .pushReplacementNamed(AppRoutes.homeScreen);
  }

  Widget buildFilePreview() {
    if (_selectedFile == null) {
      return GestureDetector(
        onTap: _pickFile,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(4),
            color: theme.colorScheme.surface,
          ),
          child: Center(
            child: Text(
              "Pilih Bukti Pembayaran",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ),
      );
    }

    if (_selectedFile!.extension == 'jpg' ||
        _selectedFile!.extension == 'jpeg' ||
        _selectedFile!.extension == 'png') {
      return GestureDetector(
        onTap: _pickFile,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.file(
            File(_selectedFile!.path!),
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (_selectedFile!.extension == 'pdf') {
      return GestureDetector(
        onTap: _pickFile,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(4),
            color: theme.colorScheme.surface,
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf, size: 32, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedFile!.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.edit, color: Colors.blue),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
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
              // UploadFileCard(
              //   onTap: _pickFile,
              // ),
              // const SizedBox(height: 18),
              buildFilePreview(),
              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Keterangan Tambahan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      " (Opsional)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              _inputDescription(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        isNeeded: false,
        totalAmount:
            1, // TotalAmount tidak digunakan di sini, nilai 1 hanya example
        onContinuePressed: onNextStage,
      ),
    );
  }

  TextEditingController descriptionController = TextEditingController();
  FocusNode descriptionFocus = FocusNode();
  Widget _inputDescription(BuildContext context) {
    return CustomTextFormField(
      autofocus: false,
      focusNode: descriptionFocus,
      maxLines: 4,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      borderDecoration: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: appTheme.gray300,
          width: 0,
        ),
      ),
      fillColor: theme.colorScheme.surface,
      textStyle: TextStyle(
        color: theme.colorScheme.onPrimaryContainer,
      ),
      controller: descriptionController,
      hintText: "Keterangan",
    );
  }
}
