import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../routes/app_routes.dart'; // sesuaikan dengan lokasi file route kamu

class BottomNavBar extends StatelessWidget {
  final BuildContext context;
  final ThemeData theme;

  const BottomNavBar({
    super.key,
    required this.context,
    required this.theme,
    required String selected,
  });

  @override
  Widget build(BuildContext context) {
    ModalRoute? route = ModalRoute.of(context);
    String? currentRoute = route?.settings.name;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
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
              selected: currentRoute == AppRoutes.homeScreen,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.homeScreen);
              },
            ),
            _bottomNavItem(
              icon: LucideIcons.calendar,
              label: 'Agenda',
              selected: currentRoute == AppRoutes.agendaScreen,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.agendaScreen);
              },
            ),
            const SizedBox(width: 48),
            _bottomNavItem(
              icon: LucideIcons.barChart2,
              label: 'Keuangan',
              selected: currentRoute == AppRoutes.keuanganScreen,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.keuanganScreen);
              },
            ),
            _bottomNavItem(
              icon: Icons.account_circle,
              label: 'Akun',
              selected: currentRoute == AppRoutes.akunScreen,
              isAvatar: true,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.akunScreen);
              },
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
                  backgroundImage:
                      AssetImage("assets/images/facebook_logo.png"),
                )
              : Icon(icon, color: color, size: 24),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
