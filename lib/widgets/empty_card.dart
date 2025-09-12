import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class EmptyDueCard extends StatelessWidget {
  final String message;

  const EmptyDueCard({
    super.key,
    this.message = "Tidak ada tagihan saat ini",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(4),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          // Icon(
          //   Icons.receipt_long_outlined,
          //   size: 32,
          //   color: theme.colorScheme.secondary,
          // ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
