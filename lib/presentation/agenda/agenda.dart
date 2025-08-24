import 'package:flutter/material.dart';
import 'package:guardian_app/widgets/filterpopup.dart';
import 'package:guardian_app/theme/app_decoration.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/secondary_topbar.dart';
import 'package:guardian_app/widgets/secondary_topbar/sekolah.dart';
import 'package:guardian_app/widgets/topbar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:guardian_app/routes/app_routes.dart';
import 'package:guardian_app/presentation/pilihanak/pilihanak.dart';
import 'package:intl/intl.dart';

// Mengimpor AgendaCard
import 'package:guardian_app/widgets/agenda_card.dart';

// Data dummy untuk Agenda
final List<Map<String, dynamic>> _allAgendaItems = [
  {
    "date": DateTime.parse("2025-07-07"),
    "date_string": "07 Juli 2025",
    "from": "Wali Kelas 5A",
    "to": "Candra Wijaya",
    "content": "Titik kumpul di lapangan utama, bawa topi dan minuman sendiri",
  },
  {
    "date": DateTime.parse("2025-07-07"),
    "date_string": "07 Juli 2025",
    "from": "Wali Kelas 5A",
    "to": "Candra Wijaya",
    "content": "Titik kumpul di lapangan utama, bawa topi dan minuman sendiri. Dimohon untuk siswa-siswi membawa tanda pengenal.",
  },
  {
    "date": DateTime.parse("2025-07-04"),
    "date_string": "04 Juli 2025",
    "from": "Wali Kelas 5A",
    "to": "Candra Wijaya",
    "content": "Bawa alat tulis lengkap, termasuk pensil, penghapus, penggaris, dan kalkulator sederhana.",
  },
  {
    "date": DateTime.parse("2025-07-04"),
    "date_string": "04 Juli 2025",
    "from": "Guru Seni Budaya 5A",
    "to": "Tugas Seni Budaya",
    "content": "Tugas menggambar sebuah pemandangan yang ada di rumah masing-masing.",
  },
  {
    "date": DateTime.parse("2025-07-08"),
    "date_string": "08 Juli 2025",
    "from": "Admin Sekolah",
    "to": "Semua Siswa",
    "content": "Pemberitahuan: Jadwal ulangan semester akan dimajukan menjadi 15 Juli 2025.",
  },
];

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  AgendaPageScreen createState() => AgendaPageScreen();
}

class AgendaPageScreen extends State<AgendaScreen> {
  late String filterArea = 'smpn_13_malang';
  List<Map<String, dynamic>> _filteredAgendaList = [];

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar agenda yang difilter dengan semua data
    _filteredAgendaList = _allAgendaItems;
  }

  Future<void> onRefresh() async {
    setState(() {
      _filteredAgendaList = _allAgendaItems;
    });
  }

  void _applyAgendaFilter(Map<String, dynamic> filters) {
    setState(() {
      _filteredAgendaList = _allAgendaItems.where((agenda) {
        // Filter berdasarkan Pengirim
        final pengirimFilter = filters['pengirim'] as AgendaFilterPengirim;
        final bool matchesPengirim = pengirimFilter == AgendaFilterPengirim.semua ||
            (pengirimFilter == AgendaFilterPengirim.waliKelas5A && agenda['from'] == 'Wali Kelas 5A') ||
            (pengirimFilter == AgendaFilterPengirim.guruOlahraga && agenda['from'] == 'Guru Seni Budaya 5A') ||
            (pengirimFilter == AgendaFilterPengirim.adminSekolah && agenda['from'] == 'Admin Sekolah');

        // Filter berdasarkan Tanggal
        final DateTime? startDate = filters['tanggal_mulai'];
        final DateTime? endDate = filters['tanggal_akhir'];
        final DateTime agendaDate = agenda['date'];
        
        bool matchesDate = true;
        if (startDate != null && endDate != null) {
          matchesDate = agendaDate.isAfter(startDate.subtract(Duration(days: 1))) && agendaDate.isBefore(endDate.add(Duration(days: 1)));
        } else if (startDate != null) {
          matchesDate = DateUtils.isSameDay(agendaDate, startDate);
        } else {
          // Jika tidak ada filter tanggal, tampilkan semua
          matchesDate = true;
        }

        // Gabungkan semua filter
        return matchesPengirim && matchesDate;
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
          currentPage: FilterPage.agenda,
          onApplyFilter: _applyAgendaFilter, // Mengirimkan callback ke popup
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
                  child: SingleChildScrollView(
                    primary: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Column(
                        children: [
                          _buildAdCard(),
                          const SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.6,
                            ),
                            child: _buildAgendaList(),
                          ),
                        ],
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
    if (_filteredAgendaList.isEmpty) {
      return Center(
        child: Text('Tidak ada agenda yang ditemukan.'),
      );
    }
    return ListView.builder(
      primary: false,
      itemCount: _filteredAgendaList.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final item = _filteredAgendaList[index];
        return AgendaCard(
          tanggal: item['date_string']!,
          dari: item['from']!,
          untuk: item['to']!,
          detail: item['content']!,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.DetailAgendaScreen,
            );
          },
        );
      },
    );
  }
}