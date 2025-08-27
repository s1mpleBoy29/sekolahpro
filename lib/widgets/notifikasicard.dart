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
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan warna berdasarkan status isRead
    final Color backgroundColor = isRead ? Colors.white : const Color(0xFFF7EBF7);
    final Color borderColor = isRead ? Colors.grey[300]! : const Color(0xFFE5BEE5);
    final Color titleColor = isRead ? Colors.black : Colors.black;
    final Color descriptionColor = isRead ? Colors.black87 : Colors.black87;
    final Color dateColor = isRead ? Colors.grey : Colors.grey;

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
          // Teks untuk tanggal
          Text(
            tanggal,
            style: CustomTextStyles.titleMediumGrey.copyWith(color: dateColor),
          ),
          const SizedBox(height: 8),
          // Teks untuk judul notifikasi
          Text(
            judul,
            style: CustomTextStyles.titleMediumLato.copyWith(
              fontWeight: FontWeight.w400, // Gunakan fontWeight yang sudah ditentukan
              fontSize: 16.fSize,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          // Teks untuk deskripsi notifikasi
          Text(
            deskripsi,
            style: CustomTextStyles.titleMediumLato.copyWith(
              fontWeight: FontWeight.w400,
              color: descriptionColor,
              fontSize: 14.fSize,
            ),
          ),
        ],
      ),
    );
  }
}