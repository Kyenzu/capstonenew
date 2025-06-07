import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageScreen extends StatefulWidget {
  final Color iconTextColor;
  final int userId; // Pass the logged-in user's ID

  const MessageScreen({
    super.key,
    required this.iconTextColor,
    required this.userId,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String? _userInfo; // Store user info as a string

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    // Replace with your actual backend endpoint
    final url = Uri.parse('http://localhost/capstonenew/my_flutter_api/get_user_info.php?user_id=${widget.userId}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _userInfo =
            "User info: Name: ${data['first_name']} ${data['last_name']}, Email: ${data['email']}, Verified: ${data['is_verified'] == '1' ? 'Yes' : 'No' }.";
      });
    } else {
      setState(() {
        _userInfo = "User info: (could not fetch user info)";
      });
    }
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _isLoading = true;
    });

    // Prepend user info to the prompt
    final prompt = "${_userInfo ?? ''}\nUser: $message";

    // Use your valid Gemini API key here
    const apiKey = 'AIzaSyAL5ofgLWxiSIa4XBcXneTxOPpvlj9O9ys';
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    String botReply = 'Sorry, I could not get a response.';
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      botReply = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? botReply;
    }

    if (!mounted) return; // Prevent setState after dispose
    setState(() {
      _messages.add({'role': 'bot', 'content': botReply});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isUser = msg['role'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    msg['content'] ?? '',
                    style: TextStyle(color: widget.iconTextColor),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: widget.iconTextColor),
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  sendMessage(text);
                  _controller.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}