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
  List<AgendaDetail> _allAgendaList = []; // Semua agenda dari API
  List<AgendaDetail> _originalAgendaList = []; // Backup data asli dari API
  List<AgendaDetail> _displayedAgendaList = []; // Agenda yang ditampilkan
  bool _isLoading = true;
  bool _isLoadingMore = false; // Loading state untuk load more
  String? _errorMessage;
  final String _currentStudentId = 'TLAB.0001'; // Contoh Student ID

  // Current active filters
  Map<String, dynamic> _currentFilters = {};

  // Load More
  final int _itemsPerLoad = 2; // Jumlah item yang dimuat per load
  int _currentLoadedCount = 0; // Jumlah item yang sudah dimuat

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
    _scrollController.dispose();
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

Future<void> _fetchAgendaList({Map<String, dynamic>? filters}) async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  // Use filters if provided, otherwise use current filters
  final Map<String, dynamic> activeFilters = filters ?? _currentFilters;

  final AgendaListResponse? response = await getAgendaList(
    studentId: _currentStudentId,
    tahunAjaran: activeFilters['tahun_ajaran'] as String?,
    tanggalMulai: activeFilters['tanggal_mulai'] as String?,
    tanggalAkhir: activeFilters['tanggal_akhir'] as String?,
    pengirim: activeFilters['pengirim'] as String?,
  );

  if (response != null) {
    if (mounted) {
      setState(() {
        _originalAgendaList = List.from(response.lists); // Backup data asli
        _allAgendaList = List.from(response.lists); // Data yang akan difilter
        _currentLoadedCount = 0;
        _displayedAgendaList = [];
        _isLoading = false;
      });
      // Load initial items
      _loadMoreItems();
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
  // Keep current filters when refreshing
  await _fetchAgendaList(filters: _currentFilters);
}


void _applyAgendaFilter(Map<String, dynamic> filters) {
  setState(() {
    // Update current filters
    _currentFilters = Map.from(filters);
    
    // Apply filter to original data
    final List<AgendaDetail> filteredTemp =
        _originalAgendaList.where((agenda) {
      // Filter by sender - parse the string value from filters
      bool matchesPengirim = true;
      final String? pengirimFilter = filters['pengirim'] as String?;
      
      if (pengirimFilter != null && pengirimFilter.isNotEmpty) {
        matchesPengirim = agenda.from == pengirimFilter;
      }

      // Filter by date - parse string dates to DateTime objects
      bool matchesDate = true;
      final String? startDateStr = filters['tanggal_mulai'] as String?;
      final String? endDateStr = filters['tanggal_akhir'] as String?;
      
      if (startDateStr != null || endDateStr != null) {
        final DateTime? startDate = startDateStr != null 
            ? DateTime.tryParse(startDateStr) 
            : null;
        final DateTime? endDate = endDateStr != null 
            ? DateTime.tryParse(endDateStr) 
            : null;
        
        final DateTime agendaDate = agenda.date;

        if (startDate != null && endDate != null) {
          // Date range filter
          matchesDate = agendaDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
              agendaDate.isBefore(endDate.add(const Duration(days: 1)));
        } else if (startDate != null) {
          // Single date filter
          matchesDate = DateUtils.isSameDay(agendaDate, startDate);
        }
      }

      return matchesPengirim && matchesDate;
    }).toList();
    
    _allAgendaList = filteredTemp;
    _currentLoadedCount = 0;
    _displayedAgendaList = [];
  });
  
  // Load initial items after filter
  _loadMoreItems();
  // Scroll to top after applying filter
  _scrollToTop();
}

  // Method to load more items
  void _loadMoreItems() {
    if (_isLoadingMore || _currentLoadedCount >= _allAgendaList.length) return;
    
    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading delay (optional)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final int endIndex = (_currentLoadedCount + _itemsPerLoad)
            .clamp(0, _allAgendaList.length);
        
        setState(() {
          _displayedAgendaList.addAll(
            _allAgendaList.sublist(_currentLoadedCount, endIndex)
          );
          _currentLoadedCount = endIndex;
          _isLoadingMore = false;
        });
      }
    });
  }

  // Check if there are more items to load
  bool get _hasMoreItems => _currentLoadedCount < _allAgendaList.length;

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
          currentFilters: _currentFilters, // Kirim filter yang sudah ada
          onApplyFilter: _applyAgendaFilter, // Fixed: proper method reference
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

  Widget _buildLoadMoreButton() {
    if (!_hasMoreItems) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 0.0, bottom: 24.0, left: 16.0, right: 16.0),
      child: Center(
        child: _isLoadingMore
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _loadMoreItems,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  minimumSize: const Size(200, 48), // Ukuran minimum button
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Muat Lebih Banyak',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    if (_allAgendaList.isEmpty) {
      return const Center(child: Text('Tidak ada agenda yang ditemukan.'));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _displayedAgendaList.length + 2, // +1 untuk AdCard, +1 untuk LoadMore button
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if (index == 0) return _buildAdCard();

        // Jika ini adalah item terakhir, tampilkan load more button
        if (index == _displayedAgendaList.length + 1) {
          return _buildLoadMoreButton();
        }

        final item = _displayedAgendaList[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
          child: AgendaCard(
            tanggal: DateFormat('d MMMM yyyy', 'id_ID').format(item.date),
            dari: item.from,
            untuk: item.to,
            detail: item.detail,
            agendaId: item.id,
            onTap: () {
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
    );
  }
}