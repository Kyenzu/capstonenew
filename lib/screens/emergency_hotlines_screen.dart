import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyHotlinesScreen extends StatefulWidget {
  const EmergencyHotlinesScreen({super.key});

  @override
  State<EmergencyHotlinesScreen> createState() => _EmergencyHotlinesScreenState();
}

class _EmergencyHotlinesScreenState extends State<EmergencyHotlinesScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Home selected')),
      );
    } else if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hotlines selected')),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile selected')),
      );
    }
  }

  Future<void> _callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotlines = [
      {'name': 'Police', 'number': '117'},
      {'name': 'Fire', 'number': '160'},
      {'name': 'Ambulance', 'number': '911'},
      {'name': 'Red Cross', 'number': '143'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Emergency Hotlines')),
      body: ListView.builder(
        itemCount: hotlines.length,
        itemBuilder: (context, index) {
          final hotline = hotlines[index];
          return ListTile(
            leading: Icon(Icons.phone, color: Colors.red),
            title: Text(hotline['name']!),
            subtitle: Text(hotline['number']!),
            onTap: () {
              _callNumber(hotline['number']!);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Hotlines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}