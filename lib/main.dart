import 'package:flutter/material.dart';
import 'package:freelance/controllers/auth.dart';
import 'package:freelance/splash_screen.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xffF3F4EE),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // color: Color(0xffF3F4EE),
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xffF3F4EE)),
        scaffoldBackgroundColor: const Color(0xffF3F4EE),
      ),

      home: SplashScreen(),
    );
  }
}
