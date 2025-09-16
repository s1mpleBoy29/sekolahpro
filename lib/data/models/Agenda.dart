// data/models/Agenda.dart

class AgendaListResponse {
  final List<AgendaDetail> lists;
  final int totalList;
  final int totalPage;

  AgendaListResponse({
    required this.lists,
    required this.totalList,
    required this.totalPage,
  });

  factory AgendaListResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> message = json['message'] ?? {};
    final List<dynamic> agendaItems = message['lists'] ?? [];

    return AgendaListResponse(
      lists: agendaItems
          .map((item) => AgendaDetail.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalList: message['total_list'] ?? 0,
      totalPage: message['total_page'] ?? 0,
    );
  }
}

class AgendaDetail {
  final String? id; // Tambahkan field id
  final DateTime date;
  final String from;
  final String to;
  final String detail;

  AgendaDetail({
    this.id,
    required this.date,
    required this.from,
    required this.to,
    required this.detail,
  });

  factory AgendaDetail.fromJson(Map<String, dynamic> json) {
    // Ambil note mentah
    final String rawNote = json['note'] ?? '';

    // Parse tanggal — gunakan tryParse untuk aman
    final String rawDate = json['date'] ?? '';
    final DateTime parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();

    return AgendaDetail(
      id: json['name'] ?? json['id'], // Ambil ID dari field 'name' atau 'id'
      date: parsedDate,
      from: json['staff_name'] ?? 'Tidak diketahui',
      to: json['party_name'] ?? 'Tidak diketahui',
      detail: rawNote,
    );
  }
}

// Helper untuk menghapus tag HTML dan beberapa entitas umum.
String _removeHtmlTags(String htmlString) {
  if (htmlString.isEmpty) return '';

  // Hapus tag HTML
  final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
  String text = htmlString.replaceAll(exp, '');

  // Ganti entitas HTML umum
  text = text.replaceAll('&nbsp;', ' ');
  text = text.replaceAll('&amp;', '&');
  text = text.replaceAll('&lt;', '<');
  text = text.replaceAll('&gt;', '>');
  // Trim ekstra spasi
  return text.replaceAll(RegExp(r'\s+'), ' ').trim();
}