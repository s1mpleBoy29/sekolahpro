import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class InstructionCard extends StatelessWidget {
  final String number;
  final String teksInstruksi;
  const InstructionCard(
      {super.key, required this.number, required this.teksInstruksi});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              teksInstruksi,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
