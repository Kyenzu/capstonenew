import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  final Color iconTextColor;
  final bool isDarkMode;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MessageScreen({
    super.key,
    required this.iconTextColor,
    required this.isDarkMode,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: Center(
        child: Text(
          'This is the Messages screen!',
          style: TextStyle(fontSize: 20, color: iconTextColor),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: iconTextColor,
        unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: iconTextColor), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message, color: iconTextColor), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications, color: iconTextColor), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: iconTextColor), label: 'Profile'),
        ],
      ),
    );
  }
}