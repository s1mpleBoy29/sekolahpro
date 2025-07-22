import 'package:flutter/material.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 20), // ↓ geser 10px ke bawah
      child: SizedBox(
        width: 72, // Lebar FAB
        height: 72, // Tinggi FAB
        child: FloatingActionButton(
          onPressed: onPressed,
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
