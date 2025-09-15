class Ad {
  final String imageUrl;
  final String text;
  final String url;

  Ad({
    required this.imageUrl,
    required this.text,
    required this.url,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      imageUrl: json['banner'] ?? '',
      text: json['keyword'] ?? '',
      url: json['link'] ?? '',
    );
  }
}
