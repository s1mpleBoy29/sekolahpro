import 'dart:convert';

class ModeOfPayment {
  final String name;
  final String method;
  final String transferAccount;
  final String transferName;

  ModeOfPayment({
    required this.name,
    required this.method,
    required this.transferAccount,
    required this.transferName,
  });

  factory ModeOfPayment.fromJson(Map<String, dynamic> json) {
    print('Parsing School model from JSON: $json');
    return ModeOfPayment(
      name: json["name"] ?? "",
      method: json["method"] ?? "",
      transferAccount: json["custom_transfer_account"] ?? "",
      transferName: json["custom_transfer_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "method": method,
      "custom_transfer_account": transferAccount,
      "custom_transfer_name": transferName,
    };
  }

  static List<ModeOfPayment> fromJsonList(String jsonString) {
    final data = json.decode(jsonString);
    return (data["data"] as List)
        .map((e) => ModeOfPayment.fromJson(e))
        .toList();
  }
}
