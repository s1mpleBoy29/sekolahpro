class Ad {
  final String imageUrl;
  final String text;

  Ad({required this.imageUrl, required this.text});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      imageUrl: json['banner'] ?? '',
      text: json['keyword'] ?? '',
    );
  }
}
