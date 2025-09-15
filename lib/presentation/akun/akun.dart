import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/providers/auth_provider.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkunScreen extends StatefulWidget {
  const AkunScreen({super.key});

  @override
  AkunPageScreen createState() => AkunPageScreen();
}

class AkunPageScreen extends State<AkunScreen> {
  dynamic user = {};

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
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = authProvider.user;

    print('check user, ${user['email']}');
  }

  void _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.error,
                            Colors.red.shade300,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.shade200.withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Apakah Anda yakin ingin keluar dari aplikasi?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: theme.colorScheme.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    if (shouldLogout ?? false) {
      final auhtProvider = Provider.of<AuthProvider>(context, listen: false);
      await auhtProvider.logout();
      final prefs = await SharedPreferences.getInstance();

      await prefs.clear();

      Navigator.pushReplacementNamed(context, '/login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: BottomNavBar(
        context: context,
        selected: 'akun', // Menandakan bahwa ini adalah halaman Agenda
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
              Expanded(
                child: ListView(
                  children: [
                    _buildProfile(),
                    for (var section in menuList) ...[
                      _buildSectionTitle(section['title']),
                      // const Divider(height: 1),
                      for (var item in section['items']) _buildMenuItem(item),
                    ],
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CustomElevatedButton(
                        text: " Log Out",
                        buttonStyle: CustomButtonStyles.errorButton,
                        leftIcon: Icon(
                          Icons.logout,
                          color: theme.colorScheme.surface,
                        ),
                        onPressed: _handleLogout,
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
            user['full_name'] ?? 'Guardian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            user['email'] ?? 'email',
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
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
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(5),
            ),
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
                  Navigator.pushNamed(context, AppRoutes.dataAnakScreen);
                } else if (label == 'Sekolah Tertaut') {
                  Navigator.pushNamed(context, AppRoutes.infoSekolahScreen);
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
          // const Divider(height: 1),)
        ),
      ],
    );
  }
}
