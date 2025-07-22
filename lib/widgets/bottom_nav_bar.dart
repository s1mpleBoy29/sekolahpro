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
  });

  @override
  Widget build(BuildContext context) {
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
              selected: true,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.homeScreen);
              },
            ),
            _bottomNavItem(
              icon: LucideIcons.calendar,
              label: 'Agenda',
              selected: false,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.agendaScreen);
              },
            ),
            const SizedBox(width: 48), // For FAB
            _bottomNavItem(
              icon: LucideIcons.barChart2,
              label: 'Keuangan',
              selected: false,
              onTap: () {},
            ),
            _bottomNavItem(
              icon: Icons.account_circle,
              label: 'Akun',
              selected: false,
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
