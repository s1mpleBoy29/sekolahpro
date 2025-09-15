import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/theme/custom_text_style.dart';
import 'package:guardian_app/theme/theme_helper.dart';

class NotificationCard extends StatelessWidget {
  final String tanggal;
  final String judul;
  final String deskripsi;
  final bool isRead;
  final VoidCallback? onTap; // Tambahkan properti onTap

  const NotificationCard({
    super.key,
    required this.tanggal,
    required this.judul,
    required this.deskripsi,
    required this.isRead,
    this.onTap, // Tambahkan ke konstruktor
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isRead ? Colors.white : const Color(0xFFF7EBF7);
    final Color borderColor = isRead ? Colors.grey[300]! : const Color(0xFFE5BEE5);
    final Color titleColor = isRead ? Colors.black : Colors.black;
    final Color descriptionColor = isRead ? Colors.black87 : Colors.black87;
    final Color dateColor = isRead ? Colors.grey : Colors.grey;

    return GestureDetector( // Gunakan GestureDetector untuk menangani onTap
      onTap: onTap,
      child: Container(
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
            Text(
              tanggal,
              style: TextStyle(color: dateColor, fontSize: 14), // Ubah gaya teks agar kompatibel
            ),
            const SizedBox(height: 8),
            Text(
              judul,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              deskripsi,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: descriptionColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}