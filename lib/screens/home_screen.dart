import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return Center(child: Text('Welcome to Home Screen!', style: TextStyle(color: Colors.black)));
      case 1:
        return Center(child: Text('Messages', style: TextStyle(color: Colors.black)));
      case 2:
        return Center(child: Text('Notifications', style: TextStyle(color: Colors.black)));
      case 3:
        return _buildProfile();
      default:
        return Center(child: Text('Welcome to Home Screen!', style: TextStyle(color: Colors.black)));
    }
  }

  Widget _buildProfile() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // This prevents overflow and centers content
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 80, color: Colors.black),
          SizedBox(height: 16),
          Text('Your Profile', style: TextStyle(fontSize: 20, color: Colors.black)),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: _buildBody(),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message, color: Colors.black), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications, color: Colors.black), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.black), label: 'Profile'),
        ],
      ),
    );
  }
}