import 'package:flutter/material.dart';
import 'package:guardian_app/core/providers/student_provider.dart';
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
import 'package:guardian_app/presentation/keuangan/widgets/filterpopup.dart';
import 'package:guardian_app/presentation/pilihanak/pilihanak.dart';
import 'package:intl/intl.dart';
import 'package:guardian_app/data/api/payment.dart';
import 'package:guardian_app/data/models/payment.dart';
import 'package:guardian_app/data/api/ad.dart';
import 'package:guardian_app/data/models/ad.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:guardian_app/data/models/student.dart';

class KeuanganScreen extends StatefulWidget {
  const KeuanganScreen({Key? key}) : super(key: key);

  @override
  KeuanganPageScreen createState() => KeuanganPageScreen();
}

class KeuanganPageScreen extends State<KeuanganScreen> {
  bool _isInitialLoading = true;
  bool _isPageLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;
  Map<String, dynamic> _activeFilters = {};

  List<Payment> _allPayments = [];
  List<Payment> _filteredPayments = [];
  PaymentSummary? _summary;
  Student? _lastProcessedStudent;

  // Ads
  List<Ad> _adList = [];
  int _currentAdIndex = 0;
  Timer? _adTimer;
  // ends Ads

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
    _fetchAndStartAds();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final studentProvider = Provider.of<StudentProvider>(context);
    final selectedStudent = studentProvider.selectedStudent;

    if (_lastProcessedStudent != selectedStudent) {
      _lastProcessedStudent = selectedStudent;
      print('Selected student changed: ${selectedStudent?.name}');
      print('Academic Year: ${selectedStudent?.academicYearName}');

      setState(() {
        _allPayments.clear();
        _filteredPayments.clear();
        _summary = null;
        _currentPage = 1;
        _activeFilters = {};
        _isInitialLoading = true;
        _error = null;
      });

      if (selectedStudent != null) {
        _fetchAndSetPage(
          1,
          studentId: selectedStudent.name,
          academicYear: selectedStudent.academicYear,
        );
      } else {
        setState(() {
          _isInitialLoading = false;
          _error =
              'Silakan pilih anak terlebih dahulu untuk melihat data keuangan.';
        });
      }
    }
  }

  void _fetchAndStartAds() async {
    final ads = await getAds();
    if (mounted && ads != null && ads.isNotEmpty) {
      setState(() {
        _adList = ads;
      });
      if (ads.length > 1) {
        _startAdTimer();
      }
    }
  }

  void _startAdTimer() {
    _adTimer?.cancel();
    _adTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentAdIndex = (_currentAdIndex + 1) % _adList.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    super.dispose();
  }

  void _nextPage() {
    final student =
        Provider.of<StudentProvider>(context, listen: false).selectedStudent;
    if (student != null && _hasMore && !_isPageLoading) {
      setState(() {
        _currentPage++;
        _activeFilters = {};
      });
      _fetchAndSetPage(
        _currentPage,
        studentId: student.name,
        academicYear: student.academicYear,
      );
    }
  }

  void _previousPage() {
    final student =
        Provider.of<StudentProvider>(context, listen: false).selectedStudent;
    if (student != null && _currentPage > 1 && !_isPageLoading) {
      setState(() {
        _currentPage--;
        _activeFilters = {};
      });
      _fetchAndSetPage(
        _currentPage,
        studentId: student.name,
        academicYear: student.academicYear,
      );
    }
  }

  Future<void> _fetchAndSetPage(int page,
      {required String studentId, required String academicYear}) async {
    setState(() {
      if (page == 1) _isInitialLoading = true;
      _isPageLoading = true;
      _error = null;
    });

    const limit = 10;
    final payment = PaymentService();

    try {
      final responseData = await payment.getJadwalBayar(
        studentId: studentId,
        academicYear: academicYear,
        page: page,
        limit: limit,
      );

      if (mounted && responseData != null && responseData['message'] is Map) {
        final List<dynamic> dataList = responseData['message']['lists'] ?? [];
        final newPayments =
            dataList.map((json) => Payment.fromJson(json)).toList();

        setState(() {
          _allPayments = newPayments;
          _applyClientSideFilters();
          _hasMore = newPayments.length == limit;

          if (page == 1 && responseData['message']['stat'] is Map) {
            _summary = PaymentSummary.fromJson(responseData['message']['stat']);
          }
        });
      } else {
        throw Exception('Gagal memuat jadwal pembayaran.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _isPageLoading = false;
        });
      }
    }
  }

  Future<void> onRefresh() async {
    setState(() {
      _currentPage = 1;
      _activeFilters = {};
    });

    final student =
        Provider.of<StudentProvider>(context, listen: false).selectedStudent;
    if (student != null) {
      await _fetchAndSetPage(
        1,
        studentId: student.name,
        academicYear: student.academicYear,
      );
    }
  }

  void _applyPaymentFilter(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
      _applyClientSideFilters();
    });
  }

  void _applyClientSideFilters() {
    final statusFilter =
        _activeFilters['status_pembayaran'] as KeuanganFilterStatus? ??
            KeuanganFilterStatus.semua;
    final searchTerm =
        (_activeFilters['search_term'] as String? ?? '').toLowerCase();

    _filteredPayments = _allPayments.where((payment) {
      final bool statusMatch = statusFilter == KeuanganFilterStatus.semua ||
          (statusFilter == KeuanganFilterStatus.lunas &&
              payment.status == 'Lunas') ||
          (statusFilter == KeuanganFilterStatus.belumLunas &&
              payment.status == 'Belum Lunas') ||
          (statusFilter == KeuanganFilterStatus.tenggat && payment.isOverdue);
      final bool searchMatch = searchTerm.isEmpty ||
          payment.description.toLowerCase().contains(searchTerm);
      return statusMatch && searchMatch;
    }).toList();
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
            Consumer<StudentProvider>(
              builder: (context, studentProvider, _) {
                return StickyTopBar(
                  backgroundColor: theme.colorScheme.onPrimary,
                  lineColor: appTheme.gray300,
                  textColor: appTheme.gray600,
                  titleFontSize: 22.0,
                  titleFontFamily: 'Urbanist',
                  subtitleFontSize: 12.0,
                  subtitleFontFamily: 'Lato',
                  titleText:
                      studentProvider.selectedStudent?.fullName ?? 'Pilih Anak',
                  subtitleText:
                      '${studentProvider.selectedStudent?.schoolName ?? '-'} | ${studentProvider.selectedStudent?.gradeName ?? '-'}',
                  onTitleTap: _navigateToAnakScreen,
                );
              },
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
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.error)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRefresh,
                child: const Text('Coba Lagi',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              )
            ],
          ),
        ),
      );
    }
    if (_summary == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Tidak ada data pembayaran ditemukan.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRefresh,
                child: const Text('Muat Ulang',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              )
            ],
          ),
        ),
      );
    }

    final bool hasAd = _adList.isNotEmpty;
    final int headerCount = 2 + (hasAd ? 1 : 0);
    final bool hasPayments = _filteredPayments.isNotEmpty;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: onRefresh,
          child: Container(
            color: const Color(0xFFF0F2F5),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: headerCount +
                  (_filteredPayments.isNotEmpty
                      ? _filteredPayments.length
                      : 1) +
                  1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildPaymentSummary(_summary!);
                }

                if (hasAd && index == 1) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: AdCard(ad: _adList[_currentAdIndex]),
                  );
                }

                final titleIndex = 1 + (hasAd ? 1 : 0);
                if (index == titleIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text('Jadwal Pembayaran',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface)),
                  );
                }

                final paymentIndex = index - headerCount;

                if (!hasPayments) {
                  if (paymentIndex == 0) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Tidak ada jadwal pembayaran yang cocok dengan filter.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                } else if (paymentIndex < _filteredPayments.length) {
                  final payment = _filteredPayments[paymentIndex];
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
                }

                return _buildPaginationControls();
              },
            ),
          ),
        ),
        if (_isPageLoading)
          Container(
            color: Colors.black.withOpacity(0.1),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildPaginationControls() {
    final statusFilter =
        _activeFilters['status_pembayaran'] as KeuanganFilterStatus? ??
            KeuanganFilterStatus.semua;
    final searchTerm = _activeFilters['search_term'] as String? ?? '';

    if (statusFilter != KeuanganFilterStatus.semua || searchTerm.isNotEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _currentPage > 1 ? _previousPage : null,
            color: theme.colorScheme.primary,
          ),
          Text(
            '$_currentPage',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _hasMore ? _nextPage : null,
            color: theme.colorScheme.primary,
          ),
        ],
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

  void _navigateToPayScreen() =>
      Navigator.pushNamed(context, AppRoutes.bayarSatuScreen);
  void _navigateToPaymentDetail(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.paymentDetailPage);
}
