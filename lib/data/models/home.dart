class Home {
  final Map<String, dynamic>? tuitions;
  final List<dynamic>? agendas;
  final String? today;

  Home({
    this.tuitions,
    this.agendas,
    this.today,
  });

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      tuitions: json['tuitions'] ?? {},
      agendas: json['agendas'] ?? [],
      today: json['today'] ?? '',
    );
  }
}
