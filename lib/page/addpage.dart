import 'package:flutter/material.dart';
import 'package:flutterpro/models/course_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutterpro/controller/auth_service.dart';

class Admin_AddCoursePage extends StatefulWidget {
  const Admin_AddCoursePage({Key? key}) : super(key: key);

  @override
  _Admin_AddCoursePageState createState() => _Admin_AddCoursePageState();
}

class _Admin_AddCoursePageState extends State<Admin_AddCoursePage> {
  final _formKey = GlobalKey<FormState>();
  String courseName = '';
  String courseDetail = '';
  String coursePlace = '';
  String courseTopic = '';
  int peopleCount = 0;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String? _image;

  final List<String> coursePlaces = ['พัทลุง', 'สงขลา'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile.path;
      });
    }
  }

  void _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      Course newCourse = Course(
        id: '', // Generate a unique ID if needed
        courseName: courseName,
        courseDetail: courseDetail,
        coursePlace: coursePlace,
        courseTopic: courseTopic,
        peopleCount: peopleCount,
        date: date,
        time:
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        createdAt: DateTime.now(), // Set createdAt to the current time
        updatedAt: DateTime.now(), // Set updatedAt to the current time
        // image: _image, // Uncomment and handle image upload if needed
      );

      try {
        await AuthService().addCourse(newCourse, context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course added successfully!')),
        );
        Navigator.pop(
            context, true); // Pass true to indicate a successful addition
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add course: $e')),
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
      initialTime: time,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Course'),
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
                  decoration: const InputDecoration(labelText: 'ชื่อหลักสูตร'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ชื่อหลักสูตร';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    courseName = value;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'รายละเอียดหลักสูตร'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่รายละเอียดหลักสูตร';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    courseDetail = value;
                  },
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: coursePlace.isEmpty ? null : coursePlace,
                  decoration: const InputDecoration(labelText: 'วิทยาเขต'),
                  items: coursePlaces.map((String place) {
                    return DropdownMenuItem<String>(
                      value: place,
                      child: Text(place),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      coursePlace = value ?? ''; // เก็บค่าที่เลือก
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'กรุณาเลือกวิทยาเขต';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'หัวข้อหลักสูตร'),
                  onChanged: (value) {
                    courseTopic = value;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'จำนวนคน'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่จำนวนคน';
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "เวลา: ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}", // แสดงเวลา
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
                //     ? const Text('No image selected.')
                //     : Image.file(File(_image!)),
                //SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveCourse,
                  child: const Text('Save Course'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
