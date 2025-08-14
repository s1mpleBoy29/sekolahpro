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

class KeuanganScreen extends StatefulWidget {
  const KeuanganScreen({Key? key}) : super(key: key);

  @override
  KeuanganPageScreen createState() => KeuanganPageScreen();
}

class KeuanganPageScreen extends State<KeuanganScreen> {
  late String filterArea = 'smpn_13_malang';

  Future<void> onRefresh() async {}

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(1),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.94,
          child: FilterPopup(),
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
              // SecondaryTopbar untuk Keuangan
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
                            // Mengganti _buildAdSection() dengan AdCard
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: const AdCard(
                                teks:
                                    'In the lessns we leran new words and r for vacalaburities continues and article',
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
        // Wrap PaymentScheduleCard dengan GestureDetector untuk menambahkan onTap
        GestureDetector(
          onTap: () => _navigateToPaymentDetail(context),
          child: const PaymentScheduleCard(
            dueDate: '10 Agustus 2025',
            amount: 'Rp 300.000',
            description:
                'Uang Sekolah Candra Bulan Agustus Tahun Ajaran 2025 / 2026',
            status: 'Belum Lunas',
            statusColor: Colors.grey,
            isOverdue: false,
          ),
        ),
        GestureDetector(
          onTap: () => _navigateToPaymentDetail(context),
          child: const PaymentScheduleCard(
            dueDate: '30 Juli 2025',
            amount: 'Rp 1.200.000',
            description: 'Uang Seragam Candra Tahun Ajaran 2025 / 2026',
            status: 'Lunas',
            statusColor: Colors.green,
            isOverdue: false,
          ),
        ),
        GestureDetector(
          onTap: () => _navigateToPaymentDetail(context),
          child: const PaymentScheduleCard(
            amount: 'Rp 300.000',
            description:
                'Uang Sekolah Candra Bulan Juli Tahun Ajaran 2025 / 2026',
            status: 'Belum Lunas',
            statusColor: Colors.grey,
            isOverdue: true,
          ),
        ),
      ],
    );
  }

  // Method untuk navigasi ke halaman detail pembayaran
  void _navigateToPaymentDetail(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.paymentDetailPage); // Ganti dengan rute yang sesuai
  }
}