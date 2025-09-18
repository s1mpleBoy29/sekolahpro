import 'dart:convert';

class Student {
  final String name;
  // final String sid;
  final String fullName;
  // final String gender;
  // final String placeOfBirth;
  // final String dateOfBirth;
  // final String address;
  // final String city;
  // final String province;
  // final String status;
  final String organization;
  final String school;
  final String schoolName;
  final String grade; // kelas
  final String gradeName; // kelas
  final String academicYear;
  final String academicYearName;

  Student({
    required this.name,
    // required this.sid,
    required this.fullName,
    // required this.gender,
    // required this.placeOfBirth,
    // required this.dateOfBirth,
    // required this.address,
    // required this.city,
    // required this.province,
    // required this.status,
    required this.organization,
    required this.school,
    required this.schoolName,
    required this.grade,
    required this.gradeName,
    required this.academicYear,
    required this.academicYearName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json["name"] ?? "",
      // sid: json["sid"] ?? "",
      fullName: json["full_name"] ?? "",
      // gender: json["gender"] ?? "",
      // placeOfBirth: json["place_of_birth"] ?? "",
      // dateOfBirth: json["date_of_birth"] ?? "",
      // address: json["address"] ?? "",
      // city: json["city"] ?? "",
      // province: json["province"] ?? "",
      // status: json["status"] ?? "",
      organization: json["organization"] ?? "",
      school: json["school"] ?? "",
      schoolName: json["school_name"] ?? "",
      grade: json["grade"] ?? "",
      gradeName: json["grade_name"] ?? "",
      academicYear: json["academic_year"] ?? "",
      academicYearName: json["academic_year_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      // "sid": sid,
      "full_name": fullName,
      // "gender": gender,
      // "place_of_birth": placeOfBirth,
      // "date_of_birth": dateOfBirth,
      // "address": address,
      // "city": city,
      // "province": province,
      // "status": status,
      "organization": organization,
      "school": school,
      "school_name": schoolName,
      "grade": grade,
      "grade_name": gradeName,
      "academic_year": academicYear,
      "academic_year_name": academicYearName,
    };
  }

  static List<Student> fromJsonList(String jsonString) {
    final data = json.decode(jsonString);
    return (data["data"] as List).map((e) => Student.fromJson(e)).toList();
  }
}
