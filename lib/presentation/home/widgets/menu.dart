import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  const MenuCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade300 : Colors.purple.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: disabled ? Colors.grey : Colors.purple,
            ),
            const SizedBox(height: 8),
            Text(
              disabled ? "Segera Hadir" : title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: disabled ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
