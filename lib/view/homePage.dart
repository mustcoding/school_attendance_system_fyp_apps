import 'package:flutter/material.dart';
import 'package:school_attendance_system_fyp/view/absentWarning.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_attendance_system_fyp/view/studentLeave.dart';
import 'package:school_attendance_system_fyp/view/attendanceMonitoring.dart';
import '../model/parentGuardian.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final parentGuardian parent;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<Map<String?, dynamic?>> _getNameFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('nickname') as String?;
    int? parentGuardianId = prefs.getInt('id') as int?;
    return {'nickname': name, 'parent_guardian_id': parentGuardianId};
  }

  Future<int> getChildrenCount(int parentGuardianId) async {
    parentGuardian parent = parentGuardian.calculateChildren(parentGuardianId);
    try {
      int childrenCount = await parent.calculateChildren(parentGuardianId);
      return childrenCount;
    } catch (e) {
      print('Error calculating children: $e');
      // Return a default value of 0 if the calculation fails
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()async{
        return false;
      },
      child: Scaffold(
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
                                  final name = snapshot.data?['nickname'] as String?;
                                  final parentGuardianId = snapshot.data!['parent_guardian_id'];
                                  return FutureBuilder<int>(
                                    future: getChildrenCount(parentGuardianId),
                                    builder: (context, childrenSnapshot) {
                                      if (childrenSnapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (childrenSnapshot.hasError) {
                                        return Text('Error: ${childrenSnapshot.error}');
                                      } else {
                                        final childrenCount = childrenSnapshot.data ?? 0;

                                        return Container(
                                          width: 280,
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
                                                          'CHILDREN: $childrenCount',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
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
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 90),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => StudentLeave()), // Instantiate StartPage
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
                                          Icon(
                                            Icons.assignment_outlined,
                                            color: Colors.white,
                                            size: 45,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Children Leave',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  GestureDetector(
                                    onTap:(){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => attendanceMonitoring()), // Instantiate StartPage
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
                                            Icon(
                                              Icons.computer_rounded,
                                              color: Colors.white,
                                              size: 45,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Attendance Monitor',
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
                              SizedBox(height:30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => absentWarning()), // Instantiate StartPage
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
                                          Icon(
                                            Icons.warning,
                                            color: Colors.white,
                                            size: 45,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Absent Warning',
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
                              )
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