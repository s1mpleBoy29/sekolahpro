import 'package:flutter/material.dart';
// Assuming this import is available from your project structure, similar to DueCard.
import 'package:guardian_app/core/app_export.dart';

class PaymentScheduleCard extends StatelessWidget {
  final String? dueDate;
  final String amount;
  final String description;
  final String status;
  final bool isOverdue;
  final VoidCallback? onPayPressed; // Added for the payment action

  const PaymentScheduleCard({
    Key? key,
    this.dueDate,
    required this.amount,
    required this.description,
    required this.status,
    this.isOverdue = false,
    this.onPayPressed, // Can be null if no action is needed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using the theme for consistent styling, similar to DueCard
    final theme = Theme.of(context);

    // Determine the title text based on overdue status
    final String titleText = isOverdue
        ? 'Melewati batas waktu pembayaran'
        : 'Bayar sebelum ${dueDate ?? ''}';

    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        // The border color changes if the card is overdue
        border: Border.all(
            color: isOverdue
                ? theme.colorScheme.error
                : theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(4),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: TextStyle(
                    color: isOverdue
                        ? theme.colorScheme.error
                        : theme.colorScheme.secondary,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Conditionally display a button or a status tag
          if (status.toLowerCase() != 'lunas' && onPayPressed != null)
            GestureDetector(
              onTap: onPayPressed,
              child: Container(
                width: 90,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent, // No filled color
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey.shade600, // Gray outline
                    width: 1,
                  ),
                ),
                child: Text(
                  status, // Displays "Belum Lunas"
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600, // Gray font color
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            // Status tag for "Lunas" or when no action is available
            Container(
              width: 90,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  // Use green for "Lunas", otherwise a neutral color
                  color: status.toLowerCase() == 'lunas'
                      ? Colors.green
                      : Colors.grey.shade400,
                  width: 1,
                ),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: status.toLowerCase() == 'lunas'
                      ? Colors.green
                      : Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
