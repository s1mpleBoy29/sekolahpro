import 'package:flutter/material.dart';
import 'package:guardian_app/data/api/notifikasi.dart';
import 'package:guardian_app/data/models/notifikasi.dart';
import 'package:guardian_app/routes/app_routes.dart';
import 'package:guardian_app/widgets/notifikasicard.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late Future<NotificationListResponse?> futureNotifications;

  @override
  void initState() {
    super.initState();
    futureNotifications = fetchNotifications();
  }

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
      body: FutureBuilder<NotificationListResponse?>(
        future: futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Tidak ada notifikasi"));
          }

          final notifications = snapshot.data!.lists;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return NotificationCard(
                // Menggunakan properti 'creation' dari model NotificationDetail
                // Sesuaikan format tanggal jika diperlukan
                tanggal: notif.creation.toLocal().toString().split(' ')[0], 
                judul: notif.subject,
                // Menggunakan 'subject' sebagai 'deskripsi'
                // atau Anda bisa menggunakan notif.name jika relevan
                deskripsi: notif.subject, 
                isRead: notif.isRead,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.detailNotifikasiScreen,
                    arguments: notif,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Tambahkan properti onTap ke widget NotificationCard.
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