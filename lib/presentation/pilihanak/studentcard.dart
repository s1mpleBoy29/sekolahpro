import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart'; // Untuk mengakses theme dan appTheme
import 'package:guardian_app/widgets/custom_elevated_button.dart'; // Untuk tombol 'Pilih'

class StudentCard extends StatelessWidget {
  final String studentName;
  final String schoolName;
  final String className;
  final VoidCallback onSelectPressed; // Callback saat tombol 'Pilih' ditekan
  final String? avatarImagePath; // Opsional: Path ke gambar avatar siswa

  const StudentCard({
    super.key,
    required this.studentName,
    required this.schoolName,
    required this.className,
    required this.onSelectPressed,
    this.avatarImagePath, // Avatar image path
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Gaya Container mirip dengan DueCard/AgendaCard
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8), // Margin atas seperti DueCard/AgendaCard
      decoration: BoxDecoration(
        color: Colors.white, // Latar belakang putih
        border: Border.all(color: theme.colorScheme.outlineVariant), // Border seperti DueCard/AgendaCard
        borderRadius: BorderRadius.circular(4), // Sudut membulat seperti DueCard/AgendaCard
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan secara vertikal
        children: [
          // Bagian Kiri: Avatar/Icon Foto
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 24, // Ukuran avatar
              backgroundColor: theme.colorScheme.outlineVariant, // Warna background avatar (abu-abu terang)
              backgroundImage: avatarImagePath != null
                  ? AssetImage(avatarImagePath!) // Gunakan gambar jika path disediakan
                  : null, // Jika tidak ada path, jangan set backgroundImage
              child: avatarImagePath == null
                  ? Icon(
                      Icons.person_outline, // Ikon default jika tidak ada gambar
                      color: theme.colorScheme.onSurfaceVariant, // Warna ikon
                      size: 30,
                    )
                  : null, // Jangan tampilkan ikon jika ada gambar
            ),
          ),
          
          // Bagian Tengah: Informasi Siswa (Nama, Sekolah, Kelas)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer, // Warna teks nama
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  schoolName,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.secondary, // Warna teks sekunder (abu-abu dari tema)
                  ),
                ),
                Text(
                  className,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.secondary, // Warna teks sekunder (abu-abu dari tema)
                  ),
                ),
              ],
            ),
          ),
          
          // Bagian Kanan: Tombol 'Pilih'
          CustomElevatedButton(
            width: 80, // Lebar tombol
            height: 36, // Tinggi tombol
            text: "Pilih",
            buttonTextStyle: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onPrimary, // Warna teks tombol (putih dari tema)
            ),
            onPressed: onSelectPressed,
          ),
        ],
      ),
    );
  }
}