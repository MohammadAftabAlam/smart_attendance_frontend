import 'package:flutter/material.dart';
import 'package:freelance/home_screen.dart';

import 'controllers/auth.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      navigateToLoginOrHomeScreen();
    });
  }

  getIsUserLoggedIn() async{
    isLoggedIn =  await AuthService.getLoggedDetail() ?? false;
  }

  void navigateToLoginOrHomeScreen(){
    // print("Is User Logged In: ${isLoggedIn}");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => isLoggedIn == true ? HomeScreen() : LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD7FD),
      body: SafeArea(
        child: Stack(
          children: [
            // Center App Name
            Center(
              child: Text(
                "SMART\nENTRY",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),

            // Bottom Description
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Text(
                "Smart Attendance is a digital system that automates attendance using technologies like QR codes, biometrics, or GPS.It ensures accurate tracking, reduces proxy attendance, and saves time for both students and teachers.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
