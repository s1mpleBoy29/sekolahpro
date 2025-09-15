import 'package:flutter/material.dart';
import 'package:guardian_app/core/actions/home_action.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/providers/auth_provider.dart';
import 'package:guardian_app/core/providers/home_provider.dart';
import 'package:guardian_app/core/providers/student_provider.dart';
import 'package:guardian_app/core/utils/datetime_ui.dart';
import 'package:guardian_app/core/utils/number_format.dart';
import 'package:guardian_app/data/models/student.dart';
import 'package:guardian_app/presentation/pilihanak/pilihanak.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/empty_card.dart';
import 'package:guardian_app/widgets/topbar.dart';
import 'package:guardian_app/widgets/ad_card.dart';
import 'package:guardian_app/widgets/agenda_card.dart';
import 'package:guardian_app/widgets/due_card.dart';
import 'package:guardian_app/presentation/home/widgets/section_title.dart';
import 'package:guardian_app/presentation/home/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:guardian_app/data/api/ad.dart';
import 'package:guardian_app/data/models/ad.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomePageScreen createState() => HomePageScreen();
}

class HomePageScreen extends State<HomeScreen> {
  List<dynamic> outstandings = [];
  List<dynamic> upcomings = [];
  List<dynamic> payment = [];
  List<dynamic> agendas = [];
  //Ads
  List<Ad> _adList = [];
  int _currentAdIndex = 0;
  Timer? _adTimer;
  //end Ads

  dynamic user = {};

  late final child;
  bool _isLoading = true;

  void setDummyData() {
    payment = [
      {
        'due_date': '2025-08-10',
        'description':
            'Uang Sekolah Chandra Bulan Agustus\nTahun Ajaran 2025 / 2026',
        'amount': 300000,
        'is_overdue': true,
      },
      {
        'due_date': '2025-07-07',
        'description':
            'Uang Sekolah Chandra Bulan Juli\nTahun Ajaran 2025 / 2026',
        'amount': 500000,
        'is_overdue': false,
      },
    ];

    agendas = [
      {
        'date': '2025-07-07',
        'child': 'Candra Wijaya',
        'from': 'Wali Kelas 5A',
        'description':
            'Titik kumpul di lapangan utama, bawa topi dan minuman sendiri. Dimohon untuk siswa-siswi...'
      },
      {
        'date': '2025-07-08',
        'child': 'Candra Wijaya',
        'from': 'Wali Kelas 5A',
        'description':
            'Titik kumpul di lapangan utama, bawa topi dan minuman sendiri. Dimohon untuk siswa-siswi...'
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    // setDummyData();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);

    user = authProvider.user;
    child = studentProvider.selectedStudent;

    _fetchHome();
    fetchData();
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

  Future<void> _fetchHome() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      // _errorMessage = '';
    });

    try {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      // Parallel execution of API calls
      final results = await Future.wait<dynamic>([
        HomeAction.getHome(child.name),
      ]);

      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Sesi anda telah berakhir. Silakan login kembali.'),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login_screen');
      }

      if (results.isNotEmpty) {
        final home = results[0] as Map<String, dynamic>;
        await homeProvider.saveHome(home);
        homeProvider.setHome(home);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        // _errorMessage = _parseErrorMessage(e);
      });
    }
  }

  void fetchData() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    setState(() {
      outstandings = homeProvider.tuitions['outstanding'] ?? [];
      upcomings = homeProvider.tuitions['upcoming'] ?? [];
      agendas = homeProvider.agendas;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToPilihAnak() {
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
        selected: AppRoutes.homeScreen,
        context: context,
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
            color: theme.colorScheme.surfaceContainer,
          ),
          child: Column(
            children: [
              Header(
                greeting: "Halo, ${user['full_name'] ?? 'Ibu'}",
                childName:
                    child.fullName.isNotEmpty ? child.fullName : 'Anak Anda',
                schoolName: child.schoolName.isNotEmpty
                    ? child.schoolName
                    : 'Sekolah Anak',
                onDropdownTap: _navigateToPilihAnak,
              ),
              Expanded(
                // ✅ supaya ListView bisa scroll
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (_adList.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: AdCard(ad: _adList[_currentAdIndex]),
                            ),
                          const SizedBox(height: 24),
                          const SectionTitle(title: "Tunggakan Hari Ini"),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              4.0,
                              0.0,
                              4.0,
                            ),
                            child: Column(
                              children: [
                                if (outstandings.isEmpty)
                                  const EmptyDueCard(
                                    message: "Tidak ada tunggakan saat ini",
                                  ),
                                if (outstandings.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: outstandings.length,
                                    itemBuilder: (context, idx) {
                                      dynamic outstanding = outstandings[idx];
                                      return DueCard(
                                        isOverdue:
                                            outstanding['is_overdue'] ?? false,
                                        dueDate: dateTimeFormat(
                                          'dateui',
                                          outstanding['due_date'],
                                        ),
                                        amount: numberFormat(
                                            'idr_fixed', outstanding['amount']),
                                        remark: outstanding['remark'] ?? '',
                                        subRemark:
                                            'Tahun Ajaran ${outstanding['academic_year']}',
                                        onPayPressed: () {
                                          // Aksi ketika tombol bayar ditekan
                                        },
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const SectionTitle(
                              title: "Jadwal Pembayaran Selanjutnya",
                              action: "Lihat Jadwal"),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              4.0,
                              0.0,
                              4.0,
                            ),
                            child: Column(
                              children: [
                                if (upcomings.isEmpty)
                                  const EmptyDueCard(
                                    message:
                                        "Tidak ada jadwal pembayaran selanjutnya",
                                  ),
                                if (upcomings.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: upcomings.length,
                                    itemBuilder: (context, idx) {
                                      dynamic upcoming = upcomings[idx];
                                      return DueCard(
                                        isOverdue:
                                            upcoming['is_overdue'] ?? false,
                                        dueDate: dateTimeFormat(
                                          'dateui',
                                          upcoming['due_date'],
                                        ),
                                        amount: numberFormat(
                                            'idr_fixed', upcoming['amount']),
                                        remark: upcoming['remark'] ?? '',
                                        subRemark:
                                            'Tahun Ajaran ${upcoming['academic_year']}',
                                        onPayPressed: () {
                                          // Aksi ketika tombol bayar ditekan
                                        },
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const SectionTitle(
                              title: "Agenda Hari Ini", action: "Lihat Agenda"),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              4.0,
                              0.0,
                              4.0,
                            ),
                            child: Column(
                              children: [
                                if (agendas.isEmpty)
                                  const EmptyDueCard(
                                    message: "Tidak ada agenda hari ini",
                                  ),
                                if (agendas.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: agendas.length,
                                    itemBuilder: (context, idx) {
                                      dynamic agendaItem = agendas[idx];
                                      return AgendaCard(
                                        tanggal: agendaItem['date'],
                                        dari: agendaItem['from'],
                                        untuk: agendaItem['child'],
                                        detail: agendaItem['description'],
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
