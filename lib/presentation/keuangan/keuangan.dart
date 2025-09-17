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
import 'package:guardian_app/presentation/keuangan/widgets/filterpopup.dart';
import 'package:guardian_app/presentation/pilihanak/pilihanak.dart';
import 'package:intl/intl.dart';
import 'package:guardian_app/data/api/payment.dart';
import 'package:guardian_app/data/models/payment.dart';
import 'package:guardian_app/data/api/ad.dart';
import 'package:guardian_app/data/models/ad.dart';
import 'dart:async';

class KeuanganScreen extends StatefulWidget {
  const KeuanganScreen({Key? key}) : super(key: key);

  @override
  KeuanganPageScreen createState() => KeuanganPageScreen();
}

class KeuanganPageScreen extends State<KeuanganScreen> {
  // State variables for pagination and filtering
  bool _isInitialLoading = true;
  bool _isPageLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;
  Map<String, dynamic> _activeFilters = {};

  // Data holding variables
  List<Payment> _allPayments = [];
  List<Payment> _filteredPayments = [];
  PaymentSummary? _summary;

  // Ads
  List<Ad> _adList = [];
  int _currentAdIndex = 0;
  Timer? _adTimer;

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
    _fetchAndSetPage(1);
    _fetchAndStartAds();
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
      setState(() {
        _currentAdIndex = (_currentAdIndex + 1) % _adList.length;
      });
    });
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    super.dispose();
  }

  void _nextPage() {
    if (_hasMore && !_isPageLoading) {
      setState(() {
        _currentPage++;
        _activeFilters = {}; // Clear filters when changing page
      });
      _fetchAndSetPage(_currentPage);
    }
  }

  void _previousPage() {
    if (_currentPage > 1 && !_isPageLoading) {
      setState(() {
        _currentPage--;
        _activeFilters = {}; // Clear filters when changing page
      });
      _fetchAndSetPage(_currentPage);
    }
  }

  // MODIFIED: This function no longer sends search terms to the server
  Future<void> _fetchAndSetPage(int page) async {
    setState(() {
      if (page == 1) _isInitialLoading = true;
      _isPageLoading = true;
      _error = null;
    });

    const studentId = 'TLAB.0001';
    const academicYear = '2025 / 2026';
    const limit = 10;

    try {
      final responseData = await getJadwalBayar(
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
          // Apply any existing client-side filters to the new data
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
      if (mounted)
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted)
        setState(() {
          _isInitialLoading = false;
          _isPageLoading = false;
        });
    }
  }

  Future<void> onRefresh() async {
    setState(() {
      _currentPage = 1;
      _activeFilters = {};
    });
    await _fetchAndSetPage(1);
  }

  // MODIFIED: This function now only applies filters on the client-side
  void _applyPaymentFilter(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
      _applyClientSideFilters();
    });
  }

  // MODIFIED: This function now handles BOTH search and status filtering
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
            StickyTopBar(
              backgroundColor: theme.colorScheme.onPrimary,
              lineColor: appTheme.gray300,
              textColor: appTheme.gray600,
              titleFontSize: 22.0,
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
      return const Center(child: Text('Tidak ada data pembayaran ditemukan.'));
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
              itemCount: headerCount + _filteredPayments.length + 1,
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
                if (paymentIndex < _filteredPayments.length) {
                  final payment = _filteredPayments[paymentIndex];
                  return GestureDetector(
                    // Add this widget
                    onTap: () => _navigateToPaymentDetail(
                        context), // Add this line to handle the tap
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

                if (!hasPayments) {
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
    // MODIFIED: Pagination is hidden if ANY filter is active.
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _currentPage > 1 ? _previousPage : null,
            color: theme.colorScheme.primary,
          ),
          Text(
            'Halaman $_currentPage',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
