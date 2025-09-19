import 'package:flutter/material.dart';
import 'package:guardian_app/core/actions/bill_action.dart';
import 'package:guardian_app/core/actions/student_action.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/providers/bill_provider.dart';
import 'package:guardian_app/core/providers/student_provider.dart';
import 'package:guardian_app/core/utils/number_format.dart';
import 'package:guardian_app/data/models/bill.dart';
import 'package:guardian_app/data/models/mode_of_payment.dart';
import 'package:guardian_app/data/models/student.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/bottom_bar.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/instruction_card.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/payment_steps.dart';
import 'package:guardian_app/presentation/pembayaran/widgets/due_card_small.dart';
import 'package:guardian_app/widgets/search_card.dart';
import 'package:guardian_app/widgets/dropdown_card.dart';
import 'package:guardian_app/presentation/pilihanak/pilihanak.dart';
import 'package:provider/provider.dart';

class BayarSatuScreen extends StatefulWidget {
  const BayarSatuScreen({super.key});
  @override
  _BayarSatuState createState() => _BayarSatuState();
}

class _BayarSatuState extends State<BayarSatuScreen> {
  final TextEditingController _searchController = TextEditingController();
  Student? selectedChild;
  List<Student> _students = [];
  List<Bill> bills = [];
  List<Bill> filteredBills = [];
  List<Bill> selectedBills = [];
  int totalAmount = 0;

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

  final Set<int> _selectedItemIds = {};

  @override
  void initState() {
    super.initState();
    fetchTuitionPlan();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _calculateTotal() {
    int total = 0;
    for (var item in selectedBills) {
      if (selectedBills.contains(item)) {
        total += item.amount.toInt();
      }
    }
    return total;
  }

  void fetchTuitionPlan() async {
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    final billProvider = Provider.of<BillProvider>(context, listen: false);
    _students =
        StudentAction.getStudentNoAcademicYear(studentProvider.students);
    selectedChild = studentProvider.selectedStudent;

    final results = await Future.wait<dynamic>([
      BillAction.getBillAndMethod(
        selectedChild?.name ?? '',
        selectedChild?.academicYear ?? '',
      ),
    ]);

    print('results: $results');
    final bills = results[0]["bills"] as List<Bill>;
    final methods = results[0]["methods"] as List<ModeOfPayment>;

    await billProvider.saveBill(bills);
    await billProvider.saveModeOfPayment(methods);

    setState(() {
      filteredBills = bills;
    });
  }

  void filterBills(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredBills = bills;
      } else {
        filteredBills = bills.where((child) {
          final remark = child.remark.toLowerCase();
          final academicYear = child.academicYear.toLowerCase();

          return remark.contains(query) || academicYear.contains(query);
        }).toList();
      }
    });
  }

  void selectedBill(Bill bill) {
    setState(() {
      if (selectedBills.contains(bill)) {
        selectedBills.remove(bill);
      } else {
        selectedBills.add(bill);
      }
      totalAmount = _calculateTotal();
    });
  }

  void onNextStage() {
    if (totalAmount > 0) {
      final billProvider = Provider.of<BillProvider>(context, listen: false);
      billProvider.saveSelectedBill(selectedBills);

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
  }

  @override
  Widget build(BuildContext context) {
    final int totalAmount = _calculateTotal();

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
                    const SizedBox(height: 12.0),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: theme.colorScheme.surface,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Student>(
                          isExpanded: true,
                          value: selectedChild,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: theme.colorScheme.primary,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                          items: _students.map((student) {
                            return DropdownMenuItem<Student>(
                              value: student,
                              child: Text(student.fullName),
                            );
                          }).toList(),
                          onChanged: (dynamic newValue) {
                            setState(() {
                              selectedChild = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SearchCard(controller: _searchController),
                    // Card untuk menampilkan daftar tagihan
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredBills.length,
                      itemBuilder: (context, index) {
                        final item = filteredBills[index];
                        final dueDate = DateTime.parse(item.dueDate);
                        final today = DateTime.now();

                        final isOverdue = dueDate.isBefore(
                            DateTime(today.year, today.month, today.day));
                        return DueCard(
                          isOverdue: isOverdue,
                          harga: numberFormat('rp_fixed', item.amount),
                          deskripsi: item.remark,
                          isSelected: selectedBills.contains(item),
                          onTap: () => {
                            selectedBill(item),
                          },
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
        title:
            "Total ${selectedBills.isNotEmpty ? selectedBills.length : ''} Tagihan",
        isNeeded: true,
        totalAmount: totalAmount,
        onContinuePressed: onNextStage,
      ),
    );
  }
}
