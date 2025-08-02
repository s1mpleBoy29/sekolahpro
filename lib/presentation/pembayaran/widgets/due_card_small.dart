import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class DueCard extends StatelessWidget {
  final bool isOverdue;
  final String harga;
  final String deskripsi;
  final bool isSelected;
  final VoidCallback? onTap;

  const DueCard({
    super.key,
    required this.isOverdue,
    required this.harga,
    required this.deskripsi,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 12.0),
              decoration: BoxDecoration(
                color:
                    isSelected ? theme.colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 18.0,
                      color: Colors.white,
                    )
                  : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isOverdue)
                    Text(
                      "Melewati batas waktu pembayaran",
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  else
                    const SizedBox(height: 2),
                  Text(
                    deskripsi,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    harga,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
