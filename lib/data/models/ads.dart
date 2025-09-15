class Ads {
  final String name;
  final String start;
  final String end;
  final String title;
  final String size;
  final String image;

  Ads({
    required this.name,
    required this.start,
    required this.end,
    required this.title,
    required this.size,
    required this.image,
  });

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
      name: json["name"] ?? "",
      start: json["aired_at"] ?? "",
      end: json["aired_until"] ?? "",
      title: json["title"] ?? "",
      size: json["size"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "start": start,
      "end": end,
    };
  }
}
