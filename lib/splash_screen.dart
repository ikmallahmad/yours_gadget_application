import 'package:flutter/material.dart';
import 'package:yours_gadget_latest/views/signup_screen.dart';
import 'views/homepage.dart'; // Import the HomePage screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay to display the splash screen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'images/logo.png', // Replace with your logo
              height: 300,
              width: 300,
            ),
            SizedBox(height: 20),
            // App Name
            SizedBox(height: 10),
            // Loading Indicator
            CircularProgressIndicator(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
