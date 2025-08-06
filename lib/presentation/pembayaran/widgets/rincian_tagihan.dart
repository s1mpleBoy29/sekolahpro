import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/utils/number_format.dart';

class RincianTagihan extends StatelessWidget {
  final List<Map<String, dynamic>> selectedItems;

  const RincianTagihan({
    super.key,
    required this.selectedItems,
  });

  // Hitung lagi.
  int _calculateTotal() {
    return selectedItems.fold(0, (previousValue, item) {
      final amount = item['amount'] as num? ?? 0;
      return previousValue + amount.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Bila tidak ada item
    if (selectedItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Rincian Tagihan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary,
            border: Border.all(color: theme.colorScheme.onPrimary),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              ...selectedItems.map((item) {
                final description =
                    item['deskripsi'] as String? ?? 'Item tidak valid';
                final amount = item['amount'] as num? ?? 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          description.split('\n').first,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        numberFormat('rp_fixed', amount),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const Divider(thickness: 1, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    numberFormat('rp_fixed', _calculateTotal()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
