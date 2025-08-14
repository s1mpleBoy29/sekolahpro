import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/theme/custom_text_style.dart';
import 'package:guardian_app/theme/theme_helper.dart';

class NotificationCard extends StatelessWidget {
  final String tanggal;
  final String judul;
  final String deskripsi;
  final bool isRead;

  const NotificationCard({
    super.key,
    required this.tanggal,
    required this.judul,
    required this.deskripsi,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isRead ? const Color(0xFFE0E0E0) : const Color(0xFFF7EBF7);
    final Color borderColor = isRead ? const Color(0xFFC0C0C0) : const Color(0xFFE5BEE5);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teks untuk tanggal - menggunakan style yang lebih kecil dan abu
          Text(
            tanggal,
            style: CustomTextStyles.titleMediumGrey, // Style untuk tanggal
          ),
          const SizedBox(height: 8),
          // Teks untuk judul notifikasi - menggunakan style yang lebih ringan
          Text(
            judul,
            style: CustomTextStyles.titleMediumLato.copyWith(
              fontWeight: FontWeight.w400, // Lebih ringan dari w600
              fontSize: 16.fSize,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          // Teks untuk deskripsi notifikasi - menggunakan body style yang ringan
          Text(
            deskripsi,
            style: CustomTextStyles.titleMediumLato.copyWith(
              fontWeight: FontWeight.w400, // Weight yang sama dengan judul
              color: Colors.black87,
              fontSize: 14.fSize,
            ),
          ),
        ],
      ),
    );
  }
}