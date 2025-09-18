import 'dart:convert';

class Bill {
  final String plan;
  final String academicYear;
  final String dueDate;
  final String remark;
  final double amount;
  final double outstanding;

  Bill({
    required this.plan,
    required this.academicYear,
    required this.dueDate,
    required this.remark,
    required this.amount,
    required this.outstanding,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    print('Parsing School model from JSON: $json');
    return Bill(
      plan: json["tuition_plan"] ?? "",
      academicYear: json["academic_year"] ?? "",
      dueDate: json["due_date"] ?? "",
      remark: json["remark"] ?? "",
      amount: json["amount"] ?? 0.0,
      outstanding: json["outstanding"] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tuition_plan": plan,
      "academic_year": academicYear,
      "due_date": dueDate,
      "remark": remark,
      "amount": amount,
      "outstanding": outstanding,
    };
  }

  static List<Bill> fromJsonList(String jsonString) {
    final data = json.decode(jsonString);
    return (data["data"] as List).map((e) => Bill.fromJson(e)).toList();
  }
}
