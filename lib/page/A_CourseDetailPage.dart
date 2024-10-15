import 'package:flutter/material.dart';
import 'package:flutterpro/models/course_model.dart';

class Admin_CourseDetailPage extends StatelessWidget {
  final Course course;

  const Admin_CourseDetailPage({Key? key, required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.courseName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ชื่อหลักสูตร: ${course.courseName}',
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('หัวข้อ: ${course.courseTopic}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('รายละเอียด: ${course.courseDetail}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('วิทยาเขต: ${course.coursePlace}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('จำนวนคน: ${course.peopleCount}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
                'วันที่: ${course.date.toLocal().toIso8601String().split('T')[0]}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('เวลา: ${course.time}', style: TextStyle(fontSize: 16)),
            // เพิ่มข้อมูลเพิ่มเติมที่ต้องการแสดงที่นี่
          ],
        ),
      ),
    );
  }
}
