import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/attendance.dart';
import '../Model/student.dart';
import '../model/parentGuardian.dart';
import 'homePage.dart';
import 'listAbsent.dart';
import 'listExcuse.dart';
import 'listPresent.dart';
import 'login.dart';

class attendanceMonitoringResult extends StatefulWidget {
  const attendanceMonitoringResult({super.key});

  @override
  _attendanceMonitoringResultState createState() => _attendanceMonitoringResultState();
}

class _attendanceMonitoringResultState extends State<attendanceMonitoringResult> {


  late final parentGuardian parent;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int study_session=0;

  Future<Map<String?, dynamic?>> _getNameFromSharedPrefs() async {
    final monitor = await SharedPreferences.getInstance();
    String? name = monitor.getString('childname') as String?;
    print("name : ${name}");
    String? surname = monitor.getString('nickname') as String?;
    print("surname : ${surname}");
    String? className = monitor.getString('classroom') as String?;
    return {'name': name, 'className': className, 'nickname':surname};
  }

  Future<int> getChildrenCount(int parentGuardianId) async {
    parentGuardian parent = parentGuardian.calculateChildren(parentGuardianId);
    try {
      int childrenCount = await parent.calculateChildren(parentGuardianId);
      print('sampai sini');
      return childrenCount;

    } catch (e) {
      print('Error calculating children: $e');

      // Return a default value of 0 if the calculation fails
      return 0;
    }
  }

  Future<int> getTotalPresent() async {
    final monitor = await SharedPreferences.getInstance();
    int? student_id = monitor.getInt('student_id');
    print("Student ID: ${student_id}");

    Student parent = Student.findStudentStudySession(student_id!);

    int studentStudySession = await parent.getStudentStudySession(student_id);
    print("studentStudySession : ${studentStudySession}");
    study_session=studentStudySession;
    final study = await SharedPreferences.getInstance();
    await study.setInt('study_session', study_session ?? 0);

    attendance present = attendance.calculate(studentStudySession);
    int totalPresent = await present.TotalPresent(studentStudySession);
    print("total present : ${totalPresent}");
    return totalPresent;
  }

  Future<int> getTotalAbsent() async {

    print(" Calculate Total Absent ");

    final monitor = await SharedPreferences.getInstance();
    int? student_id = monitor.getInt('student_id');
    print("Student ID: ${student_id}");

    Student parent = Student.findStudentStudySession(student_id!);

    int studentStudySession = await parent.getStudentStudySession(student_id);
    print("studentStudySession : ${studentStudySession}");

    attendance absent = attendance.calculate(studentStudySession);
    int totalAbsent = await absent.TotalAbsent(studentStudySession);
    print("total absent : ${totalAbsent}");
    return totalAbsent;
    return 0;
  }

  Future<int> getTotalLeave() async {
    final monitor = await SharedPreferences.getInstance();
    int? student_id = monitor.getInt('student_id');
    print("Student ID: ${student_id}");

    Student parent = Student.findStudentStudySession(student_id!);

    int studentStudySession = await parent.getStudentStudySession(student_id);
    print("studentStudySession : ${studentStudySession}");
    print("hello : ${studentStudySession}");

    final studentStudySessionId = await SharedPreferences.getInstance();
    await studentStudySessionId.setInt('student_study_session_id', studentStudySession ?? 0);

    attendance present = attendance.calculate(studentStudySession);
    int totalLeave = await present.TotalLeave(studentStudySession);
    print("total leave : ${totalLeave}");
    return totalLeave;
  }

  Future<int> getTotalSchoolDay() async {
    // Replace this with your logic to calculate the total number of students
    // This is just an example; adapt it to your actual implementation.
    //int totalStudent = await fetchTotalStudentsFromServer();
    return 245;
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
              top: -30, // Adjusted positioning
              left: -5,
              right: -5,
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
                    right: -34,
                    top: 80,
                    child: CustomPaint(
                      size: const Size(150, 150),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Center(
                          child: FutureBuilder<Map<String?, dynamic?>>(
                            future: _getNameFromSharedPrefs(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final name = snapshot.data?['name'] as String?;
                                final className = snapshot.data?['className'] as String?;
                                return Container(
                                  width: 320,
                                  height: 100,
                                  color: Colors.lightBlue.shade800,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Icon(
                                                  Icons.person_3_rounded,
                                                  color: Colors.white,
                                                  size: 45,
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              children: [
                                                Text(
                                                  name ?? '', // Use a default value if nickname is null
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  className ?? '',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 90),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade900,
                                borderRadius: BorderRadius.circular(15), // Adjust the value to change the roundness
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder<int>(
                                    future: getTotalSchoolDay(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20, // Adjust size if needed
                                            fontWeight: FontWeight.bold, // Adjust weight if needed
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Total School Day',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ListPresent()),
                                );
                              },
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade900,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FutureBuilder <int>(
                                      future: getTotalPresent(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          );
                                        } else if (snapshot.hasError) {
                                          print("snapshot error ${snapshot.error}");
                                          return Text(
                                            'Error: ${snapshot.error}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20, // Adjust size if needed
                                              fontWeight: FontWeight.bold, // Adjust weight if needed
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Total Present',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ListAbsent()), // Instantiate StartPage
                                );
                              },
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade900,
                                  borderRadius: BorderRadius.circular(15), // Adjust the value to change the roundness
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FutureBuilder<int>(
                                      future: getTotalAbsent(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error: ${snapshot.error}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20, // Adjust size if needed
                                              fontWeight: FontWeight.bold, // Adjust weight if needed
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Total Absent',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            GestureDetector(
                              onTap:(){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ListExcuse()), // Instantiate StartPage
                                );
                              },
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade900,
                                  borderRadius: BorderRadius.circular(15), // Adjust the value to change the roundness
                                ),
                                child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[
                                      FutureBuilder<int>(
                                        future: getTotalLeave(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Error: ${snapshot.error}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            );
                                          } else {
                                            return Text(
                                              snapshot.data.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20, // Adjust size if needed
                                                fontWeight: FontWeight.bold, // Adjust weight if needed
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Total Leaves',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),

                                    ]
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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