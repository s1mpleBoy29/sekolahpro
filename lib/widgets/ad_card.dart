  import 'package:flutter/material.dart';
  import 'package:guardian_app/core/app_export.dart';

  class AdCard extends StatelessWidget {
    final String text;
    const AdCard({super.key, required this.text});

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.ads_click),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
