import 'package:flutter/material.dart';
import 'package:school_attendance_system_fyp/view/attendanceMonitoringResult.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/parentGuardian.dart';
import '../model/student.dart';
import 'homePage.dart';
import 'login.dart';


class attendanceMonitoring extends StatefulWidget {
  const attendanceMonitoring({super.key});

  @override
  _AttendanceMonitoringState createState() => _AttendanceMonitoringState();
}

class _AttendanceMonitoringState extends State<attendanceMonitoring> {

  final List<Student> children = [];
  late final parentGuardian parent;
  String base64String = "";
  String compressData = "";
  String fileName = "";
  String uploadDate = "";
  int? parent_id = 0;
  int year = 0;
  int? selectedTeacher_id = 0;

  int? student_id=0;
  String? classroom="";
  String ? name ="";

  Student? selectedStudent;

  TextEditingController nameController = TextEditingController();


  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final prefs = await SharedPreferences.getInstance();
      _loadData();
    });
  }

  // Method to load data
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    parent_id = prefs.getInt('id') as int?;
    print("Parent ID: ${parent_id}");

    Student child = Student.findChild(parent_id);
    final List<Student> fetchedData = await child.loadChildren(parent_id);

    setState(() {
      children.clear(); // Clear existing data
      children.addAll(fetchedData); // Add fetched data
    });
  }


  Future<Map<String?, dynamic?>> _getNameFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('nickname') as String?;
    int? parentGuardianId = prefs.getInt('id') as int?;
    return {'nickname': name, 'parent_guardian_id': parentGuardianId};
  }

  void _checkAdmin() async {

    // Save data to SharedPreferences
    final monitor = await SharedPreferences.getInstance();
    await monitor.setInt('student_id', student_id ?? 0);
    await monitor.setString('classroom', classroom ?? '');
    await monitor.setString('childname', name ?? '');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => attendanceMonitoringResult()), // Instantiate StartPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: const Center(
          child: Text(
            '',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0),
          ),
        ),
        backgroundColor: Colors.indigo.shade900,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Replace HomePage with your actual HomePage widget
          );
        }, icon: Icon(Icons.home, color: Colors.white),),
        actions: [
          FutureBuilder<Map<String?, dynamic?>>(
            future: _getNameFromSharedPrefs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final name = snapshot.data?['nickname'] as String?;
                return Row(
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: [
                          DropdownMenuItem(
                            value: 'profile',
                            child: Text('Profile'),
                          ),
                          DropdownMenuItem(
                            value: 'logout',
                            child: Text('Logout'),
                          ),
                        ],
                        onChanged: (value) {
                          // Handle menu item selection
                          switch (value) {
                            case 'profile':
                            // Navigate to profile page
                              break;
                            case 'logout':
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => SignIn()), // Replace SignIn with your actual SignIn page widget
                              );
                              break;
                          }
                        },
                        hint: Text(
                          name ?? '',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0, // Adjusted positioning
              left: -50,
              right: -50,
              child: ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: 10,
                  color: Colors.indigo.shade900,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              width: double.infinity, // Cover entire width of the screen
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    right: -19,
                    top: 85,
                    child: CustomPaint(
                      size: const Size(110, 110),
                      painter: CirclePainter(Colors.blue.shade100),
                    ),
                  ),
                  Positioned(
                    left: -15,
                    bottom: 100,
                    child: CustomPaint(
                      size: const Size(110, 110),
                      painter: CirclePainter(Colors.blue.shade100),
                    ),
                  ),
                  Positioned(
                    right: -35,
                    bottom: 10,
                    child: CustomPaint(
                      size: const Size(140, 140),
                      painter: CirclePainter(Colors.blue.shade100),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the table vertically
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'Attendance Monitor',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 80),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '     Username',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Center(
                              child: Container(
                                width: 330,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Student>(
                                    value: selectedStudent, // State variable for selected student
                                    onChanged: (Student? newValue) {
                                      setState(() {
                                        selectedStudent = newValue;
                                        student_id = newValue!.id ?? 0;
                                        classroom = newValue!.kelas!.form_number!.toString() + " "+newValue!.kelas!.name!;
                                        name = newValue!.name ?? '';
                                        print ("DIA PUNYA CLASS : ${classroom}");
                                        print("Student ID Chosen: ${student_id}");
                                      });
                                    },
                                    items: children.map<DropdownMenuItem<Student>>((children) {
                                      return DropdownMenuItem<Student>(
                                        value: children,
                                        child: Text(children.name??''),

                                      );
                                    }).toList(),
                                    hint: Text(
                                      'Select a student',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 120),
                        ElevatedButton(
                          onPressed: _checkAdmin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo.shade800,
                          ),
                          child: const Text('Check',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color color;

  CirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 40, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
