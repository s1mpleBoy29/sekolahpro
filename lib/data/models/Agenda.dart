class AgendaDetail {
  final String name;
  final String date;
  final String from;
  final String to;
  final String detail;

  AgendaDetail({
    required this.name,
    required this.date,
    required this.from,
    required this.to,
    required this.detail,
  });

  // Factory method untuk membuat objek AgendaDetail dari data JSON
  factory AgendaDetail.fromJson(Map<String, dynamic> json) {
    return AgendaDetail(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      detail: json['detail'] ?? '',
    );
  }
}
