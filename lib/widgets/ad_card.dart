import 'package:flutter/material.dart';
import 'package:guardian_app/data/models/ad.dart';
import 'package:url_launcher/url_launcher.dart';

class AdCard extends StatelessWidget {
  final Ad ad;
  const AdCard({
    super.key,
    required this.ad,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    final success = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // buka di browser
    );

    if (!success) {
      debugPrint("Gagal membuka $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ad.url.isNotEmpty) {
          _launchUrl(ad.url);
        }
      },
      child: AspectRatio(
        aspectRatio: 700 / 200, // Sesuaikan dengan proporsi hero slider
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Image.network(
            ad.imageUrl,
            width: double.infinity,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child; // Image.
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2.0),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // Ikon untuk menunjukkan jika gambar gagal dimuat.
              return const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
              );
            },
          ),
        ),
      ),
    );
  }
}
