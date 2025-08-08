import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UploadFileCard extends StatelessWidget {
  final VoidCallback onTap;

  const UploadFileCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1.5,
          ),
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.upload,
                size: 40,
                color: theme.colorScheme.outlineVariant,
              ),
              const SizedBox(height: 8),
              Text(
                "Pilih File",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
