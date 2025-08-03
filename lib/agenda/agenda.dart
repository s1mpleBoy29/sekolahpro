import 'package:flutter/material.dart';
import 'package:guardian_app/agenda/filterpopup.dart';
import 'package:guardian_app/theme/app_decoration.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/secondary_topbar.dart';
import 'package:guardian_app/widgets/secondary_topbar/sekolah.dart';
import 'package:guardian_app/widgets/topbar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:guardian_app/routes/app_routes.dart';

// Mengimpor AgendaCard
import 'package:guardian_app/widgets/agenda_card.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  AgendaPageScreen createState() => AgendaPageScreen();
}

class AgendaPageScreen extends State<AgendaScreen> {
  late String filterArea = 'smpn_13_malang';

  Future<void> onRefresh() async {}
void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // WAJIB true agar tinggi bisa diatur
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(1), // Mengatur warna menjadi hitam dengan opasitas 50%
      builder: (BuildContext context) {
        // Menggunakan FractionallySizedBox untuk mengatur tinggi pop-up
        return FractionallySizedBox(
          heightFactor: 0.94, 
          child: FilterPopup(),
        );
      },
    );
  }

void _navigateToAnakScreen() {
    Navigator.pushNamed(context, AppRoutes.pilihAnakScreen); // Ganti dengan rute yang sesuai
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        context: context,
        theme: theme,
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.bayarSatuScreen);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        width: double.maxFinite,
        decoration: AppDecoration.fillGray,
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
              titleText: 'Candra Wijaya', // Ini adalah judul
              subtitleText: 'SDN 13 Malang | Kelas 5', // Ini adalah subtitle
              onTitleTap: _navigateToAnakScreen, 
            ),
            // Updated SecondaryTopbar with simple layout
            SecondaryTopbar(
              backgroundColor: Color(0xFF7D5C86), // Purple background like in the image
              lineColor: appTheme.gray300,
              title: 'Agenda',
              titleColor: Colors.white,
              slot: [], // Empty slot since we're using the simple layout
              onActionTap: (selectedValue) {
                // Handle filter action
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
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: const Color(0xFFFFFFFF),
              alignment: Alignment.center,  
              child: const Text(
                'Agenda',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const Text('👤 Pilih Anak',
                      style: TextStyle(color: Colors.grey)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Candra Wijaya',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7D5C86))),
                      Icon(Icons.arrow_drop_down, color: Color(0xFF7D5C86)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.filter_alt_outlined, color: Color(0xFF7D5C86)),
                SizedBox(width: 4),
                Text('Filter Lain', style: TextStyle(color: Color(0xFF7D5C86))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return const SizedBox(height: 16);
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
    final agendaList = [
      {
        "date": "07 Juli 2025",
        "from": "Wali Kelas 5A",
        "to": "Candra Wijaya",
        "content":
            "Titik kumpul di lapangan utama, bawa topi dan minuman sendiri",
      },
      {
        "date": "07 Juli 2025",
        "from": "Wali Kelas 5A",
        "to": "Candra Wijaya",
        "content":
            "Titik kumpul di lapangan utama, bawa topi dan minuman sendiri. Dimohon untuk siswa-siswi membawa tanda pengenal.",
      },
      {
        "date": "04 Juli 2025",
        "from": "Wali Kelas 5A",
        "to": "Candra Wijaya",
        "content":
            "Bawa alat tulis lengkap, termasuk pensil, penghapus, penggaris, dan kalkulator sederhana.",
      },
            {
        "date": "04 Juli 2025",
        "from": "Guru Seni BUdaya 5A",
        "to": "Tugas Seni Budaya",
        "content":
            "Tugas menggambar sebuah pemendangan yang ada di rumah masing masing.",
      },
    ];

    return ListView.builder(
      itemCount: agendaList.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final item = agendaList[index];
        return AgendaCard(
          tanggal: item['date']!,
          dari: item['from']!,
          untuk: item['to']!,
          detail: item['content']!,
          onTap: () {
            // Logika navigasi sekarang berada di sini
            Navigator.pushNamed(
              context,
              AppRoutes.DetailAgendaScreen,
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNavBar(ThemeData theme) {
    return BottomAppBar(
      height: 72,
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomNavItem(
              icon: LucideIcons.home, label: 'Beranda', selected: false),
          _bottomNavItem(
              icon: LucideIcons.calendar, label: 'Agenda', selected: true),
          const SizedBox(width: 48),
          _bottomNavItem(
              icon: LucideIcons.barChart2, label: 'Keuangan', selected: false),
          _bottomNavItem(
              icon: Icons.account_circle, label: 'Akun', isAvatar: true),
        ],
      ),
    );
  }

  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    bool selected = false,
    bool isAvatar = false,
  }) {
    final color = selected ? const Color(0xFF7D5C86) : Colors.grey;
    return InkWell(
      onTap: () {
        // TODO: Add navigation logic here
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isAvatar
              ? const CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage("assets/user.jpg"),
                )
              : Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
