import 'package:flutter/material.dart';

class DetailAgenda extends StatelessWidget {
  const DetailAgenda({super.key});

  @override
  Widget build(BuildContext context) {
    // Untuk sementara, data diisi dengan teks statis.
    // Ini menghilangkan kebutuhan untuk menerima parameter saat inisialisasi.
    const String tanggal = 'Selasa, 12 Agustus 2024';
    const String dari = 'Guru Wali Kelas';
    const String untuk = 'Wali Murid Kelas 7A';
    const String detail = 
      'Rapat koordinasi persiapan Ujian Tengah Semester (UTS) '
      'akan diadakan di ruang serbaguna sekolah. Mohon kehadiran '
      'seluruh wali murid untuk membahas jadwal, materi, dan '
      'persiapan teknis lainnya.';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Agenda"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tanggal,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              "Dari :",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dari,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            Text(
              "Untuk :",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              untuk,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            Text(
              "Detail Agenda :",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              detail,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
