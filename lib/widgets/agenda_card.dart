import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

// Import kelas AppRoutes untuk menggunakan rute bernama
import 'package:guardian_app/routes/app_routes.dart';
// Import halaman DetailAgenda
import 'package:guardian_app/presentation/detailagenda.dart';


class AgendaCard extends StatelessWidget {
  final String tanggal;
  final String dari;
  final String untuk;
  final String detail;
  // Menambahkan parameter onTap
  final VoidCallback? onTap;

  const AgendaCard({
    super.key,
    required this.tanggal,
    required this.dari,
    required this.untuk,
    required this.detail,
    this.onTap, // Parameter onTap bersifat opsional
  });

  @override
  Widget build(BuildContext context) {
    // Bungkus container dengan GestureDetector untuk membuatnya bisa diklik
    return GestureDetector(
      // Menggunakan callback onTap dari parameter
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(top: 8, bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tanggal,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Dari : $dari",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 14,
              ),
            ),
            Text(
              "Untuk : $untuk",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              detail,
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
