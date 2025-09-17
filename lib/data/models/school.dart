import 'dart:convert';

class School {
  final String name;
  final String schoolName;
  final String phone;
  final String email;
  final String whatsapp;
  final String address;
  final String city;
  final String province;
  final String map;

  School({
    required this.name,
    required this.schoolName,
    required this.phone,
    required this.email,
    required this.whatsapp,
    required this.address,
    required this.city,
    required this.province,
    required this.map,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    print('Parsing School model from JSON: $json');
    return School(
      name: json["name"] ?? "",
      schoolName: json["school_name"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      whatsapp: json["whatsapp"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      province: json["province"] ?? "",
      map: json["map"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "school_name": schoolName,
      "phone": phone,
      "email": email,
      "whatsapp": whatsapp,
      "address": address,
      "city": city,
      "province": province,
      "map": map,
    };
  }

  static List<School> fromJsonList(String jsonString) {
    final data = json.decode(jsonString);
    return (data["data"] as List).map((e) => School.fromJson(e)).toList();
  }
}
