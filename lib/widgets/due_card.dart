import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';

class DueCard extends StatelessWidget {
  final bool isOverdue;
  final String? dueDate;
  final String harga;
  final String deskripsi;
  final VoidCallback onPayPressed;

  const DueCard({
    super.key,
    required this.isOverdue,
    this.dueDate,
    required this.harga,
    required this.deskripsi,
    required this.onPayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
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
                      fontSize: 14,
                    ),
                  )
                else
                  Text(
                    dueDate ?? "",
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  harga,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  deskripsi,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          CustomElevatedButton(
            width: 80,
            height: 32,
            text: "Bayar",
            buttonTextStyle: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onPrimary,
            ),
            onPressed: onPayPressed,
          ),
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: theme.colorScheme.primary,
          //     foregroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //   ),
          //   child: const Text("Bayar"),
          // )
        ],
      ),
    );
  }
}
