import 'package:flutter/material.dart';
import 'package:guardian_app/data/api/notifikasi.dart';
import 'package:guardian_app/data/models/notifikasi.dart';

class NotificationDetailScreen extends StatefulWidget {
  const NotificationDetailScreen({Key? key}) : super(key: key);

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  NotificationDetail? notificationArgs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ambil argumen yang dikirim saat navigasi
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is NotificationDetail) {
      setState(() {
        notificationArgs = args;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Periksa apakah data notifikasi sudah tersedia
    if (notificationArgs == null) {
      // Tampilkan loading indicator atau pesan jika data belum siap
      return Scaffold(
        backgroundColor: Colors.white, // Latar belakang putih
        appBar: AppBar(
          title: const Text(
            'Detail Notifikasi',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Teks hitam
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black), // Ikon hitam
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Gunakan data notifikasi yang sudah diterima
    final notif = notificationArgs!;
    String formattedDate = notif.creation.toLocal().toString().split(' ')[0];
    String formattedTime = notif.creation.toLocal().toString().split(' ')[1].split('.')[0];

    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      appBar: AppBar(
        title: const Text(
          'Detail Notifikasi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Teks hitam
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black), // Ikon hitam
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipe Notifikasi
            Text(
              notif.type,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey, // Warna abu-abu untuk tipe
              ),
            ),
            const SizedBox(height: 8),

            // Judul Notifikasi
            Text(
              notif.subject,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Teks hitam
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal dan Waktu
            Text(
              'Tanggal: $formattedDate',
              style: const TextStyle(fontSize: 16, color: Colors.black87), // Teks hitam
            ),
            const SizedBox(height: 4),
            Text(
              'Waktu: $formattedTime',
              style: const TextStyle(fontSize: 16, color: Colors.black87), // Teks hitam
            ),
            const SizedBox(height: 24),

            const Text(
              'Detail Pesan:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Teks hitam
              ),
            ),
            const SizedBox(height: 8),
            // Menggunakan notif.subject sebagai pengganti 'description'
            // Sesuaikan jika model NotificationDetail Anda memang memiliki properti description
            Text(
              "Notifikasi ID: ${notif.name}\nStatus: ${notif.isRead ? 'Sudah dibaca' : 'Belum dibaca'}\n\n${notif.subject}",
              style: const TextStyle(fontSize: 16, color: Colors.black87), // Teks hitam
            ),
          ],
        ),
      ),
    );
  }
}