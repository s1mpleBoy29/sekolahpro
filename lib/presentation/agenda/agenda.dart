import 'package:flutter/material.dart';
import 'package:guardian_app/core/providers/student_provider.dart';
import 'package:guardian_app/data/api/Agenda.dart';
import 'package:guardian_app/data/models/Agenda.dart';
import 'package:guardian_app/widgets/filterpopup.dart';
import 'package:guardian_app/theme/app_decoration.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/secondary_topbar.dart';
import 'package:guardian_app/widgets/topbar.dart';
import 'package:guardian_app/routes/app_routes.dart';
import 'package:guardian_app/presentation/pilihanak/pilihanak.dart';
import 'package:intl/intl.dart';
import 'package:guardian_app/widgets/agenda_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guardian_app/widgets/ad_card.dart';
import 'package:guardian_app/data/api/ad.dart';
import 'package:guardian_app/data/models/ad.dart';
import 'dart:async';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  AgendaPageScreen createState() => AgendaPageScreen();
}

class AgendaPageScreen extends State<AgendaScreen> {
  late String filterArea = 'smpn_13_malang';
  List<AgendaDetail> _filteredAgendaList = [];
  bool _isLoading = true;
  String? _errorMessage;
  final String _currentStudentId = 'TLAB.0001'; // Contoh Student ID

  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 2;

  // Ads
  List<Ad> _adList = [];
  int _currentAdIndex = 0;
  Timer? _adTimer;

  // Add ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchAgendaList();
    _fetchAndStartAds();
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    _scrollController.dispose(); // Don't forget to dispose
    super.dispose();
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

  Future<void> _fetchAgendaList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final AgendaListResponse? response =
        await getAgendaList(studentId: _currentStudentId);

    if (response != null) {
      if (mounted) {
        setState(() {
          _filteredAgendaList = response.lists;
          _isLoading = false;
          _currentPage = 1; // reset ke halaman awal
        });
        // Scroll to top after loading data
        _scrollToTop();
      }
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sid = prefs.getString('sid');

      if (sid == null) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Gagal memuat agenda. Silakan coba refresh.';
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> onRefresh() async {
    await _fetchAgendaList();
  }

  void _applyAgendaFilter(Map<String, dynamic> filters) {
    setState(() {
      final List<AgendaDetail> filteredTemp =
          _filteredAgendaList.where((agenda) {
        final pengirimFilter = filters['pengirim'] as AgendaFilterPengirim;
        final bool matchesPengirim =
            pengirimFilter == AgendaFilterPengirim.semua ||
                (pengirimFilter == AgendaFilterPengirim.waliKelas5A &&
                    agenda.from == 'Wali Kelas 5A') ||
                (pengirimFilter == AgendaFilterPengirim.guruOlahraga &&
                    agenda.from == 'Guru Seni Budaya 5A') ||
                (pengirimFilter == AgendaFilterPengirim.adminSekolah &&
                    agenda.from == 'Admin Sekolah');

        final DateTime? startDate = filters['tanggal_mulai'];
        final DateTime? endDate = filters['tanggal_akhir'];
        final DateTime agendaDate = agenda.date;

        bool matchesDate = true;
        if (startDate != null && endDate != null) {
          matchesDate =
              agendaDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                  agendaDate.isBefore(endDate.add(const Duration(days: 1)));
        } else if (startDate != null) {
          matchesDate = DateUtils.isSameDay(agendaDate, startDate);
        }

        return matchesPengirim && matchesDate;
      }).toList();
      _filteredAgendaList = filteredTemp;
      _currentPage = 1; // reset ke halaman pertama setelah filter
    });
    // Scroll to top after applying filter
    _scrollToTop();
  }

  // Method to scroll to top smoothly
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return FilterPopup(
          currentPage: FilterPage.agenda,
          onApplyFilter: _applyAgendaFilter,
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

  // Ambil agenda sesuai halaman
  List<AgendaDetail> get _currentPageAgenda {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex =
        (_currentPage * _itemsPerPage).clamp(0, _filteredAgendaList.length);
    return _filteredAgendaList.sublist(startIndex, endIndex);
  }

  Widget _buildPaginationControls() {
    final totalPages = (_filteredAgendaList.length / _itemsPerPage).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                    // Scroll to top when changing page
                    _scrollToTop();
                  }
                : null,
          ),
          Text('Page $_currentPage of $totalPages'),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    // Scroll to top when changing page
                    _scrollToTop();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: BottomNavBar(
        selected: AppRoutes.agendaScreen,
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
              title: 'Agenda',
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
                child: _buildAgendaList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdCard() {
    if (_adList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: AdCard(ad: _adList[_currentAdIndex]),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildAgendaList() {
  if (_isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (_errorMessage != null) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 16),
            ),
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

  if (_filteredAgendaList.isEmpty) {
    return const Center(child: Text('Tidak ada agenda yang ditemukan.'));
  }

  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _currentPageAgenda.length + 1, // +1 untuk AdCard
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            if (index == 0) return _buildAdCard();

            final item = _currentPageAgenda[index - 1];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: AgendaCard(
                tanggal: DateFormat('d MMMM yyyy', 'id_ID').format(item.date),
                dari: item.from,
                untuk: item.to,
                detail: item.detail,
                agendaId: item.id, // Pass agenda ID
                onTap: () {
                  // Navigasi dengan parameter
                  Navigator.pushNamed(
                    context,
                    AppRoutes.DetailAgendaScreen,
                    arguments: {
                      'studentId': _currentStudentId,
                      'agendaId': item.id,
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      _buildPaginationControls(),
    ],
  );
}
}