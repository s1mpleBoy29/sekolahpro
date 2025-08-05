import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';

class RekeningCard extends StatelessWidget {
  final String bankName;
  final String accountName;
  final String accountNumber;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onCopy;

  const RekeningCard({
    super.key,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.isSelected,
    this.onTap,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
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
              margin: const EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "a.n. $accountName",
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "No. Rek: $accountNumber",
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              CustomElevatedButton(
                width: 90,
                height: 36,
                text: "Salin",
                leftIcon: Icon(
                  Icons.copy_all_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 16,
                ),
                buttonTextStyle: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: onCopy,
              ),
          ],
        ),
      ),
    );
  }
}
