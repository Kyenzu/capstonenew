import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'message_screen.dart'; // Import the MessageScreen
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  final bool isVerified;
  const HomeScreen({super.key, required this.isVerified});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showSettings = false;
  bool _isDarkMode = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showSettings = false;
    });
  }

  void _openSettings() {
    setState(() {
      _showSettings = true;
    });
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  Color get _iconTextColor => _isDarkMode ? Colors.white : Colors.black;

  Widget _buildBody() {
    if (_showSettings) {
      return SettingsScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
        iconTextColor: _iconTextColor,
      );
    }
    switch (_selectedIndex) {
      case 0:
        return Center(child: Text('Welcome to Home Screen!', style: TextStyle(color: _iconTextColor)));
      case 1:
        return MessageScreen(
          iconTextColor: _iconTextColor,
          isDarkMode: _isDarkMode,
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        );
      case 2:
        return Center(child: Text('Notifications', style: TextStyle(color: _iconTextColor)));
      case 3:
        return _buildProfile();
      default:
        return Center(child: Text('Welcome to Home Screen!', style: TextStyle(color: _iconTextColor)));
    }
  }

  Widget _buildProfile() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Verification status
          Text(
            widget.isVerified ? 'Verified Account' : 'Not Verified',
            style: TextStyle(
              color: widget.isVerified ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (!widget.isVerified) ...[
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.credit_card, size: 60, color: Colors.blue),
                        SizedBox(height: 16),
                        Text(
                          "We are required to verify your identity before you can use the application. Your information will be encrypted and stored securely",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context); // Close the dialog

                            // Open camera to capture ID card
                            final ImagePicker picker = ImagePicker();
                            final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

                            if (pickedFile != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('ID card captured: ${pickedFile.name}')),
                              );
                              // TODO: Upload or process the image as needed
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('No image captured')),
                              );
                            }
                          },
                          child: Text('Continue'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(Icons.verified, color: Colors.blue),
              label: Text('Verify Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100],
                foregroundColor: Colors.blue[900],
              ),
            ),
          ],
          SizedBox(height: 12),
          Icon(Icons.person, size: 80, color: _iconTextColor),
          SizedBox(height: 16),
          Text('Your Profile', style: TextStyle(fontSize: 20, color: _iconTextColor)),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Edit Profile tapped')),
              );
            },
            icon: Icon(Icons.edit, color: _iconTextColor),
            label: Text('Edit Profile', style: TextStyle(color: _iconTextColor)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.grey[200],
              foregroundColor: _iconTextColor,
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _openSettings,
            icon: Icon(Icons.settings, color: _iconTextColor),
            label: Text('Settings', style: TextStyle(color: _iconTextColor)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.grey[200],
              foregroundColor: _iconTextColor,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.grey[200],
              foregroundColor: _iconTextColor,
            ),
            child: Text('Logout', style: TextStyle(color: _iconTextColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.white),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black),
            ),
      home: Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: _iconTextColor,
          unselectedItemColor: _isDarkMode ? Colors.white70 : Colors.black54,
          backgroundColor: _isDarkMode ? Colors.black : Colors.white,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home, color: _iconTextColor), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.message, color: _iconTextColor), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications, color: _iconTextColor), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.person, color: _iconTextColor), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}