import 'package:flutter/material.dart';
import 'package:guardian_app/presentation/keuangan/widgets/paymentschedule_card.dart';
import 'package:guardian_app/presentation/keuangan/widgets/summarycard.dart';
import 'package:guardian_app/presentation/keuangan/widgets/totalpayment.dart';
import 'package:guardian_app/routes/app_routes.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/ad_card.dart';
import 'package:guardian_app/widgets/topbar.dart';
import 'package:guardian_app/widgets/secondary_topbar.dart';
import 'package:guardian_app/widgets/filterpopup.dart';
import 'package:guardian_app/presentation/pilihanak/pilihanak.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:guardian_app/data/api/payment.dart';
import 'package:guardian_app/data/models/payment.dart';
import 'package:provider/provider.dart';
import 'package:guardian_app/core/providers/student_provider.dart';

class KeuanganScreen extends StatefulWidget {
  const KeuanganScreen({Key? key}) : super(key: key);

  @override
  KeuanganPageScreen createState() => KeuanganPageScreen();
}

class KeuanganPageScreen extends State<KeuanganScreen> {
  late Future<PaymentData> _paymentsFuture;
  List<Payment> _allPayments = [];
  List<Payment> _filteredPayments = [];

  final List<String> _bulanIndonesia = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  @override
  void initState() {
    super.initState();
    _paymentsFuture = _fetchData();
  }

  Future<PaymentData> _fetchData() async {
    const studentId = 'TLAB.0001'; // TODO: Update
    const academicYear = '2025 / 2026'; // TODO: Update

    final responseData = await getJadwalBayar(
      studentId: studentId,
      academicYear: academicYear,
    );

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    debugPrint('Raw API Response:\n${encoder.convert(responseData)}');

    if (responseData != null &&
        responseData['message'] is Map &&
        responseData['message']['lists'] is List &&
        responseData['message']['stat'] is Map) {
      final List<dynamic> dataList = responseData['message']['lists'];
      final Map<String, dynamic> statData = responseData['message']['stat'];

      final List<Payment> payments =
          dataList.map((json) => Payment.fromJson(json)).toList();
      final PaymentSummary summary = PaymentSummary.fromJson(statData);

      if (mounted) {
        setState(() {
          _allPayments = payments;
          _filteredPayments = payments;
        });
      }

      return PaymentData(payments: payments, summary: summary);
    } else {
      String serverError = 'Gagal memuat jadwal. Format data tidak sesuai.';
      if (responseData != null) {
        if (responseData.containsKey('_server_messages')) {
          try {
            final serverMessages = responseData['_server_messages'] as List;
            if (serverMessages.isNotEmpty) {
              final messageJson = jsonDecode(serverMessages.first);
              serverError = messageJson['message'] ?? serverError;
            }
          } catch (e) {
            serverError = responseData['_server_messages'].toString();
          }
        } else if (responseData.containsKey('exception')) {
          serverError = responseData['exception'].toString();
        }
      } else {
        serverError = 'Tidak dapat terhubung ke server.';
      }
      throw Exception(serverError);
    }
  }

  Future<void> onRefresh() async {
    setState(() {
      _paymentsFuture = _fetchData();
    });
  }

  void _applyPaymentFilter(Map<String, dynamic> filters) {
    setState(() {
      _filteredPayments = _allPayments.where((payment) {
        final statusFilter =
            filters['status_pembayaran'] as KeuanganFilterStatus;
        return statusFilter == KeuanganFilterStatus.semua ||
            (statusFilter == KeuanganFilterStatus.lunas &&
                payment.status == 'Lunas') ||
            (statusFilter == KeuanganFilterStatus.belumLunas &&
                payment.status == 'Belum Lunas') ||
            (statusFilter == KeuanganFilterStatus.tenggat && payment.isOverdue);
      }).toList();
    });
  }

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => FilterPopup(
          currentPage: FilterPage.keuangan, onApplyFilter: _applyPaymentFilter),
    );
  }

  void _navigateToAnakScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const PilihAnakScreen(
                postSelectionAction: PostSelectionAction.goBack)));
  }

  String _formatDateManual(DateTime date) =>
      '${date.day} ${_bulanIndonesia[date.month - 1]} ${date.year}';
  String _formatCurrency(double amount) =>
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
          .format(amount);

  @override
  Widget build(BuildContext context) {
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: BottomNavBar(
        selected: AppRoutes.keuanganScreen,
        context: context,
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.bayarSatuScreen);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Column(
          children: [
            StickyTopBar(
              backgroundColor: theme.colorScheme.onPrimary,
              lineColor: appTheme.gray300,
              textColor: appTheme.gray600,
              titleFontSize: 22.0,
              titleText: 'Candra Wijaya', // TODO: Update
              subtitleText: 'SDN 13 Malang | Kelas 5', // TODO: Update
              onTitleTap: _navigateToAnakScreen,
            ),
            SecondaryTopbar(
              backgroundColor: theme.colorScheme.secondary,
              lineColor: appTheme.gray300,
              title: 'Keuangan',
              titleColor: Colors.white,
              slot: [],
              onActionTap: (_) => _showFilterPopup(),
              onFilterChanged: (_, __) {},
            ),
            Expanded(
              child: FutureBuilder<PaymentData>(
                future: _paymentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                '${snapshot.error}'
                                    .replaceFirst('Exception: ', ''),
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: theme.colorScheme.error)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: onRefresh,
                              child: const Text('Coba Lagi',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data!.payments.isNotEmpty) {
                    final paymentData = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: onRefresh,
                      child: SingleChildScrollView(
                        primary: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          color: const Color(0xFFF0F2F5),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPaymentSummary(paymentData.summary),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: AdCard(
                                    teks:
                                        'In the lessons we learn new words...'),
                              ),
                              _buildPaymentSchedule(context),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                        child: Text('Tidak ada data pembayaran ditemukan.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary(PaymentSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ringkasan Pembayaran',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                label: 'Total Kewajiban',
                value: _formatCurrency(summary.totalKewajiban),
                valueColor: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryCard(
                label: 'Total Tunggakan',
                value: _formatCurrency(summary.totalTunggakan),
                valueColor: theme.colorScheme.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TotalPaymentCard(paidAmount: summary.totalPembayaran),
      ],
    );
  }

  Widget _buildPaymentSchedule(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jadwal Pembayaran',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface)),
        const SizedBox(height: 10),
        if (_filteredPayments.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                  'Tidak ada jadwal pembayaran yang cocok dengan filter.',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
          )
        else
          ..._filteredPayments.map((payment) {
            return GestureDetector(
              onTap: () => _navigateToPaymentDetail(context),
              child: PaymentScheduleCard(
                dueDate: _formatDateManual(payment.dueDate),
                amount: _formatCurrency(payment.amount),
                description: payment.description,
                status: payment.status,
                isOverdue: payment.isOverdue,
                onPayPressed: () => _navigateToPayScreen(),
              ),
            );
          }).toList(),
      ],
    );
  }

  void _navigateToPayScreen() =>
      Navigator.pushNamed(context, AppRoutes.bayarSatuScreen);
  void _navigateToPaymentDetail(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.paymentDetailPage);
}
