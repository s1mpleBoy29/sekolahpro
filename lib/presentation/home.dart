import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/topbar.dart';
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
            _buildAdCard(),
            const SizedBox(height: 24),
            _buildSectionTitle("Tunggakan Hari Ini"),
            _buildDueCard(isOverdue: true),
            const SizedBox(height: 24),
            _buildSectionTitle("Jadwal Pembayaran Selanjutnya",
                action: "Lihat Jadwal"),
            _buildDueCard(isOverdue: false),
            const SizedBox(height: 24),
            _buildSectionTitle("Agenda Hari Ini", action: "Lihat Agenda"),
            _buildAgendaCard(),
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

  Widget _buildAdCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.ads_click),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "In the lessons we learn new words and for vocabularities continues and article...",
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildDueCard({required bool isOverdue}) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isOverdue)
                  Text(
                    "Melewati batas waktu pembayaran",
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  )
                else
                  Text(
                    "Bayar sebelum 10 Agustus 2025",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  "Rp 300.000",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Uang Sekolah Chandra Bulan ${isOverdue ? 'Juli' : 'Agustus'}\nTahun Ajaran 2025 / 2026",
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          // const SizedBox(width: 12),
          CustomElevatedButton(
            width: 80,
            height: 32,
            text: "Bayar",
            buttonTextStyle: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onPrimary,
            ),
            onPressed: () => {},
          ),
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: theme.colorScheme.primary,
          //     foregroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //   ),
          //   child: const Text("Bayar"),
          // )
        ],
      ),
    );
  }

  Widget _buildAgendaCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "07 Juli 2025",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Dari : Wali Kelas 5A",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          Text(
            "Untuk : Candra Wijaya",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Titik kumpul di lapangan utama, bawa topi dan minuman sendiri. Dimohon untuk siswa-siswi...",
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontSize: 16,
            ),
          )
        ],
      ),
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
