import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:guardian_app/core/app_export.dart';

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

  String cleanHtml(String rawHtml) {
    return rawHtml
        .replaceAll(
            RegExp(r'&nbsp;'), ' ') // ubah non-breaking space jadi biasa
        .replaceAll(RegExp(r'<p><br></p>'), '') // hapus paragraf kosong
        .replaceAll(RegExp(r'\s+'), ' ') // rapikan spasi berlebih
        .trim();
  }

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
          color: theme.colorScheme.surface,
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
            Html(
              data: cleanHtml(detail),
              style: {
                "p": Style(
                  fontSize: FontSize(16),
                  margin: Margins.symmetric(
                      vertical: 4), // jarak antar paragraf kecil
                  padding: HtmlPaddings.zero,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                "strong": Style(
                  fontWeight: FontWeight.bold,
                  color: Colors.red, // bisa override warna bold
                ),
              },
            ),
            // Text(
            //   detail,
            //   style: TextStyle(
            //     color: theme.colorScheme.onPrimaryContainer,
            //     fontSize: 16,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
