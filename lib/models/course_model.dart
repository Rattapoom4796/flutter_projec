import 'dart:convert';

Course courseFromJson(String str) => Course.fromJson(json.decode(str));

String courseToJson(Course data) => json.encode(data.toJson());

class Course {
  String courseName;
  String courseDetail;
  String coursePlace;
  String courseTopic;
  int peopleCount;
  DateTime date;
  String time;
  String id;
  DateTime createdAt;
  DateTime updatedAt;

  Course({
    required this.courseName,
    required this.courseDetail,
    required this.coursePlace,
    required this.courseTopic,
    required this.peopleCount,
    required this.date,
    required this.time,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        courseName: json["course_name"],
        courseDetail: json["course_detail"],
        coursePlace: json["course_place"],
        courseTopic: json["course_topic"],
        peopleCount: json["people_count"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "course_name": courseName,
        "course_detail": courseDetail,
        "course_place": coursePlace,
        "course_topic": courseTopic,
        "people_count": peopleCount,
        "date": date.toIso8601String(),
        "time": time,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
