import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;

  const SectionTitle({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
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
            action!,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}
