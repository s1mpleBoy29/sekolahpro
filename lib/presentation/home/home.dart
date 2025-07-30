import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        context: context,
        theme: theme,
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {},
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
            DueCard(
              isOverdue: false,
              dueDate: "10 Agustus 2025",
              harga: "Rp 300.000",
              deskripsi:
                  "Uang Sekolah Chandra Bulan Agustus\nTahun Ajaran 2025 / 2026",
              onPayPressed: () {
                // Aksi ketika tombol bayar ditekan
              },
            ),
            const SizedBox(height: 24),
            const SectionTitle(
                title: "Agenda Hari Ini", action: "Lihat Agenda"),
            const AgendaCard(
                tanggal: "07 Juli 2025",
                dari: "Wali Kelas 5A",
                untuk: "Candra Wijaya",
                detail:
                    "Titik kumpul di lapangan utama, bawa topi dan minuman sendiri. Dimohon untuk siswa-siswi..."),
          ],
        ),
      ),
    );
  }
}
