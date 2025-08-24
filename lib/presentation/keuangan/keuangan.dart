import 'package:flutter/material.dart';
import 'package:guardian_app/presentation/keuangan/widgets/paymentschedule_card.dart';
import 'package:guardian_app/presentation/keuangan/widgets/summarycard.dart';
import 'package:guardian_app/presentation/keuangan/widgets/totalpayment.dart';
import 'package:guardian_app/routes/app_routes.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:guardian_app/theme/app_decoration.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/ad_card.dart';
import 'package:guardian_app/widgets/topbar.dart';
import 'package:guardian_app/widgets/secondary_topbar.dart';
import 'package:guardian_app/widgets/filterpopup.dart';
import 'package:guardian_app/presentation/pilihanak/pilihanak.dart';

// Data dummy untuk Jadwal Pembayaran
final List<Map<String, dynamic>> _allPayments = [
  {
    "description": 'Uang Sekolah Candra Bulan Agustus Tahun Ajaran 2025 / 2026',
    "amount": 'Rp 300.000',
    "status": 'Belum Lunas',
    "statusColor": Colors.grey,
    "isOverdue": false,
    "dueDate": DateTime.parse("2025-08-10"),
  },
  {
    "description": 'Uang Seragam Candra Tahun Ajaran 2025 / 2026',
    "amount": 'Rp 1.200.000',
    "status": 'Lunas',
    "statusColor": Colors.green,
    "isOverdue": false,
    "dueDate": DateTime.parse("2025-07-30"),
  },
  {
    "description": 'Uang Sekolah Candra Bulan Juli Tahun Ajaran 2025 / 2026',
    "amount": 'Rp 300.000',
    "status": 'Belum Lunas',
    "statusColor": Colors.red,
    "isOverdue": true,
    "dueDate": DateTime.parse("2025-07-01"),
  },
  {
    "description": 'Uang Pembangunan Gedung Baru',
    "amount": 'Rp 500.000',
    "status": 'Lunas',
    "statusColor": Colors.green,
    "isOverdue": false,
    "dueDate": DateTime.parse("2025-06-15"),
  },
  {
    "description": 'Uang Kegiatan Ekstrakurikuler',
    "amount": 'Rp 150.000',
    "status": 'Belum Lunas',
    "statusColor": Colors.grey,
    "isOverdue": false,
    "dueDate": DateTime.parse("2025-09-01"),
  },
];

class KeuanganScreen extends StatefulWidget {
  const KeuanganScreen({Key? key}) : super(key: key);

  @override
  KeuanganPageScreen createState() => KeuanganPageScreen();
}

class KeuanganPageScreen extends State<KeuanganScreen> {
  late String filterArea = 'smpn_13_malang';
  List<Map<String, dynamic>> _filteredPayments = [];
  final List<String> _bulanIndonesia = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    _filteredPayments = _allPayments;
  }

  Future<void> onRefresh() async {
    setState(() {
      _filteredPayments = _allPayments;
    });
  }

  void _applyPaymentFilter(Map<String, dynamic> filters) {
    setState(() {
      _filteredPayments = _allPayments.where((payment) {
        final statusFilter = filters['status_pembayaran'] as KeuanganFilterStatus;
        final bool matchesStatus = statusFilter == KeuanganFilterStatus.semua ||
            (statusFilter == KeuanganFilterStatus.lunas && payment['status'] == 'Lunas') ||
            (statusFilter == KeuanganFilterStatus.belumLunas && payment['status'] == 'Belum Lunas') ||
            (statusFilter == KeuanganFilterStatus.tenggat && payment['isOverdue'] == true);
        
        return matchesStatus;
      }).toList();
    });
  }

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return FilterPopup(
          currentPage: FilterPage.keuangan,
          onApplyFilter: _applyPaymentFilter,
        );
      },
    );
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

  // Metode untuk memformat tanggal secara manual
  String _formatDateManual(DateTime date) {
    String day = date.day.toString();
    String month = _bulanIndonesia[date.month - 1];
    String year = date.year.toString();
    return '$day $month $year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        selected: AppRoutes.keuanganScreen,
        context: context,
        theme: theme,
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.bayarSatuScreen);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
          ),
          child: Column(
            children: [
              StickyTopBar(
                backgroundColor: theme.colorScheme.onPrimary,
                lineColor: appTheme.gray300,
                textColor: appTheme.gray600,
                titleFontSize: 22.0,
                titleFontFamily: 'Urbanist',
                subtitleFontSize: 12.0,
                subtitleFontFamily: 'Lato',
                titleText: 'Candra Wijaya',
                subtitleText: 'SDN 13 Malang | Kelas 5',
                onTitleTap: _navigateToAnakScreen,
              ),
              SecondaryTopbar(
                backgroundColor: theme.colorScheme.secondary,
                lineColor: appTheme.gray300,
                title: 'Keuangan',
                titleColor: Colors.white,
                slot: [],
                onActionTap: (selectedValue) {
                  _showFilterPopup();
                },
                onFilterChanged: (onFilter, selectedValue) {
                  if (onFilter == "area") {
                    setState(() {
                      filterArea = selectedValue;
                    });
                  }
                },
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: SingleChildScrollView(
                    primary: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      color: const Color(0xFFF0F2F5),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPaymentSummary(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: const AdCard(
                                teks: 'In the lessns we leran new words and r for vacalaburities continues and article',
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildPaymentSchedule(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Pembayaran',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(
              child: SummaryCard(
                label: 'Total Kewajiban',
                value: 'Rp 1.800.000',
                valueColor: Colors.black,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: SummaryCard(
                label: 'Total Tunggakan',
                value: 'Rp 300.000',
                valueColor: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const TotalPaymentCard(),
      ],
    );
  }

  Widget _buildPaymentSchedule(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jadwal Pembayaran',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        if (_filteredPayments.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Tidak ada jadwal pembayaran yang ditemukan.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          )
        else
          ..._filteredPayments.map((payment) {
            final DateTime? dueDate = payment['dueDate'];
            String? dueDateString;
            if (dueDate != null) {
              dueDateString = _formatDateManual(dueDate);
            }

            return GestureDetector(
              onTap: () => _navigateToPaymentDetail(context),
              child: PaymentScheduleCard(
                dueDate: dueDateString,
                amount: payment['amount'],
                description: payment['description'],
                status: payment['status'],
                statusColor: payment['statusColor'],
                isOverdue: payment['isOverdue'],
              ),
            );
          }).toList(),
      ],
    );
  }

  void _navigateToPaymentDetail(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.paymentDetailPage);
  }
}