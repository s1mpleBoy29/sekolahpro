import 'package:flutter/material.dart';

class DetailAgenda extends StatelessWidget {
  const DetailAgenda({super.key});

  @override
  Widget build(BuildContext context) {
    // Data statis untuk sementara, sesuai dengan gambar desain
    const String tanggal = '07 Juli 2025';
    const String dari = 'Wali Kelas 5A';
    const String untuk = 'Candra Wijaya';
    const String detail =
        'Bawa alat tulis lengkap, termasuk pensil, penghapus, penggaris, dan kalkulator sederhana. Mohon diperhatikan agar tidak ada kekurangan persiapan.\n\n'
        'Ujian Matematika akan dilaksanakan pada hari Senin, 07 Juli 2025, pukul 08.00 - 10.00 di Ruang 5A.';

    return Scaffold(
      backgroundColor: Colors.white, // Menambahkan baris ini untuk memastikan latar belakang putih
      appBar: AppBar(
        title: const Text(
          "Detail Agenda",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        elevation: 1, // Memberikan sedikit bayangan
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tanggal,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Menggunakan warna hitam
                  ),
            ),
            const SizedBox(height: 24),
            // Menggunakan RichText untuk menggabungkan "Dari:" dan nama dalam satu baris
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: 'Dari: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey, // Warna abu-abu untuk "Dari"
                    ),
                  ),
                  TextSpan(
                    text: dari,
                    style: TextStyle(
                      color: Colors.black, // Warna hitam untuk nama
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Menggunakan RichText untuk menggabungkan "Untuk:" dan nama dalam satu baris
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: 'Untuk: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey, // Warna abu-abu untuk "Untuk"
                    ),
                  ),
                  TextSpan(
                    text: untuk,
                    style: TextStyle(
                      color: Colors.black, // Warna hitam untuk nama
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              detail,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black, // Warna hitam untuk detail
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
