import 'package:flutter/material.dart';
import 'package:flutterpro/main.dart';
import 'package:flutterpro/page/guest_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutterpro/variables.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutterpro/models/course_model.dart';
import 'package:flutterpro/controller/auth_service.dart';
import 'package:flutterpro/page/CourseDetailPage.dart';
import 'package:flutterpro/page/login.dart';
import 'package:flutterpro/provider/admin_provider.dart';
import 'package:flutterpro/page/editpage.dart';
import 'package:flutterpro/page/addpage.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final AuthService authService = AuthService();
  List<Course> courses = [];
  List<String> years = []; // รายการปี
  String? selectedYear; // ปีที่เลือก
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final fetchedCourses = await authService.fetchCourses();
    setState(() {
      courses = fetchedCourses;
      years = fetchedCourses
          .map((course) => course.date.year.toString())
          .toSet()
          .toList()
        ..sort(); // สร้างรายการปี
      years.insert(0, 'ทั้งหมด'); // เพิ่มตัวเลือก "ทั้งหมด"
      isLoading = false;
    });
  }

  List<Course> getFilteredCourses() {
    if (selectedYear == null || selectedYear == '-1') {
      return courses; // แสดงหลักสูตรทั้งหมดถ้ายังไม่มีการเลือกปีหรือเลือก "ทั้งหมด"
    }
    return courses
        .where((course) => course.date.year.toString() == selectedYear)
        .toList();
  }

  void _editCourse(Course course) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Admin_EditCoursePage(course: course), // เปิดหน้า Edit
      ),
    );
    if (result == true) {
      fetchCourses(); // โหลดข้อมูลใหม่หลังจากแก้ไข
    }
  }

  void _deleteCourse(Course course) async {
    final userProvider = Provider.of<AdminProviders>(context, listen: false);
    String? token = userProvider.accessToken;
    print("accessToken: $token");

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Course'),
          content: const Text('Are you sure you want to delete this course?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await authService.deleteCourse(course, context);
        setState(() {
          courses.remove(course);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete course: $e')),
        );
      }
    }
  }

  void _addCourse() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Admin_AddCoursePage(),
      ),
    );
    if (result == true) {
      fetchCourses(); // โหลดข้อมูลใหม่หลังจากเพิ่ม
    }
  }

  void _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('ออกจากระบบ'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      // ทำการ logout
      final userProvider = Provider.of<AdminProviders>(context, listen: false);
      userProvider.onLogout();
      // หรือทำการนำทางกลับไปยังหน้า Login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const GuestPage()), // เปลี่ยนไปหน้า LoginForm
        (route) => false, // ลบเส้นทางทั้งหมดใน stack
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses = getFilteredCourses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        backgroundColor: const Color.fromARGB(255, 146, 209, 238),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // เรียกใช้ฟังก์ชัน Logout
            tooltip: 'Logout',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100, // กำหนดความกว้างของ DropdownButton
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('เลือกปี'),
                        value: selectedYear,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedYear = newValue;
                          });
                        },
                        items: years.map((String year) {
                          return DropdownMenuItem<String>(
                            value: year == 'ทั้งหมด' ? null : year,
                            child: Text(year),
                          );
                        }).toList(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(
                        width: 50), // เพิ่มระยะห่างระหว่าง Dropdown และ Icon
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addCourse,
                      tooltip: 'Add New Course',
                    ),
                  ],
                ),
                Expanded(
                  child: filteredCourses.isEmpty
                      ? const Center(
                          child: Text('ไม่มีหลักสูตร',
                              style: TextStyle(fontSize: 18)),
                        )
                      : ListView.builder(
                          itemCount: filteredCourses.length,
                          itemBuilder: (context, index) {
                            final course = filteredCourses[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(course.courseName,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 5, 30, 248))),
                                    const SizedBox(height: 8),
                                    Text('หัวข้อ: ${course.courseTopic}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    Text('วิทยาเขต: ${course.coursePlace}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    Text('${course.peopleCount} คน',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    Text(
                                        'วันที่: ${DateFormat('dd-MM-yyyy').format(course.date)}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    Text('เวลา: ${course.time} น.',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CourseDetailPage(
                                                          course: course)),
                                            );
                                          },
                                          child: const Text('More Detail'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 142, 223, 248),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () =>
                                                  _editCourse(course),
                                              color: Colors.blue,
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () =>
                                                  _deleteCourse(course),
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       IconButton(
      //         icon: const Icon(Icons.add),
      //         onPressed: _addCamp, // เรียกใช้ฟังก์ชันเพิ่มค่าย
      //         tooltip: 'Add New Camp',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
