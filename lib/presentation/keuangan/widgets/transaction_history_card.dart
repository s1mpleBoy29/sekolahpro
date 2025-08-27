import 'package:flutter/material.dart';

class TransactionHistoryCard extends StatelessWidget {
  final String date;
  final String amount;
  final String description;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;
  final bool isRejected;
  final String? rejectionMessage;

  const TransactionHistoryCard({
    super.key,
    required this.date,
    required this.amount,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
    this.isRejected = false,
    this.rejectionMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: isRejected
              ? theme.colorScheme.error
              : theme.colorScheme.outlineVariant,
          width: isRejected ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRejected && rejectionMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                rejectionMessage!,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Gunakan warna yang diterima
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}