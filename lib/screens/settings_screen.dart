import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Color iconTextColor;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.iconTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.settings, size: 80, color: iconTextColor),
          SizedBox(height: 16),
          Text('Settings', style: TextStyle(fontSize: 20, color: iconTextColor)),
          SizedBox(height: 24),
          SwitchListTile(
            title: Text('Dark Mode', style: TextStyle(color: iconTextColor)),
            value: isDarkMode,
            onChanged: onThemeChanged,
            activeColor: iconTextColor,
          ),
        ],
      ),
    );
  }
}