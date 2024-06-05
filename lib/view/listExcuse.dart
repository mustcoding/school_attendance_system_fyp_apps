import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/attendance.dart';
import '../model/parentGuardian.dart';


class ListExcuse extends StatefulWidget {
  const ListExcuse({super.key});

  @override
  _ListExcuseState createState() => _ListExcuseState();
}

class _ListExcuseState extends State<ListExcuse> {

  final List<attendance> present = [];
  late final parentGuardian parent;
  String base64String="";
  String compressData="";
  String fileName="";
  String uploadDate="";
  int? student_study_sesison_id = 0;
  int year =0;
  int? selectedTeacher_id = 0;

  attendance ? listPresent;


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
      print("Welcome list present");
      _loadData();

    });
  }

  // Method to load data
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    student_study_sesison_id = prefs.getInt('student_study_session_id') as int?;

    attendance leave = attendance.find(student_study_sesison_id);
    final List<attendance> fetchedData = await leave.loadChildrenLeaves(student_study_sesison_id);

    setState(() {
      present.clear(); // Clear existing data
      present.addAll(fetchedData); // Add fetched data
    });
  }


  Future<Map<String?, dynamic?>> _getNameFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('nickname') as String?;
    int? parentGuardianId = prefs.getInt('id') as int?;
    return {'nickname': name, 'parent_guardian_id': parentGuardianId};

  }



  void _alertMessage(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }




  void _showMessage(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
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
                            value: 'settings',
                            child: Text('Settings'),
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
                            case 'settings':
                            // Navigate to settings page
                              break;
                            case 'logout':
                            // Perform logout
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
              child: SingleChildScrollView( // Wrap Column with SingleChildScrollView
                child: Column(
                  children: [
                    SizedBox(height:40),
                    Text(
                      'Days Of Leaves',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height:60),
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          border: TableBorder.all(color: Colors.black), // Add border styling to DataTable
                          dataRowHeight: 80,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                '     Bil',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                '              Date Of Leave',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                '              Attendance Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: present.map((attendance) {
                            return DataRow(cells: [
                              DataCell(
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 31.0, vertical: 31.0), // Adjust padding here
                                  child: Text(
                                    (0+1).toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 31.0, vertical: 31.0), // Adjust padding here
                                  child: Text(
                                    attendance.date_time_in ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 31.0, vertical: 31.0), // Adjust padding here
                                  child: Text(
                                    attendance.kehadiran!.name ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
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
