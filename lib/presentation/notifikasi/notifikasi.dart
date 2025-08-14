import 'package:flutter/material.dart';
import 'package:guardian_app/presentation/notifikasi/notifikasicard.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  // Data statis notif
  final List<Map<String, String>> notifications = [
    {
      'tanggal': '10 Juli 2025 08.30',
      'judul': 'Uang Sekolah Candra Bulan Juli Tahun Ajaran 2025 / 2026 sudah melewati batas pembayaran',
      'deskripsi': '',
    },
    {
      'tanggal': '1 Juli 2025 09.30',
      'judul': 'Pembayaran Uang Seragam Candra Tahun Ajaran 2025 / 2026 sudah diterima',
      'deskripsi': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text(
          "Notifikasi",
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
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return NotificationCard(
            tanggal: notif['tanggal']!,
            judul: notif['judul']!,
            deskripsi: notif['deskripsi']!,
          );
        },
      ),
    );
  }
}
