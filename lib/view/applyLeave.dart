import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/parentGuardian.dart';
import 'homePage.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../model/student.dart';
import '../model/absentSupportingDocument.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  _ApplyLeaveState createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {

  final List<Student> children = [];
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


      final prefs = await SharedPreferences.getInstance();
      parent_id = prefs.getInt('id') as int?;
      print("Parent ID: ${parent_id}");

      Student child = Student.findChild(parent_id);
      children.addAll(await child.loadChildren(parent_id));

      print("children : ${children[0].name}");
      print("teacher : ${children[0].teacher!.name}");
      print("teacher ID: ${children[0].teacher!.id}");
      print("Kelas : ${children[0].kelas!.form_number} ${children[0].kelas!.name}");
    });
  }

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

  void _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Format the selected date
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      // Update the controller with the formatted date
      controller.text = formattedDate;
    }
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile pickedFile = result.files.single;
      String filePath = result.files.single.path!;
      File file = File(filePath);
      fileName = pickedFile.name;

      // Read the file bytes

      Uint8List fileBytes = await file.readAsBytes();

       print("SDDFFD: ${fileBytes}");

      // Store the raw binary data
      base64String = base64Encode(fileBytes);

      // compressData = compressString(base64String);
      // compressData = compressString(compressData);


      print("AFTER COMPRESSED : ${compressData}");

      supportingDocumentController.text = fileName;
    } else {
      // User canceled the picker
    }
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

  // Compress base64 string
  String compressString(String input) {
    List<int> inputBytes = base64Decode(input);
    List<int> compressedBytes = zlib.encode(inputBytes);
    return base64Encode(compressedBytes);
  }

// Decompress base64 string
  String decompressString(String input) {
    List<int> compressedBytes = base64Decode(input);
    List<int> decompressedBytes = zlib.decode(compressedBytes);
    return base64Encode(decompressedBytes);
  }

  void _submit() async {
    final String className = classNameController.text.trim();
    final String teacher = teacherController.text.trim();
    final String startDate = startDateController.text.trim();
    final String endDate = endDateController.text.trim();
    final String reasons = reasonController.text.trim();
    final String fileName = supportingDocumentController.text.trim();

   // parent_id
    //base64String
    DateTime dateRedeem = DateTime.now();
    uploadDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateRedeem);
    String verification_status = "PENDING";
    String verified_date_time = uploadDate;
    int is_Delete = 0;

    if (fileName.isNotEmpty) {
      absentSupportingDocument leave = absentSupportingDocument.add(fileName,
          base64String, uploadDate, verification_status, verified_date_time, reasons,
      parent_id, selectedTeacher_id, is_Delete, startDate, endDate);

      if (await leave.applyLeave()) {
        setState(() {
          nameController.clear();
        });
        _showMessage("Leaves Successfully Being Applied");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Instantiate StartPage
        );
      } else {
        _alertMessage("EMAIL OR PASSWORD WRONG!");
      }
    } else {
      _alertMessage("Please Insert All The Information Needed");
      setState(() {
        nameController.clear();
      });
    }
  }

  // Define _getChildren method
  Future<List<Student>> _getChildren() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate loading delay
    return children;
  }

  void _onStudentSelected(Student? student) {
    if (student != null) {
      setState(() {
        selectedStudent = student;
        final formNumber = student.kelas!.form_number ?? 0;
        final className = formNumber.toString() + ' ' + (student.kelas!.name ?? '');
        classNameController.text = className;
        teacherController.text = student.teacher!.name ?? '';
        selectedTeacher_id = student.teacher!.id ?? 0;
        print("Selected Teacher Id : ${selectedTeacher_id}");
      });
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Student Leave Form',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '    Student Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1.0),
                        Center(
                          child: FutureBuilder<List<Student>>(
                            future: _getChildren(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return DropdownButton<Student>(
                                  value: selectedStudent,
                                  hint: Text('Select Student'),
                                  onChanged: _onStudentSelected,
                                  items: snapshot.data!.map((student) {
                                    return DropdownMenuItem<Student>(
                                      value: student,
                                      child: Text(student.name ?? ''),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '    Class Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1.0),
                        Center(
                          child: Container(
                            width: 300,
                            height:60,
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: TextField(
                              controller: classNameController,
                              readOnly:true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height:5.0),
                        const Text(
                          '    Classroom Teacher',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1.0),
                        Center(
                          child: Container(
                            width: 300,
                            height:60,
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: TextField(
                              controller: teacherController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Start Date of Leave',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 1.0),
                                Center(
                                  child: Container(
                                    width: 145,
                                    height: 60,
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: startDateController,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Select Date', // Placeholder text for date
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.calendar_today),
                                          onPressed: () {
                                            _selectDate(context, startDateController);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width:10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'End Date of Leave',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 1.0),
                                Center(
                                  child: Container(
                                    width: 145,
                                    height: 60,
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: endDateController,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Select Date', // Placeholder text for date
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.calendar_today),
                                          onPressed: () {
                                            _selectDate(context, endDateController);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height:5.0),
                        const Text(
                          '    Reason',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1.0),
                        Center(
                          child: Container(
                            width: 300,
                            height:60,
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: TextField(
                              controller: reasonController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height:5.0),
                        const Text(
                          '    Supporting Document (.pdf)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1.0),
                        Center(
                          child: Container(
                            width: 300,
                            height: 60,
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: supportingDocumentController,
                                    readOnly:true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '', // Placeholder text for document name

                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.insert_drive_file),
                                  onPressed: _openFilePicker,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade800,
                    ),
                    child: const Text('Submit Leave',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
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
