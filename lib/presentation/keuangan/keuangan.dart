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
import 'package:intl/intl.dart';
import 'dart:convert';

// Pastikan path import ini sesuai dengan struktur proyek Anda
import 'package:guardian_app/data/api/payment.dart';
import 'package:guardian_app/data/models/payment.dart';

class KeuanganScreen extends StatefulWidget {
  const KeuanganScreen({Key? key}) : super(key: key);

  @override
  KeuanganPageScreen createState() => KeuanganPageScreen();
}

class KeuanganPageScreen extends State<KeuanganScreen> {
  late Future<List<Payment>> _paymentsFuture;
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

  Future<List<Payment>> _fetchData() async {
    // TODO: Update
    const studentId = 'TLAB.0001';
    const academicYear = '2025 / 2026';

    final responseData = await getJadwalBayar(
      studentId: studentId,
      academicYear: academicYear,
    );

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    debugPrint('Raw API Response:\n${encoder.convert(responseData)}');

    // Cek struktur JSON: response -> 'message' (Map) -> 'lists' (List)
    if (responseData != null &&
        responseData['message'] is Map &&
        responseData['message']['lists'] is List) {
      // Akses list pembayaran dari dalam 'message' menggunakan 'lists'
      final List<dynamic> dataList = responseData['message']['lists'];

      final List<Payment> payments =
          dataList.map((json) => Payment.fromJson(json)).toList();

      // Cek apakah widget masih ada di tree sebelum memanggil setState untuk menghindari error
      if (mounted) {
        setState(() {
          _allPayments = payments;
          _filteredPayments = payments;
        });
      }

      return payments;
    } else {
      // Jika pemanggilan API gagal atau data format salah.
      String serverError =
          'Gagal memuat jadwal. Format data dari server tidak sesuai.'; //Default error.

      if (responseData != null) {
        // Pesan error spesifik dari server
        if (responseData.containsKey('_server_messages')) {
          try {
            final serverMessages = responseData['_server_messages'] as List;
            if (serverMessages.isNotEmpty) {
              final messageJson = jsonDecode(serverMessages.first);
              serverError = messageJson['message'] ?? serverError;
            }
          } catch (e) {
            // Jika parsing gagal.
            serverError = responseData['_server_messages'].toString();
          }
        } else if (responseData.containsKey('exception')) {
          serverError = responseData['exception'].toString();
        }
      } else {
        // Jika responseData == null.
        serverError =
            'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
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
        final bool matchesStatus = statusFilter == KeuanganFilterStatus.semua ||
            (statusFilter == KeuanganFilterStatus.lunas &&
                payment.status == 'Lunas') ||
            (statusFilter == KeuanganFilterStatus.belumLunas &&
                payment.status == 'Belum Lunas') ||
            (statusFilter == KeuanganFilterStatus.tenggat && payment.isOverdue);
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

  String _formatDateManual(DateTime date) {
    return '${date.day} ${_bulanIndonesia[date.month - 1]} ${date.year}';
  }

  String _formatCurrency(double amount) {
    final format =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
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
        body: Column(
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
              onActionTap: (selectedValue) => _showFilterPopup(),
              onFilterChanged: (onFilter, selectedValue) {},
            ),
            Expanded(
              child: FutureBuilder<List<Payment>>(
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
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
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
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                              _buildPaymentSummary(snapshot.data!),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: AdCard(
                                  teks: 'In the lessons we learn new words...',
                                ),
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

  Widget _buildPaymentSummary(List<Payment> payments) {
    // outstanding > 0 berarti Belum Lunas
    double totalKewajiban = payments
        .where((p) => p.status == 'Belum Lunas')
        .fold(0, (sum, item) => sum + item.amount);

    double totalTunggakan = payments
        .where((p) => p.isOverdue)
        .fold(0, (sum, item) => sum + item.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Pembayaran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                label: 'Total Kewajiban',
                value: _formatCurrency(totalKewajiban),
                valueColor: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryCard(
                label: 'Total Tunggakan',
                value: _formatCurrency(totalTunggakan),
                valueColor: theme.colorScheme.error,
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
        Text(
          'Jadwal Pembayaran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        if (_filteredPayments.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Tidak ada jadwal pembayaran yang cocok dengan filter.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
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

  void _navigateToPayScreen() {
    Navigator.pushNamed(context, AppRoutes.bayarSatuScreen);
  }

  void _navigateToPaymentDetail(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.paymentDetailPage);
  }
}
