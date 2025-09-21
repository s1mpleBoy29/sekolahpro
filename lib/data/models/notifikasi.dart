// data/models/notification.dart

class NotificationListResponse {
  final List<NotificationDetail> lists;
  final int totalList;
  final int totalPage;

  NotificationListResponse({
    required this.lists,
    required this.totalList,
    required this.totalPage,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> message = json['message'] ?? {};
    final List<dynamic> notificationItems = message['lists'] ?? [];

    return NotificationListResponse(
      lists: notificationItems
          .map((item) => NotificationDetail.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalList: message['total_list'] ?? 0,
      totalPage: message['total_page'] ?? 0,
    );
  }
}

class NotificationDetail {
  final String name; // ID unik notifikasi
  final String subject; // Judul/subjek notifikasi
  final String type; // Tipe notifikasi (misalnya 'Alert')
  final DateTime creation; // Waktu pembuatan notifikasi
  bool isRead; // Status baca

  NotificationDetail({
    required this.name,
    required this.subject,
    required this.type,
    required this.creation,
    required this.isRead,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) {
    // Parse tanggal
    final String rawDate = json['creation'] ?? '';
    final DateTime parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();

    // Konversi status 'read' (0 atau 1) menjadi boolean
    final int readStatus = json['read'] ?? 0;
    final bool isRead = readStatus == 1; // 1 berarti true (sudah dibaca)

    return NotificationDetail(
      name: json['name'] ?? '',
      subject: json['subject'] ?? 'Tidak ada subjek',
      type: json['type'] ?? 'Info',
      creation: parsedDate,
      isRead: isRead,
    );
  }
}