import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../Model/parentGuardian.dart';
import 'homePage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late final parentGuardian parent;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _checkAdmin() async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    if (username.isNotEmpty) {
      parentGuardian parent = parentGuardian.login(username, password);

      if (await parent.checkParentExistence()) {

        OneSignal.login(username);

        setState(() {
          usernameController.clear();
        });
        _showMessage("LogIn Successful");
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
        usernameController.clear();
      });
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
                    left: -95,
                    bottom: -430,
                    child: CustomPaint(
                      size: const Size(550, 550),
                      painter: CirclePainter(Colors.blue.shade100),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        ClipOval(
                          child: Image.asset(
                            'assets/jawahir.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: 500,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Column(
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
                                    child: TextField(
                                      controller: usernameController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  '     Password',
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
                                    child: TextField(
                                      controller: passwordController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _checkAdmin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue.shade800,
                          ),
                          child: const Text('Sign In',
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