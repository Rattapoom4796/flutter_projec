import 'package:flutter/material.dart';
import 'package:flutterpro/provider/admin_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutterpro/models/admin_model.dart';
import 'package:flutterpro/models/course_model.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutterpro/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AuthService {
  Future<List<Course>> fetchCourses() async {
    try {
      final response = await http.get(Uri.parse("$apiURL/api/courses"));
      print("Fetching courses from: $apiURL/api/courses");
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((course) => Course.fromJson(course)).toList();
      } else {
        print(
            'Error: ${response.statusCode} - ${response.body}'); // Log the error response
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Error fetching courses: $e'); // Log the error
      return [];
    }
  }

  Future<Admin> login(String userName, String password) async {
    print(apiURL);
    try {
      final response = await http.post(
        Uri.parse("$apiURL/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_name": userName,
          "password": password,
        }),
      );

      print(response.statusCode);

      // Check the response status code first
      if (response.statusCode == 200) {
        // Only decode if the status code is 200
        final responseBody = jsonDecode(response.body);
        return Admin.fromJson(responseBody);
      } else {
        // Handle errors based on the status code
        String errorMessage;
        if (response.headers['content-type']?.contains('application/json') ==
            true) {
          final responseBody = jsonDecode(response.body);
          errorMessage = responseBody['message'] ?? 'Unknown error';
        } else {
          errorMessage = 'Unexpected response format: ${response.body}';
        }
        throw Exception('Failed to login: $errorMessage');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> deleteCourse(Course course, BuildContext context) async {
    final adminProvider = Provider.of<AdminProviders>(context, listen: false);
    final token = adminProvider.accessToken; // เข้าถึง token

    try {
      final response = await http.delete(
        Uri.parse("$apiURL/api/course/${course.id}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      // ตรวจสอบรหัสสถานะการตอบสนอง
      if (response.statusCode == 200 || response.statusCode == 204) {
        // การลบสำเร็จ
        print('Course deleted successfully');
      } else {
        // ถ้ามีการตอบสนองที่ไม่ถูกต้อง
        print('Response body: ${response.body}');
        final errorMessage =
            response.body; // ดึงข้อความข้อผิดพลาดจากเซิร์ฟเวอร์
        throw Exception('Failed to delete course: $errorMessage');
      }
    } catch (e) {
      // แจ้งข้อผิดพลาด
      throw Exception('Failed to delete course: $e');
    }
  }

  Future<void> updateCourse(Course course, BuildContext context) async {
    final adminProvider = Provider.of<AdminProviders>(context, listen: false);
    final token = adminProvider.accessToken;
    print(courseToJson(course));
    final response = await http.put(
      Uri.parse('$apiURL/api/course/${course.id}'), // แทนที่ด้วย URL ที่ถูกต้อง
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token"
        // หากจำเป็นต้องมีการจัดการ token สำหรับการเข้าใช้งาน ให้เพิ่มที่นี่
      },
      body: courseToJson(course),
      // แปลง Course object เป็น JSON
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update course');
    }
  }

  Future<void> addCourse(Course course, BuildContext context) async {
    final adminProvider = Provider.of<AdminProviders>(context, listen: false);
    final token = adminProvider.accessToken;

    try {
      final response = await http.post(
        Uri.parse("$apiURL/api/course"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: courseToJson(course), // แปลง Course object เป็น JSON
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add course');
      }
    } catch (e) {
      throw Exception('Failed to add course: $e');
    }
  }
}
