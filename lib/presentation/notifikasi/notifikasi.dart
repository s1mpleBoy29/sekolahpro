// screens/notification_list_screen.dart

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
  // Gunakan List<NotificationDetail> untuk menyimpan data yang bisa diubah
  List<NotificationDetail> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAndSetNotifications();
  }

  // Fungsi asinkron untuk mengambil data notifikasi dari API
  Future<void> _fetchAndSetNotifications() async {
    try {
      final response = await fetchNotifications();
      if (response != null) {
        // Jika berhasil, perbarui state dengan data notifikasi
        setState(() {
          _notifications = response.lists;
          _isLoading = false;
        });
      } else {
        // Tangani kasus ketika respons null
        setState(() {
          _errorMessage = "Gagal memuat notifikasi. Coba lagi.";
          _isLoading = false;
        });
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau parsing
      setState(() {
        _errorMessage = "Terjadi kesalahan: $e";
        _isLoading = false;
      });
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _notifications.isEmpty
                  ? const Center(child: Text("Tidak ada notifikasi"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notif = _notifications[index];
                        return NotificationCard(
                          tanggal: notif.creation.toLocal().toString().split(' ')[0],
                          judul: notif.subject,
                          deskripsi: notif.subject,
                          isRead: notif.isRead,
                          onTap: () {
                            // Perbarui status notifikasi di dalam state
                            setState(() {
                              notif.isRead = true;
                            });

                            // Pindah ke halaman detail notifikasi
                            Navigator.pushNamed(
                              context,
                              AppRoutes.detailNotifikasiScreen,
                              arguments: notif,
                            );
                          },
                        );
                      },
                    ),
    );
  }
}