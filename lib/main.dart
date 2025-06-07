import 'package:flutter/material.dart';
import 'screens/login_screen.dart';       // import login screen
// import 'screens/register_screen.dart';    // keep register screen imported for navigation

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),  // Start at LoginScreen
    );
  }
}
