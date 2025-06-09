import 'package:flutter/material.dart';
// import login screen
import 'screens/login_screen.dart';        // import login screen
import 'screens/home_screen.dart';         // import home screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false, // Hide the debug banner
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),  // Start at LoginScreen
    );
  }
}
