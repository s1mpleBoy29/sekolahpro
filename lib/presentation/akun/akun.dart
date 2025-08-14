import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';
import 'package:guardian_app/widgets/custom_fab.dart';

class AkunScreen extends StatefulWidget {
  const AkunScreen({super.key});

  @override
  AkunPageScreen createState() => AkunPageScreen();
}

class AkunPageScreen extends State<AkunScreen> {
  final List<Map<String, dynamic>> menuList = [
    {
      'title': 'Pribadi',
      'items': ['Profil Akun', 'Ubah Password']
    },
    {
      'title': 'Sekolah',
      'items': ['Data Anak', 'Sekolah Tertaut']
    },
    {
      'title': 'SekolahPro',
      'items': ['Tentang Kami', 'FAQ', 'Kontak']
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: BottomNavBar(
        context: context,
        theme: theme,
        selected: 'akun', // Menandakan bahwa ini adalah halaman Agenda
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
            _buildProfile(),
            Expanded(
              child: ListView(
                children: [
                  for (var section in menuList) ...[
                    _buildSectionTitle(section['title']),
                    const Divider(height: 1),
                    for (var item in section['items']) _buildMenuItem(item),
                  ],
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomElevatedButton(
                      text: " Log Out",
                      buttonStyle: CustomButtonStyles.errorButton,
                      leftIcon: Icon(
                        Icons.logout,
                        color: theme.colorScheme.surface,
                      ),
                      onPressed: () {},
                      height: 48,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.outline,
            child: Icon(
              Icons.person,
              size: 40,
              color: theme.colorScheme.surface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Bapak Santoso Wijaya',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'santoso.wijaya@gmail.com',
            style: TextStyle(
              color: theme.colorScheme.outline,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(
            title == 'Pribadi'
                ? Icons.person_outline
                : title == 'Sekolah'
                    ? Icons.school_outlined
                    : Icons.business,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.outline,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String label) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: ListTile(
            title: Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.primary,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.primary,
            ),
            onTap: () {
              if (label == 'Profil Akun') {
                Navigator.pushNamed(context, AppRoutes.editProfieScreen);
              } else if (label == 'Ubah Password') {
                Navigator.pushNamed(context, AppRoutes.ubahPasswordScreen);
              } else if (label == 'Data Anak') {
                // Navigator.pushNamed(context, AppRoutes.pilihAnakScreen);
              } else if (label == 'Sekolah Tertaut') {
                // Navigator.pushNamed(context, AppRoutes.sekolahTertautScreen);
              } else if (label == 'Tentang Kami') {
                // Navigator.pushNamed(context, AppRoutes.tentangKamiScreen);
              } else if (label == 'FAQ') {
                // Navigator.pushNamed(context, AppRoutes.faqScreen);
              } else if (label == 'Kontak') {
                // Navigator.pushNamed(context, AppRoutes.kontakScreen);
              }
              // Handle navigation
            },
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
