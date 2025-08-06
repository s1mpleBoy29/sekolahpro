import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/utils/number_format.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';

class BottomBar extends StatelessWidget {
  final int totalAmount;
  final VoidCallback onContinuePressed;
  final bool isNeeded;

  const BottomBar({
    required this.totalAmount,
    required this.onContinuePressed,
    required this.isNeeded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant, width: 1.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Vertical minimum
        children: [
          if (isNeeded)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Tagihan",
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  numberFormat('rp_fixed', totalAmount),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          if (isNeeded) const SizedBox(height: 16),
          CustomElevatedButton(
            text: "Lanjutkan",
            buttonTextStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            onPressed: onContinuePressed,
          ),
        ],
      ),
    );
  }
}
