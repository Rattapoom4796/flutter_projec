import 'package:flutter/material.dart';
import 'package:flutterpro/models/course_model.dart';
import 'package:flutterpro/controller/auth_service.dart';
import 'package:flutterpro/page/CourseDetailPage.dart';
import 'package:flutterpro/page/login.dart'; // Import your login page
import 'package:flutterpro/page/admin_page.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  _GuestPageState createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  final AuthService authService = AuthService();
  List<Course> courses = [];
  List<String> years = [];
  String? selectedYear;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final fetchCourses = await authService.fetchCourses();
    setState(() {
      courses = fetchCourses;
      years = fetchCourses
          .map((course) => course.date.year.toString())
          .toSet()
          .toList()
        ..sort();

      years.insert(0, 'ทั้งหมด');
      isLoading = false;
    });
  }

  List<Course> getFilteredCourses() {
    if (selectedYear == null || selectedYear == 'ทั้งหมด') {
      return courses;
    }
    return courses
        .where((course) => course.date.year.toString() == selectedYear)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses = getFilteredCourses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
        backgroundColor: const Color.fromARGB(255, 146, 209, 238),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginForm()),
              );
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white, // Change the text color to white
                fontSize: 16, // Adjust the font size as needed
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButton<String>(
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
                ),
                Expanded(
                  child: filteredCourses.isEmpty
                      ? const Center(
                          child: Text('No courses available',
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
                                        'วันที่: ${course.date.toLocal().toIso8601String().split('T')[0]}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    Text('เวลา: ${course.time}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    const SizedBox(height: 12),
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 142, 223, 248),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
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
    );
  }
}
