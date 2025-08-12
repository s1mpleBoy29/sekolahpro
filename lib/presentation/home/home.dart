import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/utils/datetime_ui.dart';
import 'package:guardian_app/core/utils/number_format.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/topbar.dart';
import 'package:guardian_app/widgets/ad_card.dart';
import 'package:guardian_app/widgets/agenda_card.dart';
import 'package:guardian_app/widgets/due_card.dart';
import 'package:guardian_app/presentation/home/widgets/section_title.dart';
import 'package:guardian_app/presentation/home/widgets/header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomePageScreen createState() => HomePageScreen();
}

class HomePageScreen extends State<HomeScreen> {
  List<dynamic> payment = [];
  List<dynamic> agenda = [];

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

    agenda = [
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
    setDummyData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        selected: AppRoutes.homeScreen,
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // TopBar(
            //   mode: TopBarMode.greeting,
            //   greeting: "Selamat Pagi,",
            //   userName: "Bapak Santoso",
            //   notificationCount: 3,
            //   onNotificationTap: () {
            //     // Navigasi ke halaman notifikasi
            //   },
            // ),
            const SizedBox(height: 16),
            const Header(
              waktu: "Selamat Pagi",
              user: "Bapak Santoso",
            ),
            const AdCard(
              teks:
                  "In the lessons we new words and for vocabularities continues and article...",
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: "Tunggakan Hari Ini"),
            DueCard(
              isOverdue: true,
              harga: "Rp 300.000",
              deskripsi:
                  "Uang Sekolah Chandra Bulan Juli\nTahun Ajaran 2025 / 2026",
              onPayPressed: () {
                // Aksi ketika tombol bayar ditekan
              },
            ),
            const SizedBox(height: 24),
            const SectionTitle(
                title: "Jadwal Pembayaran Selanjutnya", action: "Lihat Jadwal"),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                0.0,
                4.0,
                0.0,
                4.0,
              ),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: payment.length,
                    itemBuilder: (context, idx) {
                      dynamic paymentItem = payment[idx];
                      return DueCard(
                        isOverdue: paymentItem['is_overdue'],
                        dueDate: dateTimeFormat(
                          'dateui',
                          paymentItem['due_date'],
                        ),
                        harga: numberFormat('idr_fixed', paymentItem['amount']),
                        deskripsi: paymentItem['description'],
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: agenda.length,
                    itemBuilder: (context, idx) {
                      dynamic agendaItem = agenda[idx];
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
    );
  }
}
