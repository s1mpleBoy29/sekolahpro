import 'package:flutter/material.dart';
import 'package:guardian_app/data/models/ad.dart';

class AdCard extends StatelessWidget {
  final Ad ad;
  const AdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(0),
      ),
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
    );
  }
}
