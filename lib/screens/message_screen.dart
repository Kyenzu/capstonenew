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
  String? _userInfo;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      final url = Uri.parse('http://localhost/capstonenew/my_flutter_api/get_user_info.php?user_id=${widget.userId}');
      final response = await http.get(url);
      print('User info status: ${response.statusCode}');
      print('User info body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Use ?? '' for all fields to avoid nulls
        setState(() {
          _userInfo =
              "This is the user's profile:\n"
              "Name: ${data['first_name'] ?? ''} ${data['last_name'] ?? ''}\n"
              "Email: ${data['email'] ?? ''}\n"
              "Phone: ${data['phone'] ?? ''}\n"
              "Date of Birth: ${data['dob'] ?? ''}\n"
              "Age: ${data['age'] ?? ''}\n"
              "Gender: ${data['gender'] ?? ''}\n"
              "Verified: ${data['is_verified'] == 1 || data['is_verified'] == '1' ? 'Yes' : 'No'}\n"
              "Location: Province: ${data['province'] ?? ''}, City: ${data['city'] ?? ''}, Barangay: ${data['barangay'] ?? ''}\n";
        });
        return;
      }
      // If backend fails, set a default user info
      setState(() {
        _userInfo = "This is the user's profile:\nName: Test User\nEmail: test@example.com\nPhone: 1234567890\nLocation: Test City\nVerified: Yes\n";
      });
    } catch (e) {
      setState(() {
        _userInfo = "This is the user's profile:\nName: Test User\nEmail: test@example.com\nPhone: 1234567890\nLocation: Test City\nVerified: Yes\n";
      });
    }
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      _messages.add({'role': 'user', 'content': message}); // Only user's message shown
      _isLoading = true;
    });

    // Always prepend user info to every prompt
    String userInfoSentence = '';
    if (_userInfo != null && _userInfo!.isNotEmpty) {
      userInfoSentence = _userInfo!;
    }
    final prompt = "$userInfoSentence\nUser: $message";

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
    print('Prompt sent to Gemini: $prompt');
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    String botReply = 'Sorry, I could not get a response.';
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      botReply = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? botReply;
    }

    if (!mounted) return;
    setState(() {
      _messages.add({'role': 'bot', 'content': botReply});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? (isUser ? Colors.teal[700] : Colors.grey[850])
                        : (isUser ? Colors.blue[100] : Colors.grey[300]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    msg['content'] ?? '',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
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
              onPressed: _isLoading
                  ? null
                  : () {
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