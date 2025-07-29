import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/topbar.dart';
import 'package:guardian_app/widgets/ad_card.dart';
import 'package:guardian_app/widgets/agenda_card.dart';
import 'package:guardian_app/widgets/due_card.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Pastikan sudah install: lucide_icons

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
            const AdCard(
              text:
                  "In the lessons we learn new words and for vocabularities continues and article...",
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Tunggakan Hari Ini"),
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
            _buildSectionTitle("Jadwal Pembayaran Selanjutnya",
                action: "Lihat Jadwal"),
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
            _buildSectionTitle("Agenda Hari Ini", action: "Lihat Agenda"),
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

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Selamat Pagi",
                  style: TextStyle(
                      color: theme.colorScheme.secondary, fontSize: 16)),
              Text(
                "Bapak Santoso",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        const Stack(
          children: [
            Icon(Icons.notifications_none, size: 30),
            Positioned(
              right: 0,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Text("3",
                    style: TextStyle(fontSize: 10, color: Colors.white)),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title, {String? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        if (action != null)
          Text(
            action,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant, // Warna border top
            width: 1.0,
          ),
        ),
      ),
      child: BottomAppBar(
        height: 72,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(
              icon: LucideIcons.home,
              label: 'Beranda',
              selected: true,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.homeScreen);
              },
            ),
            _bottomNavItem(
              icon: LucideIcons.calendar,
              label: 'Agenda',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.agendaScreen);
              },
            ),
            const SizedBox(width: 48), // For FAB
            _bottomNavItem(
              icon: LucideIcons.barChart2,
              label: 'Keuangan',
              onTap: () {},
            ),
            _bottomNavItem(
              icon: Icons.account_circle,
              label: 'Akun',
              isAvatar: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool selected = false,
    bool isAvatar = false,
  }) {
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onPrimaryContainer;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isAvatar
              ? const CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage("assets/user.jpg"),
                )
              : Icon(icon, color: color, size: 24),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return Transform.translate(
      offset: const Offset(0, 20), // ↓ geser 10px ke bawah
      child: SizedBox(
        width: 72, // Lebar FAB
        height: 72, // Tinggi FAB
        child: FloatingActionButton(
          onPressed: () {
            // Aksi saat tombol ditekan
          },
          elevation: 6,
          backgroundColor: theme.colorScheme.primary,
          shape: const CircleBorder(),
          child: Icon(
            LucideIcons.creditCard,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
