import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/parentGuardian.dart';
import 'homePage.dart';
import '../model/student.dart';
import 'package:school_attendance_system_fyp/view/applyLeave.dart';
import 'login.dart';

class StudentLeave extends StatefulWidget {
  const StudentLeave({super.key});

  @override
  _StudentLeaveState createState() => _StudentLeaveState();
}

class _StudentLeaveState extends State<StudentLeave> {

  final List<Student> cuti = [];
  late final parentGuardian parent;
  String base64String="";
  String compressData="";
  String fileName="";
  String uploadDate="";
  int? parent_id = 0;
  int year =0;
  int? selectedTeacher_id = 0;
  Student? selectedStudent;



  TextEditingController nameController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController supportingDocumentController = TextEditingController();

  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      _loadData();

    });
  }

  // Method to load data
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    parent_id = prefs.getInt('id') as int?;
    print("Parent ID: ${parent_id}");

    Student child = Student.findChild(parent_id);
    final List<Student> fetchedData = await child.loadChildrenLeaves(parent_id);

    setState(() {
      cuti.clear(); // Clear existing data
      cuti.addAll(fetchedData); // Add fetched data
    });
  }


  Future<Map<String?, dynamic?>> _getNameFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('nickname') as String?;
    int? parentGuardianId = prefs.getInt('id') as int?;
    return {'nickname': name, 'parent_guardian_id': parentGuardianId};

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
                            // Perform logout
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
                  Column(
                    children: [
                      SizedBox(height:40),
                      Text(
                        'Student Leave Status',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height:20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0), // Add desired padding
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ApplyLeave()), // Instantiate StartPage
                                );
                              },
                              child: Text('+ New', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.shade900, // Background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // Rectangle shape
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Center the table vertically
                            children: [
                              SizedBox(height:20),
                              Center(
                                child: DataTable(
                                  border: TableBorder.all(color: Colors.black), // Add border styling to DataTable
                                  dataRowHeight: 80,
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'Student Name',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Reason',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Status',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Start Leave',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'End Leave',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  rows: cuti.map((student) {
                                    return DataRow(cells: [
                                      DataCell(
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0), // Adjust padding here
                                          child: Text(
                                            student.name ?? '',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0), // Adjust padding here
                                          child: Text(
                                            student.leaves!.reason ?? '',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0), // Adjust padding here
                                          child: Text(
                                            student.leaves!.verification_status ?? '',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0), // Adjust padding here
                                          child: Text(
                                            student.leaves!.start_date_leave ?? '',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0), // Adjust padding here
                                          child: Text(
                                            student.leaves!.end_date_leave ?? '',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                    ],
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
