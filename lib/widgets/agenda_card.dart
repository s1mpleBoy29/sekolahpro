import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class AgendaCard extends StatelessWidget {
  final String tanggal;
  final String dari;
  final String untuk;
  final String detail;

  const AgendaCard({
    super.key,
    required this.tanggal,
    required this.dari,
    required this.untuk,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
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
            tanggal,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Dari : $dari",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          Text(
            "Untuk : $untuk",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
