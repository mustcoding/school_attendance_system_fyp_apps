import 'package:flutter/material.dart';


import 'login.dart';

class startPage extends StatefulWidget {
  const startPage({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<startPage> {

  @override
  Widget build(BuildContext context) {
    // Delay for 6 seconds
    Future.delayed(const Duration(seconds: 5), () {
      // Navigate to SignIn page after delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()), // Replace SignInPage with your actual SignIn page
      );
    });
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
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -05, // Adjusted positioning
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
              height: double.infinity, // Cover entire height of the screen
              child: Stack(
                children: [
                  Positioned(
                    left: -30,
                    top: 30,
                    child: CustomPaint(
                      size: const Size(280, 280),
                      painter: CirclePainter(Colors.blue.shade100),
                    ),
                  ),
                  Positioned(
                    right: -15,
                    bottom: 75,
                    child: CustomPaint(
                      size: const Size(160, 160),
                      painter: CirclePainter(Colors.blue.shade100),
                    ),
                  ),
                  Positioned(
                    left: -12,
                    bottom: 70,
                    child: CustomPaint(
                      size: const Size(110, 110),
                      painter: CirclePainter(Colors.blue.shade100),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Image.asset(
                              'assets/attendance_icon.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 50),
                            const SizedBox(
                              width: double.infinity, // Changed to cover the entire width
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'SMA Jawahir Al-Ulum',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Attendance System',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const SizedBox(
                              width: double.infinity, // Changed to cover the entire width
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Attendance Monitoring, Leave Evidence,',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'All of it in One Place',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Loading buffer at the bottom
                  const Positioned.fill(
                    bottom: 90,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CircularProgressIndicator(),
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
