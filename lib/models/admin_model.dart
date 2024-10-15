// To parse this JSON data, do
//
//     final admin = adminFromJson(jsonString);

import 'dart:convert';

Admin adminFromJson(String str) => Admin.fromJson(json.decode(str));

String adminToJson(Admin data) => json.encode(data.toJson());

class Admin {
  AdminClass admin;
  String accessToken;
  String refreshToken;

  Admin({
    required this.admin,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        admin: AdminClass.fromJson(json["admin"]),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "admin": admin.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}

class AdminClass {
  String id;
  String userName;
  DateTime createdAt;
  DateTime updatedAt;

  AdminClass({
    required this.id,
    required this.userName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminClass.fromJson(Map<String, dynamic> json) => AdminClass(
        id: json["_id"],
        userName: json["user_name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_name": userName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
