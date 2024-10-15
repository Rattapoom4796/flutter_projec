import 'package:flutter/material.dart';
import 'package:flutterpro/models/course_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutterpro/controller/auth_service.dart';
import 'package:intl/intl.dart';

class Admin_EditCoursePage extends StatefulWidget {
  final Course course;

  const Admin_EditCoursePage({Key? key, required this.course})
      : super(key: key);

  @override
  _Admin_EditCoursePageState createState() => _Admin_EditCoursePageState();
}

class _Admin_EditCoursePageState extends State<Admin_EditCoursePage> {
  final _formKey = GlobalKey<FormState>();
  late String courseName;
  late String courseDetail;
  late String coursePlace;
  late String courseTopic;
  late int peopleCount;
  late DateTime date;
  late String time;
  String? _image;

  final List<String> coursePlaces = ['พัทลุง', 'สงขลา'];

  @override
  void initState() {
    super.initState();
    courseName = widget.course.courseName;
    courseDetail = widget.course.courseDetail;
    coursePlace = widget.course.coursePlace;
    courseTopic = widget.course.courseTopic;
    peopleCount = widget.course.peopleCount;
    date = widget.course.date;
    time = widget.course.time;
    //_image = widget.course.image;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile.path;
      });
    }
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      Course updatedCourse = Course(
        id: widget.course.id,
        courseName: courseName,
        courseDetail: courseDetail,
        coursePlace: coursePlace,
        courseTopic: courseTopic,
        peopleCount: peopleCount,
        date: date,
        time: time,
        createdAt: DateTime.now(), // Set createdAt to current time
        updatedAt: DateTime.now(), // Set updatedAt to current time
        // image: _image, // Uncomment and handle image upload if needed
      );
      try {
        await AuthService().updateCourse(updatedCourse, context);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถบันทึกการเปลี่ยนแปลง: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(time.split(':')[0]),
        minute: int.parse(time.split(':')[1]),
      ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        time =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขหลักสูตร: ${widget.course.courseName}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: courseName,
                  decoration: const InputDecoration(labelText: 'ชื่อหลักสูตร'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อหลักสูตร';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    courseName = value;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: courseDetail,
                  decoration:
                      const InputDecoration(labelText: 'รายละเอียดหลักสูตร'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    courseDetail = value;
                  },
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: coursePlace.isNotEmpty
                      ? coursePlace
                      : null, // ตรวจสอบว่ามีค่าเริ่มต้น
                  decoration: const InputDecoration(labelText: 'วิทยาเขต'),
                  items: coursePlaces.map((String place) {
                    return DropdownMenuItem<String>(
                      value: place, // ให้ค่าเป็นค่าที่ซ้ำได้
                      child: Text(place),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      coursePlace =
                          value ?? ''; // ตั้งค่าเป็นค่าว่างหาก value เป็น null
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // ตรวจสอบว่าเลือกค่าแล้ว
                      return 'กรุณาเลือกวิทยาเขต';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: courseTopic,
                  decoration:
                      const InputDecoration(labelText: 'หัวข้อหลักสูตร'),
                  onChanged: (value) {
                    courseTopic = value;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: peopleCount.toString(),
                  decoration: const InputDecoration(labelText: 'จำนวนคน'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนคน';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    peopleCount = int.tryParse(value) ?? 0;
                  },
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "วันที่:  ${DateFormat('dd-MM-yyyy').format(date)}",
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('เลือกวัน'),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "เวลา: $time", // แสดงเวลา
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectTime(context),
                      child: const Text('เลือกเวลา'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: _pickImage,
                //   child: const Text('เลือกรูปภาพจาก Gallery'),
                // ),
                // SizedBox(height: 20),
                // _image == null
                //     ? const Text('ยังไม่มีรูปภาพที่เลือก.')
                //     : Image.file(File(_image!)),
                // SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('บันทึกการเปลี่ยนแปลง'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
