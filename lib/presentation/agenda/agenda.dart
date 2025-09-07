import 'package:flutter/material.dart';
import 'package:guardian_app/data/api/Agenda.dart';
import 'package:guardian_app/data/models/Agenda.dart';
import 'package:guardian_app/widgets/filterpopup.dart';
import 'package:guardian_app/theme/app_decoration.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/secondary_topbar.dart';
import 'package:guardian_app/widgets/topbar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:guardian_app/routes/app_routes.dart';
import 'package:guardian_app/presentation/pilihanak/pilihanak.dart';
import 'package:intl/intl.dart';
import 'package:guardian_app/widgets/agenda_card.dart'; // Mengimpor AgendaCard
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchAgendaList();
  }

  Future<void> _fetchAgendaList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final AgendaListResponse? response = await getAgendaList(studentId: _currentStudentId);

    if (response != null) {
      if (mounted) {
        setState(() {
          _filteredAgendaList = response.lists;
          _isLoading = false;
        });
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
      // Ini adalah filter sederhana pada data yang sudah diambil dari API
      // Jika Anda perlu filter dari sisi server, logikanya perlu diubah
      final List<AgendaDetail> filteredTemp = _filteredAgendaList.where((agenda) {
        final pengirimFilter = filters['pengirim'] as AgendaFilterPengirim;
        final bool matchesPengirim = pengirimFilter == AgendaFilterPengirim.semua ||
            (pengirimFilter == AgendaFilterPengirim.waliKelas5A && agenda.from == 'Wali Kelas 5A') ||
            (pengirimFilter == AgendaFilterPengirim.guruOlahraga && agenda.from == 'Guru Seni Budaya 5A') ||
            (pengirimFilter == AgendaFilterPengirim.adminSekolah && agenda.from == 'Admin Sekolah');

        final DateTime? startDate = filters['tanggal_mulai'];
        final DateTime? endDate = filters['tanggal_akhir'];
        final DateTime agendaDate = agenda.date;

        bool matchesDate = true;
        if (startDate != null && endDate != null) {
          matchesDate = agendaDate.isAfter(startDate.subtract(const Duration(days: 1))) && agendaDate.isBefore(endDate.add(const Duration(days: 1)));
        } else if (startDate != null) {
          matchesDate = DateUtils.isSameDay(agendaDate, startDate);
        } else {
          matchesDate = true;
        }

        return matchesPengirim && matchesDate;
      }).toList();
      _filteredAgendaList = filteredTemp;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: BottomNavBar(
        selected: AppRoutes.agendaScreen,
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
            // Gunakan Expanded agar daftar agenda mengisi sisa ruang layar
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: _buildAgendaList(), // Pindahkan _buildAgendaList ke sini
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.ads_click,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ads",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "In the lessons we learn new words and for vocabularities continues and articl...",
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
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
                child: const Text('Coba Lagi', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              )
            ],
          ),
        ),
      );
    }

    if (_filteredAgendaList.isEmpty) {
      return const Center(
        child: Text('Tidak ada agenda yang ditemukan.'),
      );
    }

    // Gunakan ListView.builder untuk menampilkan daftar agenda
    // dengan _buildAdCard() sebagai item pertama
    return ListView.builder(
      itemCount: _filteredAgendaList.length + 1, // Tambah 1 untuk AdCard
      padding: EdgeInsets.zero, // Hapus padding default ListView
      itemBuilder: (context, index) {
        if (index == 0) {
          // Item pertama adalah AdCard
          return _buildAdCard();
        }
        
        // Item sisanya adalah AgendaCard
        // Kurangi index dengan 1 untuk mengakses data dari _filteredAgendaList
        final item = _filteredAgendaList[index - 1];
        return Padding(
          // Berikan padding pada setiap AgendaCard agar tidak menempel
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: AgendaCard(
            tanggal: DateFormat('d MMMM yyyy', 'id_ID').format(item.date),
            dari: item.from,
            untuk: item.to,
            detail: item.detail,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.DetailAgendaScreen,
              );
            },
          ),
        );
      },
    );
  }
}